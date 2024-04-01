import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/notifier/data/server_lite.dart';
import 'package:sphia/app/provider/data.dart';
import 'package:sphia/server/server_model.dart';

part 'server.g.dart';

@Riverpod(keepAlive: true)
class ServerNotifier extends _$ServerNotifier {
  @override
  List<ServerModel> build() {
    final servers = ref.read(serversProvider);
    return servers;
  }

  void addServer(ServerModel server) {
    state = [...state, server];
    final notifier = ref.read(serverLiteNotifierProvider.notifier);
    notifier.addServer(server.toLite());
  }

  void addServers(List<ServerModel> servers) {
    state = [...state, ...servers];
    final notifier = ref.read(serverLiteNotifierProvider.notifier);
    notifier.addServers(servers.map((s) => s.toLite()).toList());
  }

  void removeServer(ServerModel server) {
    state = state.where((s) => s.id != server.id).toList();
    final notifier = ref.read(serverLiteNotifierProvider.notifier);
    notifier.removeServer(server.toLite());
  }

  void updateServer(ServerModel server, {bool shouldUpdateLite = true}) {
    state = state.map((s) {
      if (s.id == server.id) {
        return server;
      }
      return s;
    }).toList();
    final notifier = ref.read(serverLiteNotifierProvider.notifier);
    notifier.updateServer(server.toLite());
  }

  void setServers(List<ServerModel> servers) {
    state = [...servers];
    final notifier = ref.read(serverLiteNotifierProvider.notifier);
    notifier.setServers(servers.map((s) => s.toLite()).toList());
  }

  void clearServers() {
    state = [];
    final notifier = ref.read(serverLiteNotifierProvider.notifier);
    notifier.clearServers();
  }
}
