import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/provider/data.dart';

part 'server_group.g.dart';

@Riverpod(keepAlive: true)
class ServerGroupNotifier extends _$ServerGroupNotifier {
  @override
  List<ServerGroup> build() {
    final serverGroups = ref.read(serverGroupsProvider);
    return serverGroups;
  }

  void addGroup(ServerGroup group) {
    state = [...state, group];
  }

  void removeGroup(int id) {
    state = state.where((s) => s.id != id).toList();
  }

  void updateGroup(ServerGroup group) {
    state = state.map((s) {
      if (s.id == group.id) {
        return group;
      }
      return s;
    }).toList();
  }

  void setGroups(List<ServerGroup> groups) {
    state = [...groups];
  }

  void clearGroups() {
    state = [];
  }
}
