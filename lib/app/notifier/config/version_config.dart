import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/config/version.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/provider/config.dart';

part 'version_config.g.dart';

@Riverpod(keepAlive: true)
class VersionConfigNotifier extends _$VersionConfigNotifier {
  @override
  VersionConfig build() {
    final config = ref.read(versionConfigProvider);
    return config;
  }

  void updateVersion(String coreName, String version) async {
    switch (coreName) {
      case 'sing-box':
        state = state.copyWith(singBoxVersion: version);
        break;
      case 'xray-core':
        state = state.copyWith(xrayCoreVersion: version);
        break;
      case 'shadowsocks-rust':
        state = state.copyWith(shadowsocksRustVersion: version);
        break;
      case 'hysteria':
        state = state.copyWith(hysteriaVersion: version);
        break;
      case 'sing-box-rules':
        state = state.copyWith(singBoxRulesVersion: version);
        break;
      case 'v2ray-rules-dat':
        state = state.copyWith(v2rayRulesVersion: version);
        break;
      default:
        break;
    }
    versionConfigDao.saveConfig(state);
  }

  void removeVersion(String coreName) {
    switch (coreName) {
      case 'sing-box':
        state = state.copyWith(singBoxVersion: null);
        break;
      case 'xray-core':
        state = state.copyWith(xrayCoreVersion: null);
        break;
      case 'shadowsocks-rust':
        state = state.copyWith(shadowsocksRustVersion: null);
        break;
      case 'hysteria':
        state = state.copyWith(hysteriaVersion: null);
        break;
      case 'sing-box-rules':
        state = state.copyWith(singBoxRulesVersion: null);
        break;
      case 'v2ray-rules-dat':
        state = state.copyWith(v2rayRulesVersion: null);
        break;
      default:
        break;
    }
    versionConfigDao.saveConfig(state);
  }
}
