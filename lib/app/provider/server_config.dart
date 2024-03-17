import 'package:flutter/material.dart';
import 'package:sphia/app/config/server.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/server/server_model.dart';

class ServerConfigProvider extends ChangeNotifier {
  ServerConfig config;
  List<ServerGroup> serverGroups = [];
  List<ServerModel> servers = [];

  ServerConfigProvider(this.config, this.serverGroups);

  void saveConfig() {
    serverConfigDao.saveConfig();
    notifyListeners();
  }

  void saveConfigWithoutNotify() {
    serverConfigDao.saveConfig();
  }
}
