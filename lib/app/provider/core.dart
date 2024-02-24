import 'package:flutter/material.dart';
import 'package:sphia/app/tray.dart';
import 'package:sphia/core/core.dart';

class CoreProvider extends ChangeNotifier {
  List<Core> cores = [];
  bool coreRunning = false;
  bool trafficRunning = false;
  bool tunMode = false;

  Core get proxy {
    if (cores.length == 1) {
      return cores.first;
    } else {
      return cores.firstWhere((core) => !core.isRouting);
    }
  }

  Core get routing => cores.firstWhere((core) => core.isRouting);

  void updateCoreRunning(bool value) {
    coreRunning = value;
    notifyListeners();
    SphiaTray.setIcon(coreRunning);
    if (coreRunning) {
      SphiaTray.setMenuItemCheck('coreStart', true);
      SphiaTray.setMenuItemCheck('coreStop', false);
    } else {
      SphiaTray.setMenuItemCheck('coreStart', false);
      SphiaTray.setMenuItemCheck('coreStop', true);
    }
  }

  void updateTrafficRunning(bool value) {
    trafficRunning = value;
    notifyListeners();
  }

  void updateTunMode(bool value) {
    tunMode = value;
    notifyListeners();
  }
}
