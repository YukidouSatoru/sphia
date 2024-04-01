import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/provider/config.dart';

part 'sphia_config.g.dart';

@Riverpod(keepAlive: true)
class SphiaConfigNotifier extends _$SphiaConfigNotifier {
  @override
  SphiaConfig build() {
    final config = ref.read(sphiaConfigProvider);
    return config;
  }

  void updateValue(String key, dynamic value) {
    final json = state.toJson();
    json[key] = value;
    state = SphiaConfig.fromJson(json);
    sphiaConfigDao.saveConfig(state);
  }
}
