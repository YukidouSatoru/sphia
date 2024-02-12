import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sphia/app/log.dart';
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
        sphiaConfig.startOnBoot,
        S.of(context).startOnBoot,
        (value) {
          if (value != null) {
            logger.i(
                'Updating startOnBoot from ${sphiaConfig.startOnBoot} to $value');
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
        sphiaConfig.autoRunServer,
        S.of(context).autoRunServer,
        (value) {
          if (value != null) {
            logger.i(
                'Updating autoRunServer from ${sphiaConfig.autoRunServer} to $value');
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
        sphiaConfig.useMaterial3,
        S.of(context).useMaterial3,
        (value) {
          if (value != null) {
            logger.i(
                'Updating useMaterial3 from ${sphiaConfig.useMaterial3} to $value');
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
        sphiaConfig.navigationStyle,
        S.of(context).navigationStyle,
        navigationStyleList,
        (value) {
          if (value != null) {
            logger.i(
                'Updating navigationStyle from ${sphiaConfig.navigationStyle} to $value');
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
        context,
      ),
      SphiaWidget.checkboxCard(
        sphiaConfig.darkMode,
        S.of(context).darkMode,
        (value) {
          if (value != null) {
            logger
                .i('Updating darkMode from ${sphiaConfig.darkMode} to $value');
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
        sphiaConfig.themeColor,
        S.of(context).themeColor,
        {
          Colors.red.value: 'Red',
          Colors.orange.value: 'Orange',
          Colors.yellow.value: 'Yellow',
          Colors.green.value: 'Green',
          Colors.lightBlue.value: 'Light Blue',
          Colors.blue.value: 'Blue',
          Colors.cyan.value: 'Cyan',
          Colors.deepPurple.value: 'Deep Purple',
        },
        (value) {
          if (value != null) {
            logger.i(
                'Updating themeColor from ${sphiaConfig.themeColor} to $value');
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
        context,
      ),
      SphiaWidget.textCard(
        "${sphiaConfig.themeColor >> 24},${(sphiaConfig.themeColor >> 16) & 0xFF},${(sphiaConfig.themeColor >> 8) & 0xFF},${sphiaConfig.themeColor & 0xFF}",
        S.of(context).themeColorArgb,
        (value) {
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
              logger.i(
                  'Updating themeColor from ${sphiaConfig.themeColor} to $argbValue');
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
        context,
      ),
      const Divider(),
      SphiaWidget.checkboxCard(
        sphiaConfig.showTransport,
        S.of(context).showTransport,
        (value) {
          if (value != null) {
            logger.i(
                'Updating showTransport from ${sphiaConfig.showTransport} to $value');
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
        sphiaConfig.showAddress,
        S.of(context).showAddress,
        (value) {
          if (value != null) {
            logger.i(
                'Updating showAddress from ${sphiaConfig.showAddress} to $value');
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
        sphiaConfig.enableStatistics,
        S.of(context).enableStatistics,
        (value) {
          if (value != null) {
            logger.i(
                'Updating enableStatistics from ${sphiaConfig.enableStatistics} to $value');
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
      ),
      SphiaWidget.checkboxCard(
        sphiaConfig.enableSpeedChart,
        S.of(context).enableSpeedChart,
        (value) {
          if (value != null) {
            logger.i(
                'Updating enableSpeedChart from ${sphiaConfig.enableSpeedChart} to $value');
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
        sphiaConfig.updateSubscriptionInterval.toString(),
        S.of(context).updateSubscriptionInterval,
        (value) {
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
            logger.i(
                'Updating updateSubscriptionInterval from ${sphiaConfig.updateSubscriptionInterval} to $value');
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
        context,
      ),
      SphiaWidget.checkboxCard(
        sphiaConfig.updateThroughProxy,
        S.of(context).updateThroughProxy,
        (value) {
          if (value != null) {
            logger.i(
                'Updating updateThroughProxy from ${sphiaConfig.updateThroughProxy} to $value');
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
        sphiaConfig.userAgent,
        S.of(context).userAgent,
        userAgentList,
        (value) {
          if (value != null) {
            logger.i(
                'Updating userAgent from ${sphiaConfig.userAgent} to $value');
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
        context,
      ),
    ];
    final proxyWidgets = [
      SphiaWidget.checkboxCard(
        sphiaConfig.autoGetIp,
        S.of(context).autoGetIp,
        (value) {
          if (value != null) {
            logger.i(
                'Updating autoGetIp from ${sphiaConfig.autoGetIp} to $value');
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
        sphiaConfig.multiOutboundSupport,
        S.of(context).multiOutboundSupport,
        (value) {
          if (value != null) {
            logger.i(
                'Updating multiOutboundSupport from ${sphiaConfig.multiOutboundSupport} to $value');
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
      ),
      SphiaWidget.checkboxCard(
        sphiaConfig.autoConfigureSystemProxy,
        S.of(context).autoConfigureSystemProxy,
        (value) {
          if (value != null) {
            logger.i(
                'Updating autoConfigureSystemProxy from ${sphiaConfig.autoConfigureSystemProxy} to $value');
            sphiaConfig.autoConfigureSystemProxy = value;
            if (value) {
              sphiaConfig.enableTun = false;
              logger.i(
                  'Updating enableTun from ${sphiaConfig.enableTun} to false');
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
        !coreProvider.coreRunning,
      ),
      SphiaWidget.checkboxCard(
        sphiaConfig.enableTun,
        S.of(context).enableTun,
        (value) {
          if (value != null) {
            logger.i(
                'Updating enableTun from ${sphiaConfig.enableTun} to $value');
            sphiaConfig.enableTun = value;
            if (value) {
              sphiaConfig.autoConfigureSystemProxy = false;
              logger.i(
                  'Updating autoConfigureSystemProxy from ${sphiaConfig.autoConfigureSystemProxy} to false');
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
        sphiaConfig.socksPort.toString(),
        S.of(context).socksPort,
        (value) {
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
            logger.i(
                'Updating socksPort from ${sphiaConfig.socksPort} to $value');
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
        context,
        !coreProvider.coreRunning,
      ),
      SphiaWidget.textCard(
        sphiaConfig.httpPort.toString(),
        S.of(context).httpPort,
        (value) {
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
            logger
                .i('Updating httpPort from ${sphiaConfig.httpPort} to $value');
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
        context,
        !coreProvider.coreRunning,
      ),
      SphiaWidget.textCard(
        sphiaConfig.mixedPort.toString(),
        S.of(context).mixedPort,
        (value) {
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

            logger.i(
                'Updating mixedPort from ${sphiaConfig.mixedPort} to $value');
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
        context,
        !coreProvider.coreRunning,
      ),
      SphiaWidget.textCard(
        sphiaConfig.listen,
        S.of(context).listen,
        (value) {
          if (value != null) {
            logger.i('Updating listen from ${sphiaConfig.listen} to $value');
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
        context,
        !coreProvider.coreRunning,
      ),
      SphiaWidget.checkboxCard(
        sphiaConfig.enableUdp,
        S.of(context).enableUdp,
        (value) {
          if (value != null) {
            logger.i(
                'Updating enableUdp from ${sphiaConfig.enableUdp} to $value');
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
        !coreProvider.coreRunning,
      ),
      const Divider(),
      SphiaWidget.checkboxCard(
        sphiaConfig.authentication,
        S.of(context).authentication,
        (value) {
          if (value != null) {
            logger.i(
                'Updating authentication from ${sphiaConfig.authentication} to $value');
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
        !coreProvider.coreRunning,
      ),
      SphiaWidget.textCard(
        sphiaConfig.user,
        S.of(context).user,
        (value) {
          if (value != null) {
            logger.i('Updating user from ${sphiaConfig.user} to $value');
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
        context,
        !coreProvider.coreRunning,
      ),
      SphiaWidget.textCard(
        sphiaConfig.password,
        S.of(context).password,
        (value) {
          if (value != null) {
            logger
                .i('Updating password from ${sphiaConfig.password} to $value');
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
        context,
        !coreProvider.coreRunning,
      ),
    ];
    final coreWidgets = [
      SphiaWidget.textCard(
        sphiaConfig.coreApiPort.toString(),
        S.of(context).coreApiPort,
        (value) {
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
            logger.i(
                'Updating coreApiPort from ${sphiaConfig.coreApiPort} to $value');
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
        context,
        !coreProvider.coreRunning,
      ),
      const Divider(),
      SphiaWidget.checkboxCard(
        sphiaConfig.enableSniffing,
        S.of(context).enableSniffing,
        (value) {
          if (value != null) {
            logger.i(
                'Updating enableSniffing from ${sphiaConfig.enableSniffing} to $value');
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
        sphiaConfig.configureDns,
        S.of(context).configureDns,
        (value) {
          if (value != null) {
            logger.i(
                'Updating configureDns from ${sphiaConfig.configureDns} to $value');
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
        sphiaConfig.remoteDns,
        S.of(context).remoteDns,
        (value) {
          if (value != null) {
            logger.i(
                'Updating remoteDns from ${sphiaConfig.remoteDns} to $value');
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
        context,
      ),
      SphiaWidget.textCard(
        sphiaConfig.directDns,
        S.of(context).directDns,
        (value) {
          if (value != null) {
            logger.i(
                'Updating directDns from ${sphiaConfig.directDns} to $value');
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
        context,
      ),
      const Divider(),
      SphiaWidget.itemsCard(
        sphiaConfig.domainStrategy,
        S.of(context).domainStrategy,
        domainStrategyList,
        (value) {
          if (value != null) {
            logger.i(
                'Updating domainStrategy from ${sphiaConfig.domainStrategy} to $value');
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
        context,
      ),
      SphiaWidget.itemsCard(
        sphiaConfig.domainMatcher,
        S.of(context).domainMatcher,
        domainMatcherList,
        (value) {
          if (value != null) {
            logger.i(
                'Updating domainMatcher from ${sphiaConfig.domainMatcher} to $value');
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
        context,
      ),
      const Divider(),
      SphiaWidget.checkboxCard(
        sphiaConfig.enableCoreLog,
        S.of(context).enableCoreLog,
        (value) {
          if (value != null) {
            logger.i(
                'Updating enableCoreLog from ${sphiaConfig.enableCoreLog} to $value');
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
        sphiaConfig.logLevel,
        S.of(context).logLevel,
        logLevelList,
        (value) {
          if (value != null) {
            logger
                .i('Updating logLevel from ${sphiaConfig.logLevel} to $value');
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
        context,
      ),
      SphiaWidget.textCard(
        sphiaConfig.maxLogCount.toString(),
        S.of(context).maxLogCount,
        (value) {
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
            logger.i(
                'Updating maxLogCount from ${sphiaConfig.maxLogCount} to $value');
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
        context,
      ),
      SphiaWidget.checkboxCard(
        sphiaConfig.saveCoreLog,
        S.of(context).saveCoreLog,
        (value) {
          if (value != null) {
            logger.i(
                'Updating saveCoreLog from ${sphiaConfig.saveCoreLog} to $value');
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
        sphiaConfig.routingProvider,
        S.of(context).routingProvider,
        routingProviderList,
        (value) {
          if (value != null) {
            logger.i(
                'Updating routingProvider from ${sphiaConfig.routingProvider} to $value');
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
        context,
      ),
      SphiaWidget.itemsCard(
        sphiaConfig.vmessProvider,
        S.of(context).vmessProvider,
        vmessProviderList,
        (value) {
          if (value != null) {
            logger.i(
                'Updating vmessProvider from ${sphiaConfig.vmessProvider} to $value');
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
        context,
      ),
      SphiaWidget.itemsCard(
        sphiaConfig.vlessProvider,
        S.of(context).vlessProvider,
        vlessProviderList,
        (value) {
          if (value != null) {
            logger.i(
                'Updating vlessProvider from ${sphiaConfig.vlessProvider} to $value');
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
        context,
      ),
      SphiaWidget.itemsCard(
        sphiaConfig.shadowsocksProvider,
        S.of(context).shadowsocksProvider,
        shadowsocksProviderList,
        (value) {
          if (value != null) {
            logger.i(
                'Updating shadowsocksProvider from ${sphiaConfig.shadowsocksProvider} to $value');
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
        context,
      ),
      SphiaWidget.itemsCard(
        sphiaConfig.trojanProvider,
        S.of(context).trojanProvider,
        trojanProviderList,
        (value) {
          if (value != null) {
            logger.i(
                'Updating trojanProvider from ${sphiaConfig.trojanProvider} to $value');
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
        context,
      ),
      SphiaWidget.itemsCard(
        sphiaConfig.hysteriaProvider,
        S.of(context).hysteriaProvider,
        ['sing-box', 'hysteria'],
        (value) {
          if (value != null) {
            logger.i(
                'Updating hysteriaProvider from ${sphiaConfig.hysteriaProvider} to $value');
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
        context,
      ),
      const Divider(),
      SphiaWidget.textCard(
        sphiaConfig.additionalSocksPort.toString(),
        S.of(context).additionalSocksPort,
        (value) {
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
            logger.i(
                'Updating additionalSocksPort from ${sphiaConfig.additionalSocksPort} to $value');
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
        context,
        !coreProvider.coreRunning,
      ),
    ];
    final tunWidgets = [
      SphiaWidget.itemsCard(
        sphiaConfig.tunProvider,
        S.of(context).tunProvider,
        tunProviderList,
        (value) {
          if (value != null) {
            logger.i(
                'Updating tunProvider from ${sphiaConfig.tunProvider} to $value');
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
        context,
      ),
      const Divider(),
      SphiaWidget.checkboxCard(
        sphiaConfig.enableIpv4,
        S.of(context).enableIpv4,
        (value) {
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
        sphiaConfig.ipv4Address,
        S.of(context).ipv4Address,
        (value) {
          if (value != null) {
            logger.i(
                'Updating ipv4Address from ${sphiaConfig.ipv4Address} to $value');
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
        context,
      ),
      SphiaWidget.checkboxCard(
        sphiaConfig.enableIpv6,
        S.of(context).enableIpv6,
        (value) {
          if (value != null) {
            logger.i(
                'Updating enableIpv6 from ${sphiaConfig.enableIpv6} to $value');
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
        sphiaConfig.ipv6Address,
        S.of(context).ipv6Address,
        (value) {
          if (value != null) {
            logger.i(
                'Updating ipv6Address from ${sphiaConfig.ipv6Address} to $value');
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
        context,
      ),
      const Divider(),
      SphiaWidget.textCard(
        sphiaConfig.mtu.toString(),
        S.of(context).mtu,
        (value) {
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
            logger.i('Updating mtu from ${sphiaConfig.mtu} to $value');
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
        context,
      ),
      SphiaWidget.checkboxCard(
        sphiaConfig.endpointIndependentNat,
        S.of(context).endpointIndependentNat,
        (value) {
          if (value != null) {
            logger.i(
                'Updating endpointIndependentNat from ${sphiaConfig.endpointIndependentNat} to $value');
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
        sphiaConfig.stack,
        S.of(context).stack,
        tunStackList,
        (value) {
          if (value != null) {
            logger.i('Updating stack from ${sphiaConfig.stack} to $value');
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
        context,
      ),
      SphiaWidget.checkboxCard(
        sphiaConfig.autoRoute,
        S.of(context).autoRoute,
        (value) {
          if (value != null) {
            logger.i(
                'Updating autoRoute from ${sphiaConfig.autoRoute} to $value');
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
        sphiaConfig.strictRoute,
        S.of(context).strictRoute,
        (value) {
          if (value != null) {
            logger.i(
                'Updating strictRoute from ${sphiaConfig.strictRoute} to $value');
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
