import 'package:flutter/material.dart';
import 'package:sphia/app/tray.dart';
import 'package:sphia/core/core_base.dart';
import 'package:sphia/l10n/generated/l10n.dart';

class CoreProvider extends ChangeNotifier {
  List<CoreBase> cores = [];
  bool coreRunning = false;

  void updateCores(List<CoreBase> newCores) {
    cores = newCores;
  }

  void updateCoreRunning(bool newCoreRunning) {
    coreRunning = newCoreRunning;
    notifyListeners();
    SphiaTray.setIcon(coreRunning);
    if (coreRunning) {
      SphiaTray.setMenuItem(S.current.coreStart, true);
      SphiaTray.setMenuItem(S.current.coreStop, false);
    } else {
      SphiaTray.setMenuItem(S.current.coreStart, false);
      SphiaTray.setMenuItem(S.current.coreStop, true);
    }
  }
}
