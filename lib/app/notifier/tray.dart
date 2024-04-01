import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/notifier/tray_menu.dart';
import 'package:tray_manager/tray_manager.dart';

part 'tray.g.dart';

@Riverpod(keepAlive: true)
class TrayNotifier extends _$TrayNotifier {
  @override
  Future<void> build() async {
    logger.i('Setting tray menu');
    final menu = ref.watch(trayMenuNotifierProvider);
    await trayManager.setContextMenu(Menu(items: menu));
  }
}
