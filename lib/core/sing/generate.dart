import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sphia/app/database/database.dart';
import 'package:sphia/core/rule/extension.dart';
import 'package:sphia/core/rule/sing.dart';
import 'package:sphia/core/sing/config.dart';
import 'package:sphia/util/system.dart';

class SingBoxGenerate {
  static const ipRegExp = r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';

  static Future<String> resolveDns(String dns) async {
    final dnsHost = Uri.parse(dns).host;
    if (!RegExp(ipRegExp).hasMatch(dnsHost) && dnsHost.isNotEmpty) {
      try {
        final dnsIp = (await InternetAddress.lookup(dnsHost)
                .timeout(const Duration(seconds: 2)))
            .first;
        return dns.replaceFirst(dnsHost, dnsIp.address);
      } on Exception catch (_) {
        throw Exception('Failed to resolve DNS server address: $dns');
      }
    }
    return dns;
  }

  static Future<Dns> dns(String remoteDns, String directDns,
      String serverAddress, bool ipv4Only) async {
    remoteDns = await resolveDns(remoteDns);
    directDns = await resolveDns(directDns);

    if (directDns.contains('+local://')) {
      directDns = directDns.replaceFirst('+local', '');
    }

    List<SingBoxDnsRule> dnsRules = [
      SingBoxDnsRule(
        domain: ['geosite:cn'],
        server: 'local',
      ),
    ];

    if (!RegExp(ipRegExp).hasMatch(serverAddress) &&
        serverAddress != '127.0.0.1') {
      dnsRules.add(
        SingBoxDnsRule(
          domain: [serverAddress],
          server: 'local',
        ),
      );
    }

    return Dns(
      servers: [
        DnsServer(
          tag: 'remote',
          address: remoteDns,
          detour: 'proxy',
          strategy: ipv4Only ? 'ipv4_only' : null,
        ),
        DnsServer(
          tag: 'local',
          address: directDns,
          detour: 'direct',
          strategy: ipv4Only ? 'ipv4_only' : null,
        ),
      ],
      rules: dnsRules,
    );
  }

  static Route route(List<Rule> rules, bool configureDns) {
    List<SingBoxRule> singBoxRules = [];
    if (configureDns) {
      singBoxRules.add(
        SingBoxRule(
          protocol: 'dns',
          outbound: 'dns-out',
        ),
      );
    }
    for (var rule in rules) {
      if (rule.enabled) {
        if (rule.outboundTag != 'proxy' &&
            rule.outboundTag != 'direct' &&
            rule.outboundTag != 'block') {
          // multi-outbound
          singBoxRules.add(
            rule.toSingBoxRule()..outbound = 'proxy-${rule.outboundTag}',
          );
        } else {
          singBoxRules.add(rule.toSingBoxRule());
        }
      }
    }
    return Route(
      geoip: Geoip(path: p.join(binPath, 'geoip.db')),
      geosite: Geosite(path: p.join(binPath, 'geosite.db')),
      rules: singBoxRules,
      autoDetectInterface: true,
      finalTag: 'proxy',
    );
  }

  static Inbound mixedInbound(
      String listen, int listenPort, List<User>? users) {
    return Inbound(
      type: 'mixed',
      listen: listen,
      listenPort: listenPort,
      users: users,
    );
  }

  static Inbound tunInbound(
    String? inet4Address,
    String? inet6Address,
    int mtu,
    String stack,
    bool autoRoute,
    bool strictRoute,
    bool sniff,
    bool endpointIndependentNat,
  ) {
    return Inbound(
      type: 'tun',
      inet4Address: inet4Address,
      inet6Address: inet6Address,
      mtu: mtu,
      autoRoute: autoRoute,
      strictRoute: strictRoute,
      stack: stack,
      sniff: sniff,
      endpointIndependentNat: endpointIndependentNat,
    );
  }

  static Outbound generateOutbound(Server server) {
    late Outbound outbound;
    switch (server.protocol) {
      case 'socks':
      case 'vmess':
      case 'vless':
        outbound = xrayOutbound(server);
        break;
      case 'shadowsocks':
        outbound = shadowsocksOutbound(server);
        break;
      case 'trojan':
        outbound = trojanOutbound(server);
        break;
      case 'hysteria':
        outbound = hysteriaOutbound(server);
        break;
      default:
        throw Exception(
            'Sing-Box does not support this server type: ${server.protocol}');
    }
    return outbound;
  }

  static Outbound xrayOutbound(Server server) {
    if (server.protocol == 'socks') {
      return socksOutbound(server);
    } else if (server.protocol == 'vmess' || server.protocol == 'vless') {
      return vProtocolOutbound(server);
    } else {
      throw Exception(
          'Sing-Box does not support this server type: ${server.protocol}');
    }
  }

  static Outbound socksOutbound(Server server) {
    return Outbound(
      type: 'socks',
      server: server.address,
      serverPort: server.port,
      version: '5',
    );
  }

  static Outbound vProtocolOutbound(Server server) {
    final utls = UTls(
      enabled: server.fingerprint != null && server.fingerprint != 'none',
      fingerprint: server.fingerprint,
    );
    final reality = Reality(
      enabled: server.tls == 'reality',
      publicKey: server.publicKey ?? '',
      shortId: server.shortId,
    );
    final tls = Tls(
      enabled: server.tls == 'tls',
      serverName: server.serverName ?? server.address,
      insecure: server.allowInsecure ?? false,
      utls: utls,
      reality: reality,
    );
    final transport = Transport(
      type: server.transport ?? 'tcp',
      host: server.transport == 'httpupgrade'
          ? (server.host ?? server.address)
          : null,
      path: server.transport == 'ws' || server.transport == 'httpupgrade'
          ? (server.path ?? '/')
          : null,
      serviceName:
          server.transport == 'grpc' ? (server.serviceName ?? '/') : null,
    );
    return Outbound(
      type: server.protocol,
      server: server.address,
      serverPort: server.port,
      uuid: server.authPayload,
      flow: server.flow,
      alterId: server.protocol == 'vmess' ? server.alterId : null,
      security: server.protocol == 'vmess' ? server.encryption : null,
      tls: tls,
      transport: transport,
    );
  }

  static Outbound shadowsocksOutbound(Server server) {
    return Outbound(
      type: 'shadowsocks',
      server: server.address,
      serverPort: server.port,
      method: server.encryption,
      password: server.authPayload,
      plugin: server.plugin,
      pluginOpts: server.plugin,
    );
  }

  static Outbound trojanOutbound(Server server) {
    final tls = Tls(
      enabled: true,
      serverName: server.serverName ?? server.address,
      insecure: server.allowInsecure ?? false,
    );
    return Outbound(
      type: 'trojan',
      server: server.address,
      serverPort: server.port,
      password: server.authPayload,
      network: 'tcp',
      tls: tls,
    );
  }

  static Outbound hysteriaOutbound(Server server) {
    final tls = Tls(
      enabled: true,
      serverName: server.serverName ?? server.address,
      insecure: server.allowInsecure ?? false,
      alpn: server.alpn?.split(','),
    );
    return Outbound(
      type: 'hysteria',
      server: server.address,
      serverPort: server.port,
      upMbps: server.upMbps,
      downMbps: server.downMbps,
      obfs: server.obfs,
      auth: server.authType == 'none'
          ? (server.authType == 'base64' ? server.authPayload : null)
          : null,
      authStr: server.authType == 'none'
          ? (server.authType == 'str' ? server.authPayload : null)
          : null,
      recvWindowConn: server.recvWindowConn,
      recvWindow: server.recvWindow,
      tls: tls,
    );
  }
}
