import 'package:flutter/material.dart';
import 'package:sphia/app/config/rule.dart';
import 'package:sphia/app/database/database.dart';

class RuleConfigProvider extends ChangeNotifier {
  RuleConfig config;
  List<RuleGroup> ruleGroups = [];

  RuleConfigProvider(this.config, this.ruleGroups);

  void saveConfig() {
    SphiaDatabase.ruleConfigDao.saveConfig();
    notifyListeners();
  }

  void saveConfigWithoutNotify() {
    SphiaDatabase.ruleConfigDao.saveConfig();
  }

  void notify() {
    notifyListeners();
  }
}
