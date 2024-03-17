import 'package:get_it/get_it.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/core/rule/extension.dart';
import 'package:sphia/core/rule/xray.dart';
import 'package:sphia/core/xray/config.dart';
import 'package:sphia/server/server_model.dart';
import 'package:sphia/server/shadowsocks/server.dart';
import 'package:sphia/server/trojan/server.dart';
import 'package:sphia/server/xray/server.dart';
import 'package:sphia/util/uri/uri.dart';
import 'package:sphia/view/dialog/rule.dart';

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

  static Inbound inbound({
    required String protocol,
    required int port,
    required String listen,
    required bool enableSniffing,
    required bool isAuth,
    required String user,
    required String pass,
    required bool enableUdp,
  }) {
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

  static Outbound generateOutbound(ServerModel server) {
    late Outbound outbound;
    switch (server.protocol) {
      case 'socks':
      case 'vmess':
      case 'vless':
        outbound = xrayOutbound(server as XrayServer);
        break;
      case 'shadowsocks':
        outbound = shadowsocksOutbound(server as ShadowsocksServer);
        break;
      case 'trojan':
        outbound = trojanOutbound(server as TrojanServer);
        break;
      default:
        throw Exception(
            'Xray-Core does not support this server type: ${server.protocol}');
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
          'Xray-Core does not support this server type: ${server.protocol}');
    }
  }

  static Outbound socksOutbound(XrayServer server) {
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

  static Outbound vProtocolOutbound(XrayServer server) {
    String security = server.tls;
    final tlsSettings = security == 'tls'
        ? TlsSettings(
            allowInsecure: server.allowInsecure,
            serverName: server.serverName ?? server.address,
            fingerprint: server.fingerprint,
          )
        : null;
    final realitySettings = security == 'reality'
        ? RealitySettings(
            serverName: server.serverName ?? server.address,
            fingerprint: server.fingerprint ?? 'chrome',
            shortId: server.shortId,
            publicKey: server.publicKey ?? '',
            spiderX: server.spiderX,
          )
        : null;
    final streamSettings = StreamSettings(
      network: server.transport,
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

  static Outbound shadowsocksOutbound(ShadowsocksServer server) {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
    final userAgent = sphiaConfig.getUserAgent();
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
            method: server.encryption,
            password: server.authPayload,
          )
        ],
      ),
      streamSettings: streamSettings,
    );
  }

  static Outbound trojanOutbound(TrojanServer server) {
    final streamSettings = StreamSettings(
      network: 'tcp',
      security: 'tls',
      tlsSettings: TlsSettings(
        allowInsecure: server.allowInsecure,
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

  static Routing routing({
    required String domainStrategy,
    required String domainMatcher,
    required List<Rule> rules,
    required bool enableApi,
  }) {
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
      xrayRules.add(rule.toXrayRule()
        ..outboundTag =
            OutboundTagHelper.determineOutboundTag(rule.outboundTag));
    }
    return Routing(
      domainStrategy: domainStrategy,
      domainMatcher: domainMatcher,
      rules: xrayRules,
    );
  }
}
