import 'package:json_annotation/json_annotation.dart';
import 'package:sphia/server/server_base.dart';
import 'package:uuid/uuid.dart';

part 'server.g.dart';

@JsonSerializable(includeIfNull: false)
class XrayServer extends ServerBase {
  String uuid;
  int? alterId;
  String encryption;
  String? flow;
  String transport;
  String? host;
  String? path;
  String? grpcMode;
  String? serviceName;
  String tls;
  String? serverName;
  String? fingerPrint;
  String? publicKey;
  String? shortId;
  String? spiderX;
  bool allowInsecure;

  XrayServer({
    required String protocol,
    required String address,
    required int port,
    required String remark,
    required this.uuid,
    this.alterId,
    required this.encryption,
    this.flow,
    required this.transport,
    this.host,
    this.path,
    this.grpcMode,
    this.serviceName,
    required this.tls,
    this.serverName,
    this.fingerPrint,
    this.publicKey,
    this.shortId,
    this.spiderX,
    required this.allowInsecure,
  }) : super(
          protocol: protocol,
          address: address,
          port: port,
          remark: remark,
        );

  factory XrayServer.defaults() => XrayServer(
        protocol: '',
        address: '',
        port: 0,
        remark: '',
        uuid: const Uuid().v4(),
        alterId: 0,
        encryption: '',
        transport: 'tcp',
        tls: 'none',
        allowInsecure: false,
      );

  factory XrayServer.fromJson(Map<String, dynamic> json) =>
      _$XrayServerFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$XrayServerToJson(this);
}
