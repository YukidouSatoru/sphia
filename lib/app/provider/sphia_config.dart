import 'package:flutter/material.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/database/database.dart';

class SphiaConfigProvider extends ChangeNotifier {
  SphiaConfig config;

  SphiaConfigProvider(this.config);

  void saveConfig() {
    sphiaConfigDao.saveConfig();
    notifyListeners();
  }

  void saveConfigWithoutNotify() {
    sphiaConfigDao.saveConfig();
  }
}
