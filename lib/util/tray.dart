import 'package:sphia/app/log.dart';
import 'package:sphia/util/system.dart';
import 'package:tray_manager/tray_manager.dart';

class TrayUtil {
  static Future<void> setIcon({required bool coreRunning}) async {
    logger.i('Setting tray icon');
    await trayManager.setIcon(getIconPath(coreRunning));
  }

  static String getIconPath(bool coreRunning) {
    if (coreRunning) {
      if (SystemUtil.os == OS.macos) {
        return 'assets/tray_no_color_on.png';
      } else {
        return 'assets/tray_color_on.ico';
      }
    } else {
      if (SystemUtil.os == OS.macos) {
        return 'assets/tray_no_color_off.png';
      } else {
        return 'assets/tray_color_off.ico';
      }
    }
  }
}
