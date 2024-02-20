import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sphia/app/provider/core.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/task/subscription.dart';
import 'package:sphia/app/task/task.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/util/system.dart';
import 'package:sphia/view/page/wrapper.dart';
import 'package:sphia/view/widget/widget.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sphiaConfigProvider = Provider.of<SphiaConfigProvider>(context);
    final sphiaConfig = sphiaConfigProvider.config;
    final coreProvider = Provider.of<CoreProvider>(context);

    final sphiaWidgets = [
      SphiaWidget.checkboxCard(
        value: sphiaConfig.startOnBoot,
        title: S.of(context).startOnBoot,
        onChanged: (value) {
          if (value != null) {
            sphiaConfig.startOnBoot = value;
            sphiaConfigProvider.saveConfig();
            SystemUtil.configureStartup();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).startOnBootMsg,
              ),
            );
          }
        },
      ),
      SphiaWidget.checkboxCard(
        value: sphiaConfig.autoRunServer,
        title: S.of(context).autoRunServer,
        onChanged: (value) {
          if (value != null) {
            sphiaConfig.autoRunServer = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).autoRunServerMsg,
              ),
            );
          }
        },
      ),
      const Divider(),
      SphiaWidget.checkboxCard(
        value: sphiaConfig.useMaterial3,
        title: S.of(context).useMaterial3,
        onChanged: (value) {
          if (value != null) {
            sphiaConfig.useMaterial3 = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).useMaterial3Msg,
              ),
            );
          }
        },
      ),
      SphiaWidget.itemsCard(
        value: sphiaConfig.navigationStyle,
        title: S.of(context).navigationStyle,
        items: navigationStyleList,
        update: (value) {
          if (value != null) {
            sphiaConfig.navigationStyle = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).navigationStyleMsg,
              ),
            );
          }
        },
        context: context,
      ),
      SphiaWidget.checkboxCard(
        value: sphiaConfig.darkMode,
        title: S.of(context).darkMode,
        onChanged: (value) {
          if (value != null) {
            sphiaConfig.darkMode = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).darkModeMsg,
              ),
            );
          }
        },
      ),
      SphiaWidget.colorsCard(
        value: sphiaConfig.themeColor,
        title: S.of(context).themeColor,
        items: {
          Colors.red.value: 'Red',
          Colors.orange.value: 'Orange',
          Colors.yellow.value: 'Yellow',
          Colors.green.value: 'Green',
          Colors.lightBlue.value: 'Light Blue',
          Colors.blue.value: 'Blue',
          Colors.cyan.value: 'Cyan',
          Colors.deepPurple.value: 'Deep Purple',
        },
        update: (value) {
          if (value != null) {
            sphiaConfig.themeColor = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).themeColorMsg,
              ),
            );
          }
        },
        context: context,
      ),
      SphiaWidget.textCard(
        value:
            "${sphiaConfig.themeColor >> 24},${(sphiaConfig.themeColor >> 16) & 0xFF},${(sphiaConfig.themeColor >> 8) & 0xFF},${sphiaConfig.themeColor & 0xFF}",
        title: S.of(context).themeColorArgb,
        update: (value) {
          if (value != null) {
            late int a, r, g, b;
            try {
              a = int.parse(value.split(',')[0]);
              r = int.parse(value.split(',')[1]);
              g = int.parse(value.split(',')[2]);
              b = int.parse(value.split(',')[3]);
            } on Exception catch (_) {
              _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
              _scaffoldMessengerKey.currentState?.showSnackBar(
                SphiaWidget.snackBar(
                  S.of(context).themeColorWarn,
                ),
              );
              return;
            }
            legalValue(int number) => (number >= 0 && number < 256);
            if (legalValue(a) &&
                legalValue(r) &&
                legalValue(g) &&
                legalValue(b)) {
              final argbValue = (a << 24) | (r << 16) | (g << 8) | b;
              sphiaConfig.themeColor = argbValue;
              sphiaConfigProvider.saveConfig();
              _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
              _scaffoldMessengerKey.currentState?.showSnackBar(
                SphiaWidget.snackBar(
                  S.of(context).themeColorMsg,
                ),
              );
            } else {
              _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
              _scaffoldMessengerKey.currentState?.showSnackBar(
                SphiaWidget.snackBar(
                  S.of(context).themeColorWarn,
                ),
              );
            }
          }
        },
        context: context,
      ),
      const Divider(),
      SphiaWidget.checkboxCard(
        value: sphiaConfig.showTransport,
        title: S.of(context).showTransport,
        onChanged: (value) {
          if (value != null) {
            sphiaConfig.showTransport = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).showTransportMsg,
              ),
            );
          }
        },
      ),
      SphiaWidget.checkboxCard(
        value: sphiaConfig.showAddress,
        title: S.of(context).showAddress,
        onChanged: (value) {
          if (value != null) {
            sphiaConfig.showAddress = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).showAddressMsg,
              ),
            );
          }
        },
      ),
      const Divider(),
      SphiaWidget.checkboxCard(
        value: sphiaConfig.enableStatistics,
        title: S.of(context).enableStatistics,
        onChanged: (value) {
          if (value != null) {
            sphiaConfig.enableStatistics = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).enableStatisticsMsg,
              ),
            );
          }
        },
        enabled: !coreProvider.coreRunning,
      ),
      SphiaWidget.checkboxCard(
        value: sphiaConfig.enableSpeedChart,
        title: S.of(context).enableSpeedChart,
        onChanged: (value) {
          if (value != null) {
            sphiaConfig.enableSpeedChart = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).enableSpeedChartMsg,
              ),
            );
          }
        },
      ),
      const Divider(),
      SphiaWidget.textCard(
        value: sphiaConfig.updateSubscriptionInterval.toString(),
        title: S.of(context).updateSubscriptionInterval,
        update: (value) {
          if (value != null) {
            late final int? newValue;
            if ((newValue = int.tryParse(value)) == null) {
              _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
              _scaffoldMessengerKey.currentState?.showSnackBar(
                SphiaWidget.snackBar(
                  S.of(context).updateSubscriptionIntervalWarn,
                ),
              );
              return;
            }
            if (newValue! < 0 && newValue != -1) {
              _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
              _scaffoldMessengerKey.currentState?.showSnackBar(
                SphiaWidget.snackBar(
                  S.of(context).updateSubscriptionIntervalWarn,
                ),
              );
              return;
            }
            sphiaConfig.updateSubscriptionInterval = newValue;
            sphiaConfigProvider.saveConfig();
            if (sphiaConfig.updateSubscriptionInterval != -1) {
              SphiaTask.addTask(SubscriptionTask.generate());
            } else {
              SphiaTask.cancelTask(SubscriptionTask.name);
            }
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).updateSubscriptionIntervalMsg,
              ),
            );
          }
        },
        context: context,
      ),
      SphiaWidget.checkboxCard(
        value: sphiaConfig.updateThroughProxy,
        title: S.of(context).updateThroughProxy,
        onChanged: (value) {
          if (value != null) {
            sphiaConfig.updateThroughProxy = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).updateThroughProxyMsg,
              ),
            );
          }
        },
      ),
      SphiaWidget.itemsCard(
        value: sphiaConfig.userAgent,
        title: S.of(context).userAgent,
        items: userAgentList,
        update: (value) {
          if (value != null) {
            sphiaConfig.userAgent = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).userAgentMsg,
              ),
            );
          }
        },
        context: context,
      ),
    ];
    final proxyWidgets = [
      SphiaWidget.checkboxCard(
        value: sphiaConfig.autoGetIp,
        title: S.of(context).autoGetIp,
        onChanged: (value) {
          if (value != null) {
            sphiaConfig.autoGetIp = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).autoGetIpMsg,
              ),
            );
          }
        },
      ),
      SphiaWidget.checkboxCard(
        value: sphiaConfig.multiOutboundSupport,
        title: S.of(context).multiOutboundSupport,
        onChanged: (value) {
          if (value != null) {
            sphiaConfig.multiOutboundSupport = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).multiOutboundSupportMsg,
              ),
            );
          }
        },
        enabled: !coreProvider.coreRunning,
      ),
      SphiaWidget.checkboxCard(
        value: sphiaConfig.autoConfigureSystemProxy,
        title: S.of(context).autoConfigureSystemProxy,
        onChanged: (value) {
          if (value != null) {
            sphiaConfig.autoConfigureSystemProxy = value;
            if (value) {
              sphiaConfig.enableTun = false;
            }
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).autoConfigureSystemProxyMsg,
              ),
            );
          }
        },
        enabled: !coreProvider.coreRunning,
      ),
      SphiaWidget.checkboxCard(
        value: sphiaConfig.enableTun,
        title: S.of(context).enableTun,
        onChanged: (value) {
          if (value != null) {
            sphiaConfig.enableTun = value;
            if (value) {
              sphiaConfig.autoConfigureSystemProxy = false;
            }
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).enableTunMsg,
              ),
            );
          }
        },
      ),
      const Divider(),
      SphiaWidget.textCard(
        value: sphiaConfig.socksPort.toString(),
        title: S.of(context).socksPort,
        update: (value) {
          if (value != null) {
            late final int? newValue;
            if ((newValue = int.tryParse(value)) == null ||
                newValue! < 0 ||
                newValue > 65535) {
              _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
              _scaffoldMessengerKey.currentState?.showSnackBar(
                SphiaWidget.snackBar(
                  S.of(context).portInvalidMsg,
                ),
              );
              return;
            }
            sphiaConfig.socksPort = newValue;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).socksPortMsg,
              ),
            );
          }
        },
        context: context,
        enabled: !coreProvider.coreRunning,
      ),
      SphiaWidget.textCard(
        value: sphiaConfig.httpPort.toString(),
        title: S.of(context).httpPort,
        update: (value) {
          if (value != null) {
            late final int? newValue;
            if ((newValue = int.tryParse(value)) == null ||
                newValue! < 0 ||
                newValue > 65535) {
              _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
              _scaffoldMessengerKey.currentState?.showSnackBar(
                SphiaWidget.snackBar(
                  S.of(context).portInvalidMsg,
                ),
              );
              return;
            }
            sphiaConfig.httpPort = newValue;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).httpPortMsg,
              ),
            );
          }
        },
        context: context,
        enabled: !coreProvider.coreRunning,
      ),
      SphiaWidget.textCard(
        value: sphiaConfig.mixedPort.toString(),
        title: S.of(context).mixedPort,
        update: (value) {
          if (value != null) {
            late final int? newValue;
            if ((newValue = int.tryParse(value)) == null ||
                newValue! < 0 ||
                newValue > 65535) {
              _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
              _scaffoldMessengerKey.currentState?.showSnackBar(
                SphiaWidget.snackBar(
                  S.of(context).portInvalidMsg,
                ),
              );
              return;
            }
            sphiaConfig.mixedPort = newValue;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).mixedPortMsg,
              ),
            );
          }
        },
        context: context,
        enabled: !coreProvider.coreRunning,
      ),
      SphiaWidget.textCard(
        value: sphiaConfig.listen,
        title: S.of(context).listen,
        update: (value) {
          if (value != null) {
            sphiaConfig.listen = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).listenMsg,
              ),
            );
          }
        },
        context: context,
        enabled: !coreProvider.coreRunning,
      ),
      SphiaWidget.checkboxCard(
        value: sphiaConfig.enableUdp,
        title: S.of(context).enableUdp,
        onChanged: (value) {
          if (value != null) {
            sphiaConfig.enableUdp = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).enableUdpMsg,
              ),
            );
          }
        },
        enabled: !coreProvider.coreRunning,
      ),
      const Divider(),
      SphiaWidget.checkboxCard(
        value: sphiaConfig.authentication,
        title: S.of(context).authentication,
        onChanged: (value) {
          if (value != null) {
            sphiaConfig.authentication = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).authenticationMsg,
              ),
            );
          }
        },
        enabled: !coreProvider.coreRunning,
      ),
      SphiaWidget.textCard(
        value: sphiaConfig.user,
        title: S.of(context).user,
        update: (value) {
          if (value != null) {
            sphiaConfig.user = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).userMsg,
              ),
            );
          }
        },
        context: context,
        enabled: !coreProvider.coreRunning,
      ),
      SphiaWidget.textCard(
        value: sphiaConfig.password,
        title: S.of(context).password,
        update: (value) {
          if (value != null) {
            sphiaConfig.password = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).passwordMsg,
              ),
            );
          }
        },
        context: context,
        enabled: !coreProvider.coreRunning,
      ),
    ];
    final coreWidgets = [
      SphiaWidget.textCard(
        value: sphiaConfig.coreApiPort.toString(),
        title: S.of(context).coreApiPort,
        update: (value) {
          if (value != null) {
            late final int? newValue;
            if ((newValue = int.tryParse(value)) == null ||
                newValue! < 0 ||
                newValue > 65535) {
              _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
              _scaffoldMessengerKey.currentState?.showSnackBar(
                SphiaWidget.snackBar(
                  S.of(context).portInvalidMsg,
                ),
              );
              return;
            }
            sphiaConfig.coreApiPort = newValue;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).coreApiPortMsg,
              ),
            );
          }
        },
        context: context,
        enabled: !coreProvider.coreRunning,
      ),
      const Divider(),
      SphiaWidget.checkboxCard(
        value: sphiaConfig.enableSniffing,
        title: S.of(context).enableSniffing,
        onChanged: (value) {
          if (value != null) {
            sphiaConfig.enableSniffing = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).enableSniffingMsg,
              ),
            );
          }
        },
      ),
      SphiaWidget.checkboxCard(
        value: sphiaConfig.configureDns,
        title: S.of(context).configureDns,
        onChanged: (value) {
          if (value != null) {
            sphiaConfig.configureDns = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).configureDnsMsg,
              ),
            );
          }
        },
      ),
      SphiaWidget.textCard(
        value: sphiaConfig.remoteDns,
        title: S.of(context).remoteDns,
        update: (value) {
          if (value != null) {
            sphiaConfig.remoteDns = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).remoteDnsMsg,
              ),
            );
          }
        },
        context: context,
      ),
      SphiaWidget.textCard(
        value: sphiaConfig.directDns,
        title: S.of(context).directDns,
        update: (value) {
          if (value != null) {
            sphiaConfig.directDns = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).directDnsMsg,
              ),
            );
          }
        },
        context: context,
      ),
      const Divider(),
      SphiaWidget.itemsCard(
        value: sphiaConfig.domainStrategy,
        title: S.of(context).domainStrategy,
        items: domainStrategyList,
        update: (value) {
          if (value != null) {
            sphiaConfig.domainStrategy = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).domainStrategyMsg,
              ),
            );
          }
        },
        context: context,
      ),
      SphiaWidget.itemsCard(
        value: sphiaConfig.domainMatcher,
        title: S.of(context).domainMatcher,
        items: domainMatcherList,
        update: (value) {
          if (value != null) {
            sphiaConfig.domainMatcher = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).domainMatcherMsg,
              ),
            );
          }
        },
        context: context,
      ),
      const Divider(),
      SphiaWidget.checkboxCard(
        value: sphiaConfig.enableCoreLog,
        title: S.of(context).enableCoreLog,
        onChanged: (value) {
          if (value != null) {
            sphiaConfig.enableCoreLog = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).enableCoreLogMsg,
              ),
            );
          }
        },
      ),
      SphiaWidget.itemsCard(
        value: sphiaConfig.logLevel,
        title: S.of(context).logLevel,
        items: logLevelList,
        update: (value) {
          if (value != null) {
            sphiaConfig.logLevel = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).logLevelMsg,
              ),
            );
          }
        },
        context: context,
      ),
      SphiaWidget.textCard(
        value: sphiaConfig.maxLogCount.toString(),
        title: S.of(context).maxLogCount,
        update: (value) {
          if (value != null) {
            late final int? newValue;
            if ((newValue = int.tryParse(value)) == null || newValue! < 0) {
              _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
              _scaffoldMessengerKey.currentState?.showSnackBar(
                SphiaWidget.snackBar(
                  S.of(context).enterValidNumberMsg,
                ),
              );
              return;
            }
            sphiaConfig.maxLogCount = newValue;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).maxLogCountMsg,
              ),
            );
          }
        },
        context: context,
      ),
      SphiaWidget.checkboxCard(
        value: sphiaConfig.saveCoreLog,
        title: S.of(context).saveCoreLog,
        onChanged: (value) {
          if (value != null) {
            sphiaConfig.saveCoreLog = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).saveCoreLogMsg,
              ),
            );
          }
        },
      ),
    ];

    final providerWidgets = [
      SphiaWidget.itemsCard(
        value: sphiaConfig.routingProvider,
        title: S.of(context).routingProvider,
        items: routingProviderList,
        update: (value) {
          if (value != null) {
            sphiaConfig.routingProvider = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).routingProviderMsg,
              ),
            );
          }
        },
        context: context,
      ),
      SphiaWidget.itemsCard(
        value: sphiaConfig.vmessProvider,
        title: S.of(context).vmessProvider,
        items: vmessProviderList,
        update: (value) {
          if (value != null) {
            sphiaConfig.vmessProvider = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).vmessProviderMsg,
              ),
            );
          }
        },
        context: context,
      ),
      SphiaWidget.itemsCard(
        value: sphiaConfig.vlessProvider,
        title: S.of(context).vlessProvider,
        items: vlessProviderList,
        update: (value) {
          if (value != null) {
            sphiaConfig.vlessProvider = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).vlessProviderMsg,
              ),
            );
          }
        },
        context: context,
      ),
      SphiaWidget.itemsCard(
        value: sphiaConfig.shadowsocksProvider,
        title: S.of(context).shadowsocksProvider,
        items: shadowsocksProviderList,
        update: (value) {
          if (value != null) {
            sphiaConfig.shadowsocksProvider = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).shadowsocksProviderMsg,
              ),
            );
          }
        },
        context: context,
      ),
      SphiaWidget.itemsCard(
        value: sphiaConfig.trojanProvider,
        title: S.of(context).trojanProvider,
        items: trojanProviderList,
        update: (value) {
          if (value != null) {
            sphiaConfig.trojanProvider = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).trojanProviderMsg,
              ),
            );
          }
        },
        context: context,
      ),
      SphiaWidget.itemsCard(
        value: sphiaConfig.hysteriaProvider,
        title: S.of(context).hysteriaProvider,
        items: ['sing-box', 'hysteria'],
        update: (value) {
          if (value != null) {
            sphiaConfig.hysteriaProvider = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).hysteriaProviderMsg,
              ),
            );
          }
        },
        context: context,
      ),
      const Divider(),
      SphiaWidget.textCard(
        value: sphiaConfig.additionalSocksPort.toString(),
        title: S.of(context).additionalSocksPort,
        update: (value) {
          if (value != null) {
            late final int? newValue;
            if ((newValue = int.tryParse(value)) == null ||
                newValue! < 0 ||
                newValue > 65535) {
              _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
              _scaffoldMessengerKey.currentState?.showSnackBar(
                SphiaWidget.snackBar(
                  S.of(context).portInvalidMsg,
                ),
              );
              return;
            }
            sphiaConfig.additionalSocksPort = newValue;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).additionalSocksPortMsg,
              ),
            );
          }
        },
        context: context,
        enabled: !coreProvider.coreRunning,
      ),
    ];
    final tunWidgets = [
      SphiaWidget.itemsCard(
        value: sphiaConfig.tunProvider,
        title: S.of(context).tunProvider,
        items: tunProviderList,
        update: (value) {
          if (value != null) {
            sphiaConfig.tunProvider = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).tunProviderMsg,
              ),
            );
          }
        },
        context: context,
      ),
      const Divider(),
      SphiaWidget.checkboxCard(
        value: sphiaConfig.enableIpv4,
        title: S.of(context).enableIpv4,
        onChanged: (value) {
          if (value != null) {
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).enableIpv4Msg,
              ),
            );
          }
        },
      ),
      SphiaWidget.textCard(
        value: sphiaConfig.ipv4Address,
        title: S.of(context).ipv4Address,
        update: (value) {
          if (value != null) {
            sphiaConfig.ipv4Address = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).ipv4AddressMsg,
              ),
            );
          }
        },
        context: context,
      ),
      SphiaWidget.checkboxCard(
        value: sphiaConfig.enableIpv6,
        title: S.of(context).enableIpv6,
        onChanged: (value) {
          if (value != null) {
            sphiaConfig.enableIpv6 = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).enableIpv6Msg,
              ),
            );
          }
        },
      ),
      SphiaWidget.textCard(
        value: sphiaConfig.ipv6Address,
        title: S.of(context).ipv6Address,
        update: (value) {
          if (value != null) {
            sphiaConfig.ipv4Address = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).ipv6AddressMsg,
              ),
            );
          }
        },
        context: context,
      ),
      const Divider(),
      SphiaWidget.textCard(
        value: sphiaConfig.mtu.toString(),
        title: S.of(context).mtu,
        update: (value) {
          if (value != null) {
            late final int? newValue;
            if ((newValue = int.tryParse(value)) == null) {
              _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
              _scaffoldMessengerKey.currentState?.showSnackBar(
                SphiaWidget.snackBar(
                  S.of(context).enterValidNumberMsg,
                ),
              );
              return;
            }
            sphiaConfig.mtu = newValue!;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).mtuMsg,
              ),
            );
          }
        },
        context: context,
      ),
      SphiaWidget.checkboxCard(
        value: sphiaConfig.endpointIndependentNat,
        title: S.of(context).endpointIndependentNat,
        onChanged: (value) {
          if (value != null) {
            sphiaConfig.endpointIndependentNat = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).endpointIndependentNatMsg,
              ),
            );
          }
        },
      ),
      SphiaWidget.itemsCard(
        value: sphiaConfig.stack,
        title: S.of(context).stack,
        items: tunStackList,
        update: (value) {
          if (value != null) {
            sphiaConfig.stack = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).stackMsg,
              ),
            );
          }
        },
        context: context,
      ),
      SphiaWidget.checkboxCard(
        value: sphiaConfig.autoRoute,
        title: S.of(context).autoRoute,
        onChanged: (value) {
          if (value != null) {
            sphiaConfig.autoRoute = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).autoRouteMsg,
              ),
            );
          }
        },
      ),
      SphiaWidget.checkboxCard(
        value: sphiaConfig.strictRoute,
        title: S.of(context).strictRoute,
        onChanged: (value) {
          if (value != null) {
            sphiaConfig.strictRoute = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SphiaWidget.snackBar(
                S.of(context).strictRouteMsg,
              ),
            );
          }
        },
      ),
    ];

    return DefaultTabController(
      length: 5,
      initialIndex: 0,
      child: ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).settings),
            elevation: 0,
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Sphia'),
                Tab(text: 'Proxy'),
                Tab(text: 'Core'),
                Tab(text: 'Provider'),
                Tab(text: 'Tun'),
              ],
            ),
          ),
          body: PageWrapper(
            child: TabBarView(
              children: [
                ListView(
                  children: sphiaWidgets,
                ),
                ListView(
                  children: proxyWidgets,
                ),
                ListView(
                  children: coreWidgets,
                ),
                ListView(
                  children: providerWidgets,
                ),
                ListView(
                  children: tunWidgets,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
