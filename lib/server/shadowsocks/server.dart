import 'package:json_annotation/json_annotation.dart';
import 'package:sphia/server/server_base.dart';

part 'server.g.dart';

@JsonSerializable(includeIfNull: false)
class ShadowsocksServer extends ServerBase {
  String password;
  String encryption;
  String? plugin;
  String? pluginOpts;

  ShadowsocksServer({
    required super.protocol,
    required super.address,
    required super.port,
    required super.remark,
    required this.password,
    required this.encryption,
    this.plugin,
    this.pluginOpts,
    super.routingProvider,
    super.protocolProvider,
  });

  factory ShadowsocksServer.defaults() => ShadowsocksServer(
        protocol: 'shadowsocks',
        address: '',
        port: 0,
        remark: '',
        password: '',
        encryption: 'aes-128-gcm',
      );

  factory ShadowsocksServer.fromJson(Map<String, dynamic> json) =>
      _$ShadowsocksServerFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ShadowsocksServerToJson(this);
}
