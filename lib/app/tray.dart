import 'package:get_it/get_it.dart';
import 'package:sphia/app/controller.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/core.dart';
import 'package:sphia/app/provider/rule_config.dart';
import 'package:sphia/app/provider/server_config.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/util/system.dart';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';

class SphiaTray {
  static late Tray _tray;

  static void init() async {
    _tray = Tray();
  }

  static Function get initTray => _tray.initTray;

  static Function get addServerItem => _tray.addServerItem;

  static Function get removeServerItem => _tray.remoteServerItem;

  static Function get generateServerItems => _tray.generateServerItems;

  static Function get modifyServerItemLabel => _tray.modifyServerItemLabel;

  static Function get generateRuleItems => _tray.generateRuleItems;

  static Function get setIcon => _tray.setIcon;

  static Function get setMenu => _tray.setMenu;

  static Function get setMenuItem => _tray.setMenuItem;
}

class Tray {
  final _tray = SystemTray();
  final _menu = Menu();
  List<MenuItemBase> serverItems = [];
  List<MenuItemBase> ruleItems = [];

  Future<void> initTray() async {
    logger.i('Initializing system tray');

    await _tray.initSystemTray(
      title: SystemUtil.os == OS.macos ? null : 'Sphia',
      iconPath: SystemUtil.os == OS.macos
          ? 'assets/tray_no_color_off.png'
          : 'assets/tray_color_off.ico',
    );

    // setMenu();
    _tray.registerSystemTrayEventHandler(
      (eventName) async {
        if (eventName == kSystemTrayEventClick) {
          if (SystemUtil.os == OS.windows) {
            await windowManager.show();
          } else {
            _tray.popUpContextMenu();
          }
        } else if (eventName == kSystemTrayEventRightClick) {
          if (SystemUtil.os == OS.windows) {
            _tray.popUpContextMenu();
          } else {
            await windowManager.show();
          }
        } else if (eventName == kSystemTrayEventDoubleClick) {
          await windowManager.show();
        }
      },
    );
  }

  void addServerItem(Server server) {
    serverItems.add(
      getServerItem(server),
    );
    setMenu();
  }

  void modifyServerItemLabel(int id, String remark) {
    final index = serverItems.indexWhere(
      (element) => element.name == 'server-$id',
    );
    if (index == -1) {
      logger.w('Server item not found');
      return;
    }
    serverItems[index].label = remark;
    setMenu();
  }

  void remoteServerItem(int serverId) {
    serverItems.removeWhere((element) => element.name == 'server-$serverId');
    setMenu();
  }

  void generateServerItems() {
    final serverConfigProvider = GetIt.I.get<ServerConfigProvider>();
    final servers = serverConfigProvider.servers;
    serverItems = [];
    for (var server in servers) {
      serverItems.add(
        getServerItem(server),
      );
    }
  }

  MenuItemCheckbox getServerItem(Server server) {
    final serverConfigProvider = GetIt.I.get<ServerConfigProvider>();
    return MenuItemCheckbox(
      label: server.remark,
      name: 'server-${server.id}',
      onClicked: (menuItem) async {
        if (!menuItem.checked) {
          setMenuItem(
            'server-${serverConfigProvider.config.selectedServerId}',
            false,
          );
          await menuItem.setCheck(true);
          serverConfigProvider.config.selectedServerId = server.id;
          serverConfigProvider.saveConfig();
          final coreProvider = GetIt.I.get<CoreProvider>();
          if (coreProvider.coreRunning) {
            await SphiaController.restartCores();
          }
        } else {
          await menuItem.setCheck(false);
          serverConfigProvider.config.selectedServerId = 0;
          serverConfigProvider.saveConfig();
        }
      },
      checked: server.id == serverConfigProvider.config.selectedServerId,
    );
  }

  void generateRuleItems() {
    final ruleConfigProvider = GetIt.I.get<RuleConfigProvider>();
    ruleItems = [];
    for (var ruleGroup in ruleConfigProvider.ruleGroups) {
      ruleItems.add(
        MenuItemCheckbox(
          label: ruleGroup.name,
          name: 'rule-${ruleGroup.id}',
          onClicked: (menuItem) async {
            if (!menuItem.checked) {
              logger.i('Switching rule group to ${ruleGroup.name}');
              setMenuItem(
                'rule-${ruleConfigProvider.config.selectedRuleGroupId}',
                false,
              );
              await menuItem.setCheck(true);
              ruleConfigProvider.config.selectedRuleGroupId = ruleGroup.id;
              ruleConfigProvider.saveConfig();
              SphiaController.restartCores();
            }
          },
          checked:
              ruleGroup.id == ruleConfigProvider.config.selectedRuleGroupId,
        ),
      );
    }
  }

  void setIcon(bool coreRunning) async {
    logger.i('Setting tray icon');
    await _tray.setImage(getIconPath(coreRunning));
  }

  String getIconPath(bool coreRunning) {
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

  void setMenu() async {
    final serverConfigProvider = GetIt.I.get<ServerConfigProvider>();
    final coreProvider = GetIt.I.get<CoreProvider>();
    logger.i('Setting menu');
    final menuItems = [
      MenuItemCheckbox(
        label: S.current.coreStart,
        name: S.current.coreStart,
        onClicked: (menuItem) async {
          if (!await serverDao.checkServerExistsById(
              serverConfigProvider.config.selectedServerId)) {
            logger.w('Selected server not exists');
            return;
          }
          if (!coreProvider.coreRunning) {
            await SphiaController.toggleCores();
            await menuItem.setCheck(true);
          }
        },
        checked: coreProvider.coreRunning,
      ),
      MenuItemCheckbox(
        label: S.current.coreStop,
        name: S.current.coreStop,
        onClicked: (menuItem) async {
          await SphiaController.stopCores();
        },
        checked: !coreProvider.coreRunning,
      ),
      MenuSeparator(),
      SubMenu(
        label: S.current.servers,
        children: serverItems,
      ),
      SubMenu(
        label: S.current.rules,
        children: ruleItems,
      ),
      MenuSeparator(),
      MenuItemLabel(
        label: S.current.show,
        onClicked: (menuItem) async => await windowManager.show(),
      ),
      MenuItemLabel(
        label: S.current.hide,
        onClicked: (menuItem) async {
          await windowManager.hide();
        },
      ),
      MenuItemLabel(
        label: S.current.exit,
        onClicked: (menuItem) async {
          logger.i('Exiting Sphia');
          // Stop cores
          await SphiaController.stopCores();
          // Close database
          await SphiaDatabase.I.close();
          // Destory tray
          await _tray.destroy();
          // Close logger
          logger.close();
          // Destory window
          await windowManager.destroy();
        },
      ),
    ];
    await _menu.buildFrom(menuItems);
    await _tray.setContextMenu(_menu);
  }

  void setMenuItem(String name, bool checked) async {
    final menuItem = await _menu.findItemByName(name);
    if (menuItem == null) {
      logger.w('Menu item $name not found');
      return;
    }
    logger.i('Setting menu item $name to $checked');
    await _menu.findItemByName(name).setCheck(checked);
  }
}
