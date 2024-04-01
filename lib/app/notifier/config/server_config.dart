import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/config/server.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/provider/config.dart';

part 'server_config.g.dart';

@Riverpod(keepAlive: true)
class ServerConfigNotifier extends _$ServerConfigNotifier {
  @override
  ServerConfig build() {
    final config = ref.read(serverConfigProvider);
    return config;
  }

  void updateValue(String key, int value) {
    final json = state.toJson();
    json[key] = value;
    state = ServerConfig.fromJson(json);
    serverConfigDao.saveConfig(state);
  }
}
