import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/task/subscribe.dart';
import 'package:sphia/app/task/task.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/util/system.dart';
import 'package:sphia/view/widget/widget.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({
    Key? key,
  }) : super(key: key);

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

    final sphiaWidgets = [
      WidgetBuild.buildCheckboxListTile(
        sphiaConfig.startOnBoot,
        S.of(context).startOnBoot,
        (value) {
          if (value != null) {
            logger.i(
                'Updating startOnBoot from ${sphiaConfig.startOnBoot} to $value');
            sphiaConfig.startOnBoot = value;
            sphiaConfigProvider.saveConfig();
            SystemUtil.configureStartup();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).startOnBootMsg,
              ),
            );
          }
        },
      ),
      WidgetBuild.buildCheckboxListTile(
        sphiaConfig.autoRunServer,
        S.of(context).autoRunServer,
        (value) {
          if (value != null) {
            logger.i(
                'Updating autoRunServer from ${sphiaConfig.autoRunServer} to $value');
            sphiaConfig.autoRunServer = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).autoRunServerMsg,
              ),
            );
          }
        },
      ),
      const Divider(),
      WidgetBuild.buildCheckboxListTile(
        sphiaConfig.useMaterial3,
        S.of(context).useMaterial3,
        (value) {
          if (value != null) {
            logger.i(
                'Updating useMaterial3 from ${sphiaConfig.useMaterial3} to $value');
            sphiaConfig.useMaterial3 = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).useMaterial3Msg,
              ),
            );
          }
        },
      ),
      WidgetBuild.buildItemsListTile(
        sphiaConfig.navigationStyle,
        S.of(context).navigationStyle,
        ['rail', 'drawer'],
        (value) {
          if (value != null) {
            logger.i(
                'Updating navigationStyle from ${sphiaConfig.navigationStyle} to $value');
            sphiaConfig.navigationStyle = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).navigationStyleMsg,
              ),
            );
          }
        },
        context,
      ),
      WidgetBuild.buildCheckboxListTile(
        sphiaConfig.darkMode,
        S.of(context).darkMode,
        (value) {
          if (value != null) {
            logger
                .i('Updating darkMode from ${sphiaConfig.darkMode} to $value');
            sphiaConfig.darkMode = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).darkModeMsg,
              ),
            );
          }
        },
      ),
      WidgetBuild.buildColorsListTile(
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
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).themeColorMsg,
              ),
            );
          }
        },
        context,
      ),
      WidgetBuild.buildTextListTile(
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
              _scaffoldMessengerKey.currentState?.showSnackBar(
                WidgetBuild.snackBar(
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
              _scaffoldMessengerKey.currentState?.showSnackBar(
                WidgetBuild.snackBar(
                  S.of(context).themeColorMsg,
                ),
              );
            } else {
              _scaffoldMessengerKey.currentState?.showSnackBar(
                WidgetBuild.snackBar(
                  S.of(context).themeColorWarn,
                ),
              );
            }
          }
        },
        context,
      ),
      const Divider(),
      WidgetBuild.buildCheckboxListTile(
        sphiaConfig.showAddress,
        S.of(context).showAddress,
        (value) {
          if (value != null) {
            logger.i(
                'Updating showAddress from ${sphiaConfig.showAddress} to $value');
            sphiaConfig.showAddress = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).showAddressMsg,
              ),
            );
          }
        },
      ),
      const Divider(),
      WidgetBuild.buildCheckboxListTile(
        sphiaConfig.enableStatistics,
        S.of(context).enableStatistics,
        (value) {
          if (value != null) {
            logger.i(
                'Updating enableStatistics from ${sphiaConfig.enableStatistics} to $value');
            sphiaConfig.enableStatistics = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).enableStatisticsMsg,
              ),
            );
          }
        },
      ),
      WidgetBuild.buildCheckboxListTile(
        sphiaConfig.enableSpeedChart,
        S.of(context).enableSpeedChart,
        (value) {
          if (value != null) {
            logger.i(
                'Updating enableSpeedChart from ${sphiaConfig.enableSpeedChart} to $value');
            sphiaConfig.enableSpeedChart = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).enableSpeedChartMsg,
              ),
            );
          }
        },
      ),
      const Divider(),
      WidgetBuild.buildTextListTile(
        sphiaConfig.updateSubscribeInterval.toString(),
        S.of(context).updateSubscribeInterval,
        (value) {
          if (value != null) {
            late final int? newValue;
            if ((newValue = int.tryParse(value)) == null) {
              _scaffoldMessengerKey.currentState?.showSnackBar(
                WidgetBuild.snackBar(
                  S.of(context).updateSubscribeIntervalWarn,
                ),
              );
              return;
            }
            if (newValue! < 0 && newValue != -1) {
              _scaffoldMessengerKey.currentState?.showSnackBar(
                WidgetBuild.snackBar(
                  S.of(context).updateSubscribeIntervalWarn,
                ),
              );
              return;
            }
            logger.i(
                'Updating updateSubscribeInterval from ${sphiaConfig.updateSubscribeInterval} to $value');
            sphiaConfig.updateSubscribeInterval = newValue;
            sphiaConfigProvider.saveConfig();
            if (sphiaConfig.updateSubscribeInterval != -1) {
              SphiaTask.addTask(SubscribeTask.generate());
            } else {
              SphiaTask.cancelTask(SubscribeTask.name);
            }
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).updateSubscribeIntervalMsg,
              ),
            );
          }
        },
        context,
      ),
      WidgetBuild.buildCheckboxListTile(
        sphiaConfig.updateThroughProxy,
        S.of(context).updateThroughProxy,
        (value) {
          if (value != null) {
            logger.i(
                'Updating updateThroughProxy from ${sphiaConfig.updateThroughProxy} to $value');
            sphiaConfig.updateThroughProxy = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).updateThroughProxyMsg,
              ),
            );
          }
        },
      ),
      WidgetBuild.buildItemsListTile(
        sphiaConfig.userAgent,
        S.of(context).userAgent,
        ['chrome', 'firefox', 'safari', 'edge', 'none'],
        (value) {
          if (value != null) {
            logger.i(
                'Updating userAgent from ${sphiaConfig.userAgent} to $value');
            sphiaConfig.userAgent = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).userAgentMsg,
              ),
            );
          }
        },
        context,
      ),
    ];
    final proxyWidgets = [
      WidgetBuild.buildCheckboxListTile(
        sphiaConfig.autoGetIp,
        S.of(context).autoGetIp,
        (value) {
          if (value != null) {
            logger.i(
                'Updating autoGetIp from ${sphiaConfig.autoGetIp} to $value');
            sphiaConfig.autoGetIp = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).autoGetIpMsg,
              ),
            );
          }
        },
      ),
      WidgetBuild.buildCheckboxListTile(
        sphiaConfig.autoConfigureSystemProxy,
        S.of(context).autoConfigureSystemProxy,
        (value) {
          if (value != null) {
            logger.i(
                'Updating autoConfigureSystemProxy from ${sphiaConfig.autoConfigureSystemProxy} to $value');
            sphiaConfig.autoConfigureSystemProxy = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).autoConfigureSystemProxyMsg,
              ),
            );
          }
        },
      ),
      WidgetBuild.buildCheckboxListTile(
        sphiaConfig.enableTun,
        S.of(context).enableTun,
        (value) {
          if (value != null) {
            logger.i(
                'Updating enableTun from ${sphiaConfig.enableTun} to $value');
            sphiaConfig.enableTun = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).enableTunMsg,
              ),
            );
          }
        },
      ),
      const Divider(),
      WidgetBuild.buildTextListTile(
        sphiaConfig.socksPort.toString(),
        S.of(context).socksPort,
        (value) {
          if (value != null) {
            late final int? newValue;
            if ((newValue = int.tryParse(value)) == null ||
                newValue! < 0 ||
                newValue > 65535) {
              _scaffoldMessengerKey.currentState?.showSnackBar(
                WidgetBuild.snackBar(
                  S.of(context).portInvalidMsg,
                ),
              );
              return;
            }
            logger.i(
                'Updating socksPort from ${sphiaConfig.socksPort} to $value');
            sphiaConfig.socksPort = newValue;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).socksPortMsg,
              ),
            );
          }
        },
        context,
      ),
      WidgetBuild.buildTextListTile(
        sphiaConfig.httpPort.toString(),
        S.of(context).httpPort,
        (value) {
          if (value != null) {
            late final int? newValue;
            if ((newValue = int.tryParse(value)) == null ||
                newValue! < 0 ||
                newValue > 65535) {
              _scaffoldMessengerKey.currentState?.showSnackBar(
                WidgetBuild.snackBar(
                  S.of(context).portInvalidMsg,
                ),
              );
              return;
            }
            logger
                .i('Updating httpPort from ${sphiaConfig.httpPort} to $value');
            sphiaConfig.httpPort = newValue;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).httpPortMsg,
              ),
            );
          }
        },
        context,
      ),
      WidgetBuild.buildTextListTile(
          sphiaConfig.mixedPort.toString(), S.of(context).mixedPort, (value) {
        if (value != null) {
          late final int? newValue;
          if ((newValue = int.tryParse(value)) == null ||
              newValue! < 0 ||
              newValue > 65535) {
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).portInvalidMsg,
              ),
            );
            return;
          }

          logger
              .i('Updating mixedPort from ${sphiaConfig.mixedPort} to $value');
          sphiaConfig.mixedPort = newValue;
          sphiaConfigProvider.saveConfig();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            WidgetBuild.snackBar(
              S.of(context).mixedPortMsg,
            ),
          );
        }
      }, context),
      WidgetBuild.buildTextListTile(sphiaConfig.listen, S.of(context).listen,
          (value) {
        if (value != null) {
          logger.i('Updating listen from ${sphiaConfig.listen} to $value');
          sphiaConfig.listen = value;
          sphiaConfigProvider.saveConfig();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            WidgetBuild.snackBar(
              S.of(context).listenMsg,
            ),
          );
        }
      }, context),
      WidgetBuild.buildCheckboxListTile(
        sphiaConfig.enableUdp,
        S.of(context).enableUdp,
        (value) {
          if (value != null) {
            logger.i(
                'Updating enableUdp from ${sphiaConfig.enableUdp} to $value');
            sphiaConfig.enableUdp = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).enableUdpMsg,
              ),
            );
          }
        },
      ),
      const Divider(),
      WidgetBuild.buildCheckboxListTile(
        sphiaConfig.authentication,
        S.of(context).authentication,
        (value) {
          if (value != null) {
            logger.i(
                'Updating authentication from ${sphiaConfig.authentication} to $value');
            sphiaConfig.authentication = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).authenticationMsg,
              ),
            );
          }
        },
      ),
      WidgetBuild.buildTextListTile(
        sphiaConfig.user,
        S.of(context).user,
        (value) {
          if (value != null) {
            logger.i('Updating user from ${sphiaConfig.user} to $value');
            sphiaConfig.user = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).userMsg,
              ),
            );
          }
        },
        context,
      ),
      WidgetBuild.buildTextListTile(
        sphiaConfig.password,
        S.of(context).password,
        (value) {
          if (value != null) {
            logger
                .i('Updating password from ${sphiaConfig.password} to $value');
            sphiaConfig.password = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).passwordMsg,
              ),
            );
          }
        },
        context,
      ),
    ];
    final coreWidgets = [
      WidgetBuild.buildTextListTile(
        sphiaConfig.coreApiPort.toString(),
        S.of(context).coreApiPort,
        (value) {
          if (value != null) {
            late final int? newValue;
            if ((newValue = int.tryParse(value)) == null ||
                newValue! < 0 ||
                newValue > 65535) {
              _scaffoldMessengerKey.currentState?.showSnackBar(
                WidgetBuild.snackBar(
                  S.of(context).portInvalidMsg,
                ),
              );
              return;
            }
            logger.i(
                'Updating coreApiPort from ${sphiaConfig.coreApiPort} to $value');
            sphiaConfig.coreApiPort = newValue;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).coreApiPortMsg,
              ),
            );
          }
        },
        context,
      ),
      const Divider(),
      WidgetBuild.buildCheckboxListTile(
        sphiaConfig.enableSniffing,
        S.of(context).enableSniffing,
        (value) {
          if (value != null) {
            logger.i(
                'Updating enableSniffing from ${sphiaConfig.enableSniffing} to $value');
            sphiaConfig.enableSniffing = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).enableSniffingMsg,
              ),
            );
          }
        },
      ),
      WidgetBuild.buildCheckboxListTile(
        sphiaConfig.configureDns,
        S.of(context).configureDns,
        (value) {
          if (value != null) {
            logger.i(
                'Updating configureDns from ${sphiaConfig.configureDns} to $value');
            sphiaConfig.configureDns = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).configureDnsMsg,
              ),
            );
          }
        },
      ),
      WidgetBuild.buildTextListTile(
        sphiaConfig.remoteDns,
        S.of(context).remoteDns,
        (value) {
          if (value != null) {
            logger.i(
                'Updating remoteDns from ${sphiaConfig.remoteDns} to $value');
            sphiaConfig.remoteDns = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).remoteDnsMsg,
              ),
            );
          }
        },
        context,
      ),
      WidgetBuild.buildTextListTile(
        sphiaConfig.directDns,
        S.of(context).directDns,
        (value) {
          if (value != null) {
            logger.i(
                'Updating directDns from ${sphiaConfig.directDns} to $value');
            sphiaConfig.directDns = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).directDnsMsg,
              ),
            );
          }
        },
        context,
      ),
      const Divider(),
      WidgetBuild.buildItemsListTile(
        sphiaConfig.domainStrategy,
        S.of(context).domainStrategy,
        ['AsIs', 'IPIfNonMatch', 'IPOnDemand'],
        (value) {
          if (value != null) {
            logger.i(
                'Updating domainStrategy from ${sphiaConfig.domainStrategy} to $value');
            sphiaConfig.domainStrategy = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).domainStrategyMsg,
              ),
            );
          }
        },
        context,
      ),
      WidgetBuild.buildItemsListTile(
        sphiaConfig.domainMatcher,
        S.of(context).domainMatcher,
        ['hybrid', 'linear'],
        (value) {
          if (value != null) {
            logger.i(
                'Updating domainMatcher from ${sphiaConfig.domainMatcher} to $value');
            sphiaConfig.domainMatcher = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).domainMatcherMsg,
              ),
            );
          }
        },
        context,
      ),
      const Divider(),
      WidgetBuild.buildCheckboxListTile(
        sphiaConfig.enableCoreLog,
        S.of(context).enableCoreLog,
        (value) {
          if (value != null) {
            logger.i(
                'Updating enableCoreLog from ${sphiaConfig.enableCoreLog} to $value');
            sphiaConfig.enableCoreLog = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).enableCoreLogMsg,
              ),
            );
          }
        },
      ),
      WidgetBuild.buildItemsListTile(
        sphiaConfig.logLevel,
        S.of(context).logLevel,
        ['none', 'warning', 'debug', 'error', 'info'],
        (value) {
          if (value != null) {
            logger
                .i('Updating logLevel from ${sphiaConfig.logLevel} to $value');
            sphiaConfig.logLevel = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).logLevelMsg,
              ),
            );
          }
        },
        context,
      ),
      WidgetBuild.buildTextListTile(
        sphiaConfig.maxLogCount.toString(),
        S.of(context).maxLogCount,
        (value) {
          if (value != null) {
            late final int? newValue;
            if ((newValue = int.tryParse(value)) == null || newValue! < 0) {
              _scaffoldMessengerKey.currentState?.showSnackBar(
                WidgetBuild.snackBar(
                  S.of(context).enterValidNumberMsg,
                ),
              );
              return;
            }
            logger.i(
                'Updating maxLogCount from ${sphiaConfig.maxLogCount} to $value');
            sphiaConfig.maxLogCount = newValue;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).maxLogCountMsg,
              ),
            );
          }
        },
        context,
      ),
      WidgetBuild.buildCheckboxListTile(
        sphiaConfig.saveCoreLog,
        S.of(context).saveCoreLog,
        (value) {
          if (value != null) {
            logger.i(
                'Updating saveCoreLog from ${sphiaConfig.saveCoreLog} to $value');
            sphiaConfig.saveCoreLog = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).saveCoreLogMsg,
              ),
            );
          }
        },
      ),
    ];

    final providerWidgets = [
      WidgetBuild.buildItemsListTile(
        sphiaConfig.routingProvider,
        S.of(context).routingProvider,
        ['sing-box', 'xray-core'],
        (value) {
          if (value != null) {
            logger.i(
                'Updating routingProvider from ${sphiaConfig.routingProvider} to $value');
            sphiaConfig.routingProvider = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).routingProviderMsg,
              ),
            );
          }
        },
        context,
      ),
      WidgetBuild.buildItemsListTile(
        sphiaConfig.vmessProvider,
        S.of(context).vmessProvider,
        ['sing-box', 'xray-core'],
        (value) {
          if (value != null) {
            logger.i(
                'Updating vmessProvider from ${sphiaConfig.vmessProvider} to $value');
            sphiaConfig.vmessProvider = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).vmessProviderMsg,
              ),
            );
          }
        },
        context,
      ),
      WidgetBuild.buildItemsListTile(
        sphiaConfig.vlessProvider,
        S.of(context).vlessProvider,
        ['sing-box', 'xray-core'],
        (value) {
          if (value != null) {
            logger.i(
                'Updating vlessProvider from ${sphiaConfig.vlessProvider} to $value');
            sphiaConfig.vlessProvider = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).vlessProviderMsg,
              ),
            );
          }
        },
        context,
      ),
      WidgetBuild.buildItemsListTile(
        sphiaConfig.shadowsocksProvider,
        S.of(context).shadowsocksProvider,
        ['sing-box', 'xray-core', 'shadowsocks-rust'],
        (value) {
          if (value != null) {
            logger.i(
                'Updating shadowsocksProvider from ${sphiaConfig.shadowsocksProvider} to $value');
            sphiaConfig.shadowsocksProvider = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).shadowsocksProviderMsg,
              ),
            );
          }
        },
        context,
      ),
      WidgetBuild.buildItemsListTile(
        sphiaConfig.trojanProvider,
        S.of(context).trojanProvider,
        ['sing-box', 'xray-core'],
        (value) {
          if (value != null) {
            logger.i(
                'Updating trojanProvider from ${sphiaConfig.trojanProvider} to $value');
            sphiaConfig.trojanProvider = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).trojanProviderMsg,
              ),
            );
          }
        },
        context,
      ),
      WidgetBuild.buildItemsListTile(
        sphiaConfig.hysteriaProvider,
        S.of(context).hysteriaProvider,
        ['sing-box', 'hysteria'],
        (value) {
          if (value != null) {
            logger.i(
                'Updating hysteriaProvider from ${sphiaConfig.hysteriaProvider} to $value');
            sphiaConfig.hysteriaProvider = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).hysteriaProviderMsg,
              ),
            );
          }
        },
        context,
      ),
      const Divider(),
      WidgetBuild.buildTextListTile(
        sphiaConfig.additionalSocksPort.toString(),
        S.of(context).additionalSocksPort,
        (value) {
          if (value != null) {
            late final int? newValue;
            if ((newValue = int.tryParse(value)) == null ||
                newValue! < 0 ||
                newValue > 65535) {
              _scaffoldMessengerKey.currentState?.showSnackBar(
                WidgetBuild.snackBar(
                  S.of(context).portInvalidMsg,
                ),
              );
              return;
            }
            logger.i(
                'Updating additionalSocksPort from ${sphiaConfig.additionalSocksPort} to $value');
            sphiaConfig.additionalSocksPort = newValue;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).additionalSocksPortMsg,
              ),
            );
          }
        },
        context,
      ),
    ];
    final tunWidgets = [
      WidgetBuild.buildItemsListTile(
        sphiaConfig.tunProvider,
        S.of(context).tunProvider,
        ['sing-box'],
        (value) {
          if (value != null) {
            logger.i(
                'Updating tunProvider from ${sphiaConfig.tunProvider} to $value');
            sphiaConfig.tunProvider = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).tunProviderMsg,
              ),
            );
          }
        },
        context,
      ),
      const Divider(),
      WidgetBuild.buildCheckboxListTile(
        sphiaConfig.enableIpv4,
        S.of(context).enableIpv4,
        (value) {
          if (value != null) {
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).enableIpv4Msg,
              ),
            );
          }
        },
      ),
      WidgetBuild.buildTextListTile(
        sphiaConfig.ipv4Address,
        S.of(context).ipv4Address,
        (value) {
          if (value != null) {
            logger.i(
                'Updating ipv4Address from ${sphiaConfig.ipv4Address} to $value');
            sphiaConfig.ipv4Address = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).ipv4AddressMsg,
              ),
            );
          }
        },
        context,
      ),
      WidgetBuild.buildCheckboxListTile(
        sphiaConfig.enableIpv6,
        S.of(context).enableIpv6,
        (value) {
          if (value != null) {
            logger.i(
                'Updating enableIpv6 from ${sphiaConfig.enableIpv6} to $value');
            sphiaConfig.enableIpv6 = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).enableIpv6Msg,
              ),
            );
          }
        },
      ),
      WidgetBuild.buildTextListTile(
        sphiaConfig.ipv6Address,
        S.of(context).ipv6Address,
        (value) {
          if (value != null) {
            logger.i(
                'Updating ipv6Address from ${sphiaConfig.ipv6Address} to $value');
            sphiaConfig.ipv4Address = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).ipv6AddressMsg,
              ),
            );
          }
        },
        context,
      ),
      const Divider(),
      WidgetBuild.buildTextListTile(
        sphiaConfig.mtu.toString(),
        S.of(context).mtu,
        (value) {
          if (value != null) {
            late final int? newValue;
            if ((newValue = int.tryParse(value)) == null) {
              _scaffoldMessengerKey.currentState?.showSnackBar(
                WidgetBuild.snackBar(
                  S.of(context).enterValidNumberMsg,
                ),
              );
              return;
            }
            logger.i('Updating mtu from ${sphiaConfig.mtu} to $value');
            sphiaConfig.mtu = newValue!;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).mtuMsg,
              ),
            );
          }
        },
        context,
      ),
      WidgetBuild.buildItemsListTile(
        sphiaConfig.stack,
        S.of(context).stack,
        ['system', 'gvisor'],
        (value) {
          if (value != null) {
            logger.i('Updating stack from ${sphiaConfig.stack} to $value');
            sphiaConfig.stack = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).stackMsg,
              ),
            );
          }
        },
        context,
      ),
      WidgetBuild.buildCheckboxListTile(
        sphiaConfig.autoRoute,
        S.of(context).autoRoute,
        (value) {
          if (value != null) {
            logger.i(
                'Updating autoRoute from ${sphiaConfig.autoRoute} to $value');
            sphiaConfig.autoRoute = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
                S.of(context).autoRouteMsg,
              ),
            );
          }
        },
      ),
      WidgetBuild.buildCheckboxListTile(
        sphiaConfig.strictRoute,
        S.of(context).strictRoute,
        (value) {
          if (value != null) {
            logger.i(
                'Updating strictRoute from ${sphiaConfig.strictRoute} to $value');
            sphiaConfig.strictRoute = value;
            sphiaConfigProvider.saveConfig();
            _scaffoldMessengerKey.currentState?.showSnackBar(
              WidgetBuild.snackBar(
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
          body: TabBarView(
            children: [
              // use builder
              ListView.builder(
                itemCount: sphiaWidgets.length,
                itemBuilder: (context, index) {
                  final widget = sphiaWidgets[index];
                  return widget;
                },
              ),
              ListView.builder(
                itemCount: proxyWidgets.length,
                itemBuilder: (context, index) {
                  final widget = proxyWidgets[index];
                  return widget;
                },
              ),
              ListView.builder(
                itemCount: coreWidgets.length,
                itemBuilder: (context, index) {
                  final widget = coreWidgets[index];
                  return widget;
                },
              ),
              ListView.builder(
                itemCount: providerWidgets.length,
                itemBuilder: (context, index) {
                  final widget = providerWidgets[index];
                  return widget;
                },
              ),
              ListView.builder(
                itemCount: tunWidgets.length,
                itemBuilder: (context, index) {
                  final widget = tunWidgets[index];
                  return widget;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
