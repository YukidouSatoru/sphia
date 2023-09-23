import 'package:json_annotation/json_annotation.dart';
import 'package:sphia/server/server_base.dart';

part 'server.g.dart';

@JsonSerializable(includeIfNull: false)
class TrojanServer extends ServerBase {
  String password;
  String? serverName;
  String? fingerPrint;
  bool allowInsecure;

  TrojanServer({
    required String protocol,
    required String address,
    required int port,
    required String remark,
    required this.password,
    this.serverName,
    this.fingerPrint,
    required this.allowInsecure,
  }) : super(
          protocol: protocol,
          address: address,
          port: port,
          remark: remark,
        );

  factory TrojanServer.defaults() => TrojanServer(
        protocol: 'trojan',
        address: '',
        port: 0,
        remark: '',
        password: '',
        allowInsecure: false,
      );

  factory TrojanServer.fromJson(Map<String, dynamic> json) =>
      _$TrojanServerFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TrojanServerToJson(this);
}
