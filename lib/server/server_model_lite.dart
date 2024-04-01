import 'package:sphia/app/database/database.dart';
import 'package:sphia/server/server_model.dart';

class ServerModelLite {
  final int id;
  final String remark;

  ServerModelLite({required this.id, required this.remark});

  @override
  String toString() => remark;

  Future<ServerModel> toServerModel() async {
    final server = await serverDao.getServerModelById(id);
    if (server == null) {
      throw Exception('Server not found');
    }
    return server;
  }
}
