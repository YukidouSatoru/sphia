import 'package:flutter/material.dart';
import 'package:sphia/app/config/server.dart';
import 'package:sphia/app/database/database.dart';

class ServerConfigProvider extends ChangeNotifier {
  ServerConfig config;
  List<ServerGroup> serverGroups = [];
  List<Server> servers = [];

  ServerConfigProvider(this.config, this.serverGroups);

  void saveConfig() {
    SphiaDatabase.serverConfigDao.saveConfig();
    notifyListeners();
  }

  void saveConfigWithoutNotify() {
    SphiaDatabase.serverConfigDao.saveConfig();
  }

  void notify() {
    notifyListeners();
  }
}
