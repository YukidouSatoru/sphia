import 'package:get_it/get_it.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/core/rule/extension.dart';
import 'package:sphia/core/rule/xray.dart';
import 'package:sphia/core/xray/config.dart';
import 'package:sphia/util/uri/uri.dart';

class XrayGenerate {
  static Dns dns(String remoteDns, String directDns) {
    return Dns(
      servers: [
        DnsServer(
          address: remoteDns,
          domains: ['geosite:geolocation-!cn'],
        ),
        DnsServer(
          address: directDns,
          domains: [
            'geosite:cn',
          ],
          skipFallback: true,
        ),
      ],
    );
  }

  static Inbound inbound(
    String protocol,
    int port,
    String listen,
    bool enableSniffing,
    bool isAuth,
    String user,
    String pass,
    bool enableUdp,
  ) {
    return Inbound(
      port: port,
      listen: listen,
      protocol: protocol,
      sniffing: enableSniffing ? Sniffing() : null,
      settings: InboundSetting(
        auth: isAuth ? 'password' : 'noauth',
        accounts: isAuth
            ? [
                Accounts(
                  user: user,
                  pass: pass,
                ),
              ]
            : null,
        udp: enableUdp,
      ),
    );
  }

  static Inbound dokodemoInbound(int apiPort) {
    return Inbound(
      tag: 'api',
      port: apiPort,
      listen: '127.0.0.1',
      protocol: 'dokodemo-door',
      settings: InboundSetting(address: '127.0.0.1'),
    );
  }

  static Outbound generateOutbound(Server server) {
    late Outbound outbound;
    switch (server.protocol) {
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
      default:
        throw Exception(
            'Xray-Core does not support this server type: ${server.protocol}');
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
          'Xray-Core does not support this server type: ${server.protocol}');
    }
  }

  static Outbound socksOutbound(Server server) {
    return Outbound(
      protocol: 'socks',
      tag: 'proxy',
      settings: OutboundSetting(
        servers: [
          Socks(
            address: server.address,
            port: server.port,
          ),
        ],
      ),
    );
  }

  static Outbound vProtocolOutbound(Server server) {
    String security = server.tls ?? 'none';
    final tlsSettings = security == 'tls'
        ? TlsSettings(
            allowInsecure: server.allowInsecure ?? false,
            serverName: server.serverName ?? server.address,
            fingerprint: server.fingerprint,
          )
        : null;
    final realitySettings = security == 'reality'
        ? RealitySettings(
            serverName: server.serverName ?? server.address,
            fingerprint: server.fingerprint ?? 'chrome',
            shortID: server.shortId,
            publicKey: server.publicKey ?? '',
            spiderX: server.spiderX,
          )
        : null;
    final streamSettings = StreamSettings(
      network: server.transport ?? 'tcp',
      security: security,
      tlsSettings: tlsSettings,
      realitySettings: realitySettings,
      wsSettings: server.transport == 'ws'
          ? WsSettings(
              path: server.path ?? '/',
              headers: Headers(host: server.host ?? server.address),
            )
          : null,
      grpcSettings: server.transport == 'grpc'
          ? GrpcSettings(
              serviceName: server.serviceName ?? '/',
              multiMode: server.grpcMode == 'multi',
            )
          : null,
    );
    return Outbound(
      protocol: server.protocol,
      tag: 'proxy',
      settings: OutboundSetting(
        vnext: [
          Vnext(
            address: server.address,
            port: server.port,
            users: [
              User(
                id: server.authPayload,
                encryption:
                    server.protocol == 'vless' ? server.encryption : null,
                flow: server.flow,
                security: server.protocol == 'vmess' ? server.encryption : null,
                alterId: server.protocol == 'vmess' ? server.alterId : null,
              ),
            ],
          ),
        ],
      ),
      streamSettings: streamSettings,
    );
  }

  static Outbound shadowsocksOutbound(Server server) {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
    final userAgent = userAgents[UserAgent.values[sphiaConfig.userAgent].name]!;
    StreamSettings? streamSettings;
    String? network;
    String security = 'none';
    TlsSettings? tlsSettings;
    String? host;
    if (server.plugin != null) {
      if (server.pluginOpts != null) {
        final pluginParameters = UriUtil.extractPluginOpts(server.pluginOpts!);

        if (pluginParameters['obfs'] == 'ws') {
          network = 'ws';
        } else if (pluginParameters['obfs'] == 'http') {
          network = 'tcp';
        } else if (pluginParameters['obfs'] == 'tls') {
          network = 'tcp';
        }

        if (pluginParameters['obfs'] == 'tls') {
          security = 'tls';
        }

        tlsSettings = security == 'tls'
            ? TlsSettings(
                allowInsecure: false,
                serverName: pluginParameters['obfs-host'] ?? server.address,
              )
            : null;

        host = pluginParameters['obfs-host'] ?? server.address;
      }

      if (network != null) {
        streamSettings = StreamSettings(
          network: network,
          security: security,
          tlsSettings: tlsSettings,
          tcpSettings: network == 'tcp'
              ? TcpSettings(
                  header: Header(
                    type: 'http',
                    request: Request.defaults()
                      ..headers = (TcpHeaders.defaults()
                        ..host = host != null ? [host] : [server.address]
                        ..userAgent = [userAgent]),
                  ),
                )
              : null,
          wsSettings: network == 'ws'
              ? WsSettings(
                  path: '',
                  headers: Headers(
                    host: host ?? server.address,
                  ),
                )
              : null,
          grpcSettings: network == 'grpc'
              ? GrpcSettings(
                  serviceName: host ?? server.address,
                )
              : null,
        );
      }
    }
    return Outbound(
      protocol: 'shadowsocks',
      tag: 'proxy',
      settings: OutboundSetting(
        servers: [
          Shadowsocks(
            address: server.address,
            port: server.port,
            method: server.encryption ?? 'aes-128-gcm',
            password: server.authPayload,
          )
        ],
      ),
      streamSettings: streamSettings,
    );
  }

  static Outbound trojanOutbound(Server server) {
    final streamSettings = StreamSettings(
      network: 'tcp',
      security: 'tls',
      tlsSettings: TlsSettings(
        allowInsecure: server.allowInsecure ?? false,
        serverName: server.serverName ?? server.address,
      ),
    );
    return Outbound(
      protocol: 'trojan',
      tag: 'proxy',
      settings: OutboundSetting(
        servers: [
          Trojan(
            address: server.address,
            port: server.port,
            password: server.authPayload,
          ),
        ],
      ),
      streamSettings: streamSettings,
    );
  }

  static Routing routing(String domainStrategy, String domainMatcher,
      List<Rule> rules, bool enableApi) {
    List<XrayRule> xrayRules = [];
    if (enableApi) {
      xrayRules.add(
        XrayRule(
          inboundTag: 'api',
          outboundTag: 'api',
        ),
      );
    }
    for (var rule in rules) {
      if (rule.enabled) {
        xrayRules.add(rule.toXrayRule());
      }
    }
    return Routing(
      domainStrategy: domainStrategy,
      domainMatcher: domainMatcher,
      rules: xrayRules,
    );
  }
}
