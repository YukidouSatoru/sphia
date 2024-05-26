import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/notifier/config/sphia_config.dart';
import 'package:sphia/app/notifier/proxy.dart';
import 'package:sphia/l10n/generated/l10n.dart';
import 'package:sphia/util/system.dart';
import 'package:sphia/view/widget/setting_widget/checkbox_card.dart';
import 'package:sphia/view/widget/setting_widget/colors_card.dart';
import 'package:sphia/view/widget/setting_widget/items_card.dart';
import 'package:sphia/view/widget/setting_widget/text_card.dart';
import 'package:sphia/view/widget/widget.dart';
import 'package:sphia/view/wrapper/page.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({
    super.key,
  });

  @override
  ConsumerState<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(sphiaConfigNotifierProvider.notifier);
    final coreRunning =
        ref.watch(proxyNotifierProvider.select((value) => value.coreRunning));
    final sphiaWidgets = [
      CheckboxCard(
        title: S.of(context).startOnBoot,
        selector: (value) => value.startOnBoot,
        updater: (value) {
          notifier.updateValue('startOnBoot', value);
          SystemUtil.configureStartup(value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).startOnBootMsg,
            ),
          );
        },
      ),
      CheckboxCard(
        title: S.of(context).autoRunServer,
        selector: (value) => value.autoRunServer,
        updater: (value) {
          notifier.updateValue('autoRunServer', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).autoRunServerMsg,
            ),
          );
        },
      ),
      const Divider(),
      CheckboxCard(
        title: S.of(context).useMaterial3,
        selector: (value) => value.useMaterial3,
        updater: (value) {
          notifier.updateValue('useMaterial3', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).useMaterial3Msg,
            ),
          );
        },
      ),
      ItemsCard(
        title: S.of(context).navigationStyle,
        items: navigationStyleList,
        selector: (value) => value.navigationStyle.index,
        updater: (value) {
          notifier.updateValue(
              'navigationStyle', NavigationStyle.values[value].name);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).navigationStyleMsg,
            ),
          );
        },
      ),
      CheckboxCard(
        title: S.of(context).darkMode,
        selector: (value) => value.darkMode,
        updater: (value) {
          notifier.updateValue('darkMode', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).darkModeMsg,
            ),
          );
        },
      ),
      ColorsCard(
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
        updater: (value) {
          notifier.updateValue('themeColor', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).themeColorMsg,
            ),
          );
        },
      ),
      TextCard(
        title: S.of(context).themeColorArgb,
        selector: (value) {
          return "${value.themeColor >> 24},${(value.themeColor >> 16) & 0xFF},${(value.themeColor >> 8) & 0xFF},${value.themeColor & 0xFF}";
        },
        updater: (value) {
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
            notifier.updateValue('themeColor', argbValue);
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
        },
      ),
      const Divider(),
      CheckboxCard(
        title: S.of(context).showTransport,
        selector: (value) => value.showTransport,
        updater: (value) {
          notifier.updateValue('showTransport', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).showTransportMsg,
            ),
          );
        },
      ),
      CheckboxCard(
        title: S.of(context).showAddress,
        selector: (value) => value.showAddress,
        updater: (value) {
          notifier.updateValue('showAddress', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).showAddressMsg,
            ),
          );
        },
      ),
      const Divider(),
      CheckboxCard(
        title: S.of(context).enableStatistics,
        selector: (value) => value.enableStatistics,
        updater: (value) {
          notifier.updateValue('enableStatistics', value);
          if (!value) {
            notifier.updateValue('enableSpeedChart', false);
          }
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).enableStatisticsMsg,
            ),
          );
        },
        enabled: !coreRunning,
      ),
      CheckboxCard(
        title: S.of(context).enableSpeedChart,
        selector: (value) => value.enableSpeedChart,
        updater: (value) {
          notifier.updateValue('enableSpeedChart', value);
          if (value) {
            notifier.updateValue('enableStatistics', true);
          }
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).enableSpeedChartMsg,
            ),
          );
        },
        enabled: !coreRunning ||
            (coreRunning &&
                ref.read(sphiaConfigNotifierProvider).enableStatistics),
      ),
      const Divider(),
      TextCard(
        title: S.of(context).latencyTestUrl,
        selector: (value) => value.latencyTestUrl,
        updater: (value) {
          notifier.updateValue('latencyTestUrl', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).latencyTestUrlMsg,
            ),
          );
        },
      ),
      const Divider(),
      CheckboxCard(
        title: S.of(context).updateThroughProxy,
        selector: (value) => value.updateThroughProxy,
        updater: (value) {
          notifier.updateValue('updateThroughProxy', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).updateThroughProxyMsg,
            ),
          );
        },
      ),
      ItemsCard(
        title: S.of(context).userAgent,
        items: userAgentList,
        selector: (value) => value.userAgent.index,
        updater: (value) {
          notifier.updateValue('userAgent', UserAgent.values[value].name);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).userAgentMsg,
            ),
          );
        },
      ),
    ];
    final proxyWidgets = [
      CheckboxCard(
        title: S.of(context).autoGetIp,
        selector: (value) => value.autoGetIp,
        updater: (value) {
          notifier.updateValue('autoGetIp', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).autoGetIpMsg,
            ),
          );
        },
      ),
      CheckboxCard(
        title: S.of(context).multiOutboundSupport,
        selector: (value) => value.multiOutboundSupport,
        updater: (value) {
          notifier.updateValue('multiOutboundSupport', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).multiOutboundSupportMsg,
            ),
          );
        },
        enabled: !coreRunning,
      ),
      CheckboxCard(
        title: S.of(context).autoConfigureSystemProxy,
        selector: (value) => value.autoConfigureSystemProxy,
        updater: (value) {
          notifier.updateValue('autoConfigureSystemProxy', value);
          if (value) {
            notifier.updateValue('enableTun', false);
          }
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).autoConfigureSystemProxyMsg,
            ),
          );
        },
        enabled: !coreRunning,
      ),
      CheckboxCard(
        title: S.of(context).enableTun,
        selector: (value) => value.enableTun,
        updater: (value) {
          notifier.updateValue('enableTun', value);
          if (value) {
            notifier.updateValue('autoConfigureSystemProxy', false);
          }

          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).enableTunMsg,
            ),
          );
        },
        enabled: !coreRunning,
      ),
      const Divider(),
      TextCard(
        title: S.of(context).socksPort,
        selector: (value) => value.socksPort.toString(),
        updater: (value) {
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
          notifier.updateValue('socksPort', newValue);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).socksPortMsg,
            ),
          );
        },
        enabled: !coreRunning,
      ),
      TextCard(
        title: S.of(context).httpPort,
        selector: (value) => value.httpPort.toString(),
        updater: (value) {
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
          notifier.updateValue('httpPort', newValue);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).httpPortMsg,
            ),
          );
        },
        enabled: !coreRunning,
      ),
      TextCard(
        title: S.of(context).mixedPort,
        selector: (value) => value.mixedPort.toString(),
        updater: (value) {
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
          notifier.updateValue('mixedPort', newValue);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).mixedPortMsg,
            ),
          );
        },
        enabled: !coreRunning,
      ),
      TextCard(
        title: S.of(context).listen,
        selector: (value) => value.listen,
        updater: (value) {
          notifier.updateValue('listen', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).listenMsg,
            ),
          );
        },
        enabled: !coreRunning,
      ),
      CheckboxCard(
        title: S.of(context).enableUdp,
        selector: (value) => value.enableUdp,
        updater: (value) {
          notifier.updateValue('enableUdp', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).enableUdpMsg,
            ),
          );
        },
        enabled: !coreRunning,
      ),
      const Divider(),
      CheckboxCard(
        title: S.of(context).authentication,
        selector: (value) => value.authentication,
        updater: (value) {
          notifier.updateValue('authentication', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).authenticationMsg,
            ),
          );
        },
        enabled: !coreRunning,
      ),
      TextCard(
        title: S.of(context).user,
        selector: (value) => value.user,
        updater: (value) {
          notifier.updateValue('user', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).userMsg,
            ),
          );
        },
        enabled: !coreRunning,
      ),
      TextCard(
        title: S.of(context).password,
        selector: (value) => value.password,
        updater: (value) {
          notifier.updateValue('password', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).passwordMsg,
            ),
          );
        },
        enabled: !coreRunning,
      ),
    ];
    final coreWidgets = [
      TextCard(
        title: S.of(context).coreApiPort,
        selector: (value) => value.coreApiPort.toString(),
        updater: (value) {
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
          notifier.updateValue('coreApiPort', newValue);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).coreApiPortMsg,
            ),
          );
        },
        enabled: !coreRunning,
      ),
      const Divider(),
      CheckboxCard(
        title: S.of(context).enableSniffing,
        selector: (value) => value.enableSniffing,
        updater: (value) {
          notifier.updateValue('enableSniffing', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).enableSniffingMsg,
            ),
          );
        },
      ),
      CheckboxCard(
        title: S.of(context).configureDns,
        selector: (value) => value.configureDns,
        updater: (value) {
          notifier.updateValue('configureDns', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).configureDnsMsg,
            ),
          );
        },
      ),
      TextCard(
        title: S.of(context).remoteDns,
        selector: (value) => value.remoteDns,
        updater: (value) {
          notifier.updateValue('remoteDns', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).remoteDnsMsg,
            ),
          );
        },
      ),
      TextCard(
        title: S.of(context).directDns,
        selector: (value) => value.directDns,
        updater: (value) {
          notifier.updateValue('directDns', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).directDnsMsg,
            ),
          );
        },
      ),
      TextCard(
        title: S.of(context).dnsResolver,
        selector: (value) => value.dnsResolver,
        updater: (value) {
          notifier.updateValue('dnsResolver', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).dnsResolverMsg,
            ),
          );
        },
      ),
      const Divider(),
      ItemsCard(
        title: S.of(context).domainStrategy,
        items: domainStrategyList,
        selector: (value) => value.domainStrategy.index,
        updater: (value) {
          notifier.updateValue(
              'domainStrategy', DomainStrategy.values[value].name);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).domainStrategyMsg,
            ),
          );
        },
      ),
      ItemsCard(
        title: S.of(context).domainMatcher,
        items: domainMatcherList,
        selector: (value) => value.domainMatcher.index,
        updater: (value) {
          notifier.updateValue(
              'domainMatcher', DomainMatcher.values[value].name);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).domainMatcherMsg,
            ),
          );
        },
      ),
      const Divider(),
      CheckboxCard(
        title: S.of(context).enableCoreLog,
        selector: (value) => value.enableCoreLog,
        updater: (value) {
          notifier.updateValue('enableCoreLog', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).enableCoreLogMsg,
            ),
          );
        },
      ),
      ItemsCard(
        title: S.of(context).logLevel,
        items: logLevelList,
        selector: (value) => value.logLevel.index,
        updater: (value) {
          notifier.updateValue('logLevel', LogLevel.values[value].name);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).logLevelMsg,
            ),
          );
        },
      ),
      TextCard(
        title: S.of(context).maxLogCount,
        selector: (value) => value.maxLogCount.toString(),
        updater: (value) {
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
          notifier.updateValue('maxLogCount', newValue);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).maxLogCountMsg,
            ),
          );
        },
      ),
      CheckboxCard(
        title: S.of(context).saveCoreLog,
        selector: (value) => value.saveCoreLog,
        updater: (value) {
          notifier.updateValue('saveCoreLog', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).saveCoreLogMsg,
            ),
          );
        },
      ),
    ];

    final providerWidgets = [
      ItemsCard(
        title: S.of(context).routingProvider,
        items: routingProviderList,
        selector: (value) => value.routingProvider.index,
        updater: (value) {
          notifier.updateValue(
              'routingProvider', RoutingProvider.values[value].name);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).routingProviderMsg,
            ),
          );
        },
      ),
      ItemsCard(
        title: S.of(context).vmessProvider,
        items: vmessProviderList,
        selector: (value) => value.vmessProvider.index,
        updater: (value) {
          notifier.updateValue(
              'vmessProvider', VmessProvider.values[value].name);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).vmessProviderMsg,
            ),
          );
        },
      ),
      ItemsCard(
        title: S.of(context).vlessProvider,
        items: vlessProviderList,
        selector: (value) => value.vlessProvider.index,
        updater: (value) {
          notifier.updateValue(
              'vlessProvider', VlessProvider.values[value].name);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).vlessProviderMsg,
            ),
          );
        },
      ),
      ItemsCard(
        title: S.of(context).shadowsocksProvider,
        items: shadowsocksProviderList,
        selector: (value) => value.shadowsocksProvider.index,
        updater: (value) {
          notifier.updateValue(
              'shadowsocksProvider', ShadowsocksProvider.values[value].name);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).shadowsocksProviderMsg,
            ),
          );
        },
      ),
      ItemsCard(
        title: S.of(context).trojanProvider,
        items: trojanProviderList,
        selector: (value) => value.trojanProvider.index,
        updater: (value) {
          notifier.updateValue(
              'trojanProvider', TrojanProvider.values[value].name);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).trojanProviderMsg,
            ),
          );
        },
      ),
      ItemsCard(
        title: S.of(context).hysteriaProvider,
        items: hysteriaProviderList,
        selector: (value) => value.hysteriaProvider.index,
        updater: (value) {
          notifier.updateValue(
              'hysteriaProvider', HysteriaProvider.values[value].name);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).hysteriaProviderMsg,
            ),
          );
        },
      ),
      const Divider(),
      TextCard(
        title: S.of(context).editorPath,
        selector: (value) => value.editorPath,
        updater: (value) {
          notifier.updateValue('editorPath', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).editorPathMsg,
            ),
          );
        },
      ),
      const Divider(),
      TextCard(
        title: S.of(context).additionalSocksPort,
        selector: (value) => value.additionalSocksPort.toString(),
        updater: (value) {
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
          notifier.updateValue('additionalSocksPort', newValue);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).additionalSocksPortMsg,
            ),
          );
        },
        enabled: !coreRunning,
      ),
    ];
    final tunWidgets = [
      ItemsCard(
        title: S.of(context).tunProvider,
        items: tunProviderList,
        selector: (value) => value.tunProvider.index,
        updater: (value) {
          notifier.updateValue('tunProvider', TunProvider.values[value].name);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).tunProviderMsg,
            ),
          );
        },
      ),
      const Divider(),
      CheckboxCard(
        title: S.of(context).enableIpv4,
        selector: (value) => value.enableIpv4,
        updater: (value) {
          notifier.updateValue('enableIpv4', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).enableIpv4Msg,
            ),
          );
        },
      ),
      TextCard(
        title: S.of(context).ipv4Address,
        selector: (value) => value.ipv4Address,
        updater: (value) {
          notifier.updateValue('ipv4Address', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).ipv4AddressMsg,
            ),
          );
        },
      ),
      CheckboxCard(
        title: S.of(context).enableIpv6,
        selector: (value) => value.enableIpv6,
        updater: (value) {
          notifier.updateValue('enableIpv6', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).enableIpv6Msg,
            ),
          );
        },
      ),
      TextCard(
        title: S.of(context).ipv6Address,
        selector: (value) => value.ipv6Address,
        updater: (value) {
          notifier.updateValue('ipv6Address', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).ipv6AddressMsg,
            ),
          );
        },
      ),
      const Divider(),
      TextCard(
        title: S.of(context).mtu,
        selector: (value) => value.mtu.toString(),
        updater: (value) {
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
          notifier.updateValue('mtu', newValue);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).mtuMsg,
            ),
          );
        },
      ),
      CheckboxCard(
        title: S.of(context).endpointIndependentNat,
        selector: (value) => value.endpointIndependentNat,
        updater: (value) {
          notifier.updateValue('endpointIndependentNat', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).endpointIndependentNatMsg,
            ),
          );
        },
      ),
      ItemsCard(
        title: S.of(context).stack,
        items: tunStackList,
        selector: (value) => value.stack.index,
        updater: (value) {
          notifier.updateValue('stack', TunStack.values[value].name);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).stackMsg,
            ),
          );
        },
      ),
      CheckboxCard(
        title: S.of(context).autoRoute,
        selector: (value) => value.autoRoute,
        updater: (value) {
          notifier.updateValue('autoRoute', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).autoRouteMsg,
            ),
          );
        },
      ),
      CheckboxCard(
        title: S.of(context).strictRoute,
        selector: (value) => value.strictRoute,
        updater: (value) {
          notifier.updateValue('strictRoute', value);
          _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SphiaWidget.snackBar(
              S.of(context).strictRouteMsg,
            ),
          );
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
