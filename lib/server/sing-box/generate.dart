import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sphia/server/hysteria/server.dart';
import 'package:sphia/server/server_base.dart';
import 'package:sphia/server/shadowsocks/server.dart';
import 'package:sphia/server/sing-box/config.dart';
import 'package:sphia/server/trojan/server.dart';
import 'package:sphia/server/xray/config.dart' as xray_config;
import 'package:sphia/server/xray/server.dart';
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

    List<DnsRule> dnsRules = [
      DnsRule(
        domain: ['geosite:cn'],
        server: 'local',
      ),
    ];

    if (!RegExp(ipRegExp).hasMatch(serverAddress) &&
        serverAddress != '127.0.0.1') {
      dnsRules.add(
        DnsRule(
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

  static Route route(List<xray_config.XrayRule> rules, bool configureDns) {
    List<RouteRule> routeRules = [];
    if (configureDns) {
      routeRules.add(
        RouteRule(
          protocol: 'dns',
          outbound: 'dns-out',
        ),
      );
    }
    routeRules.addAll(convertRules(rules));
    return Route(
      geoip: Geoip(path: p.join(binPath, 'geoip.db')),
      geosite: Geosite(path: p.join(binPath, 'geosite.db')),
      rules: routeRules,
      autoDetectInterface: true,
      finalTag: 'proxy',
    );
  }

  static List<RouteRule> convertRules(List<xray_config.XrayRule> xrayRules) {
    List<RouteRule> result = [];
    result.add(
      RouteRule(
        processName: SystemUtil.getCoreFileNames(),
        outbound: 'direct',
      ),
    );
    for (var xrayRule in xrayRules) {
      if (xrayRule.enabled) {
        List<String>? geosite;
        List<String>? domain;
        List<String>? geoip;
        List<String>? ipCidr;
        List<int>? port;
        List<String>? portRange;
        if (xrayRule.domain != null) {
          for (var domainItem in xrayRule.domain!) {
            if (domainItem.startsWith('geosite:')) {
              geosite ??= [];
              geosite.add(domainItem.replaceFirst('geosite:', ''));
            } else {
              domain ??= [];
              domain.add(domainItem);
            }
          }
        }
        if (xrayRule.ip != null) {
          for (var ipItem in xrayRule.ip!) {
            if (ipItem.startsWith('geoip:')) {
              geoip ??= [];
              geoip.add(ipItem.replaceFirst('geoip:', ''));
            } else {
              ipCidr ??= [];
              ipCidr.add(ipItem);
            }
          }
        }
        if (xrayRule.port != null) {
          List<String> tempPort = xrayRule.port!.split(',');
          for (var portItem in tempPort) {
            if (portItem.contains('-')) {
              portRange ??= [];
              portRange.add(portItem.replaceAll('-', ':'));
            } else {
              port ??= [];
              port.add(int.parse(portItem));
            }
          }
        }
        result.add(RouteRule(
          geosite: geosite,
          domain: domain,
          geoip: geoip,
          ipCidr: ipCidr,
          port: port,
          portRange: portRange,
          outbound: xrayRule.outboundTag,
        ));
      }
    }
    return result;
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

  static Inbound tunInbound(String? inet4Address, String? inet6Address, int mtu,
      String stack, bool autoRoute, bool strictRoute, bool sniff) {
    return Inbound(
      type: 'tun',
      inet4Address: inet4Address,
      inet6Address: inet6Address,
      mtu: mtu,
      autoRoute: autoRoute,
      strictRoute: strictRoute,
      stack: stack,
      sniff: sniff,
    );
  }

  static Outbound generateOutbound(ServerBase server) {
    late Outbound outbound;
    switch (server.runtimeType) {
      case XrayServer:
        outbound = xrayOutbound(server as XrayServer);
        break;
      case ShadowsocksServer:
        outbound = shadowsocksOutbound(server as ShadowsocksServer);
        break;
      case TrojanServer:
        outbound = trojanOutbound(server as TrojanServer);
        break;
      case HysteriaServer:
        outbound = hysteriaOutbound(server as HysteriaServer);
        break;
      default:
        throw Exception(
            'Sing-Box does not support this server type: ${server.protocol}');
    }
    return outbound;
  }

  static Outbound xrayOutbound(XrayServer server) {
    if (server.protocol == 'socks') {
      return socksOutbound(server);
    } else if (server.protocol == 'vmess' || server.protocol == 'vless') {
      return vProtocolOutbound(server);
    } else {
      throw Exception(
          'Sing-Box does not support this server type: ${server.protocol}');
    }
  }

  static Outbound socksOutbound(XrayServer server) {
    return Outbound(
      type: 'socks',
      tag: 'proxy',
      server: server.address,
      serverPort: server.port,
      version: '5',
    );
  }

  static Outbound vProtocolOutbound(XrayServer server) {
    final utls = UTls(
      enabled: server.fingerPrint != null && server.fingerPrint != 'none',
      fingerprint: server.fingerPrint,
    );
    final reality = Reality(
      enabled: server.tls == 'reality',
      publicKey: server.publicKey ?? '',
      shortId: server.shortId,
    );
    final tls = Tls(
      enabled: server.tls == 'tls',
      serverName: server.serverName ?? server.address,
      insecure: server.allowInsecure,
      utls: utls,
      reality: reality,
    );
    final transport = Transport(
      type: server.transport,
      path: server.transport == 'ws' ? (server.path ?? '/') : null,
      serviceName:
          server.transport == 'grpc' ? (server.serviceName ?? '/') : null,
    );
    return Outbound(
      type: server.protocol,
      tag: 'proxy',
      server: server.address,
      serverPort: server.port,
      uuid: server.uuid,
      flow: server.flow,
      alterId: server.protocol == 'vmess' ? server.alterId : null,
      security: server.protocol == 'vmess' ? server.encryption : null,
      tls: tls,
      transport: transport,
    );
  }

  static Outbound shadowsocksOutbound(ShadowsocksServer server) {
    return Outbound(
      type: 'shadowsocks',
      tag: 'proxy',
      server: server.address,
      serverPort: server.port,
      method: server.encryption,
      password: server.password,
      plugin: server.plugin,
      pluginOpts: server.plugin,
    );
  }

  static Outbound trojanOutbound(TrojanServer server) {
    final tls = Tls(
      enabled: true,
      serverName: server.serverName ?? server.address,
      insecure: server.allowInsecure,
    );
    return Outbound(
      type: 'trojan',
      tag: 'proxy',
      server: server.address,
      serverPort: server.port,
      password: server.password,
      network: 'tcp',
      tls: tls,
    );
  }

  static Outbound hysteriaOutbound(HysteriaServer server) {
    final tls = Tls(
      enabled: true,
      serverName: server.serverName ?? server.address,
      insecure: server.insecure,
      alpn: server.alpn?.split(','),
    );
    return Outbound(
      type: 'hysteria',
      tag: 'proxy',
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
