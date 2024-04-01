import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/provider/data.dart';
import 'package:sphia/server/server_model_lite.dart';

part 'server_lite.g.dart';

@Riverpod(keepAlive: true)
class ServerLiteNotifier extends _$ServerLiteNotifier {
  @override
  List<ServerModelLite> build() {
    final servers = ref.read(serversLiteProvider);
    return servers;
  }

  void addServer(ServerModelLite server) {
    state = [...state, server];
  }

  void addServers(List<ServerModelLite> servers) {
    state = [...state, ...servers];
  }

  void removeServer(ServerModelLite server) {
    state = state.where((s) => s.id != server.id).toList();
  }

  void updateServer(ServerModelLite server) {
    state = state.map((s) {
      if (s.id == server.id) {
        return server;
      }
      return s;
    }).toList();
  }

  void setServers(List<ServerModelLite> servers) {
    state = [...servers];
  }

  void clearServers() {
    state = [];
  }
}
