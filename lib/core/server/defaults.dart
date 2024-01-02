import 'package:drift/drift.dart';
import 'package:sphia/app/database/database.dart';
import 'package:uuid/uuid.dart';

class ServerDefaults {
  static Server defaults(int groupId, int serverId) => Server(
        id: serverId,
        groupId: groupId,
        protocol: '',
        remark: '',
        address: '',
        port: 0,
        authPayload: '',
      );

  static Server xrayDefaults(int groupId, int serverId) =>
      defaults(groupId, serverId).copyWith(
        // protocol will be set handled by the server type
        authPayload: const Uuid().v4(),
        alterId: const Value(0),
        encryption: const Value(''),
        transport: const Value('tcp'),
        tls: const Value('none'),
        allowInsecure: const Value(false),
      );

  static Server shadowsocksDefaults(int groupId, int serverId) =>
      defaults(groupId, serverId).copyWith(
        protocol: 'shadowsocks',
        encryption: const Value('aes-128-gcm'),
      );

  static Server trojanDefaults(int groupId, int serverId) =>
      defaults(groupId, serverId).copyWith(
        protocol: 'trojan',
        tls: const Value('true'),
        allowInsecure: const Value(false),
      );

  static Server hysteriaDefaults(int groupId, int serverId) =>
      defaults(groupId, serverId).copyWith(
        protocol: 'hysteria',
        hysteriaProtocol: const Value('udp'),
        authType: const Value('none'),
        allowInsecure: const Value(false),
        upMbps: const Value(10),
        downMbps: const Value(50),
        recvWindowConn: const Value(15728640),
        recvWindow: const Value(67108864),
        disableMtuDiscovery: const Value(false),
      );
}
