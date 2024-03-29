import 'dart:convert';
import 'dart:core';

import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/database/dao/rule.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/rule_config.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/app/provider/version_config.dart';
import 'package:sphia/core/core.dart';
import 'package:sphia/core/helper.dart';
import 'package:sphia/core/sing/config.dart';
import 'package:sphia/core/sing/generate.dart';
import 'package:sphia/util/system.dart';

class SingBoxCore extends Core {
  SingBoxCore()
      : super(
          'sing-box',
          ['run', '-c', p.join(tempPath, 'sing-box.json'), '--disable-color'],
          'sing-box.json',
        );

  @override
  Future<void> configure() async {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
    final ruleConfig = GetIt.I.get<RuleConfigProvider>().config;
    final outbounds = [
      SingBoxGenerate.generateOutbound(servers.first)..tag = 'proxy',
    ];
    final rules =
        await ruleDao.getOrderedRulesByGroupId(ruleConfig.selectedRuleGroupId);
    late final SingConfigParameters parameters;

    // remove disabled rules
    rules.removeWhere((rule) => !rule.enabled);

    if (sphiaConfig.multiOutboundSupport) {
      final serversOnRoutingId = await CoreHelper.getRuleOutboundTagList(rules);
      final serversOnRouting =
          await serverDao.getServerModelsByIdList(serversOnRoutingId);
      // add servers on routing to outbounds, outbound.tag is proxy-serverId
      for (final server in serversOnRouting) {
        outbounds.add(
          SingBoxGenerate.generateOutbound(server)..tag = 'proxy-${server.id}',
        );
      }
      servers.addAll(serversOnRouting);
    } else {
      rules.removeWhere((rule) =>
          rule.outboundTag != outboundProxyId &&
          rule.outboundTag != outboundDirectId &&
          rule.outboundTag != outboundBlockId);
    }

    final configureDns =
        sphiaConfig.enableTun || (sphiaConfig.configureDns && isRouting);

    parameters = SingConfigParameters(
      outbounds: outbounds,
      rules: rules,
      configureDns: configureDns,
      enableApi: sphiaConfig.enableStatistics && isRouting,
      coreApiPort: sphiaConfig.coreApiPort,
      enableTun: sphiaConfig.enableTun,
      addMixedInbound: !sphiaConfig.enableTun,
      sphiaConfig: sphiaConfig,
    );

    final jsonString = await generateConfig(parameters);
    await writeConfig(jsonString);
  }

  @override
  Future<String> generateConfig(ConfigParameters parameters) async {
    final paras = parameters as SingConfigParameters;
    final sphiaConfig = paras.sphiaConfig;

    String level = LogLevel.values[sphiaConfig.logLevel].name;
    if (level == 'warning') {
      level = 'warn';
    }
    final log = Log(
      disabled: level == 'none',
      level: level == 'none' ? null : level,
      output: sphiaConfig.saveCoreLog ? SphiaLog.getLogPath(name) : null,
      timestamp: true,
    );

    Dns? dns;
    if (paras.configureDns) {
      dns = await SingBoxGenerate.dns(
        remoteDns: sphiaConfig.remoteDns,
        directDns: sphiaConfig.directDns,
        serverAddress: servers.first.address,
        ipv4Only: !sphiaConfig.enableIpv6,
      );
    }

    List<Inbound> inbounds = [];
    if (paras.addMixedInbound) {
      inbounds.add(SingBoxGenerate.mixedInbound(
        sphiaConfig.listen,
        sphiaConfig.mixedPort,
        sphiaConfig.authentication
            ? [
                User(
                  username: sphiaConfig.user,
                  password: sphiaConfig.password,
                )
              ]
            : null,
      ));
      usedPorts.add(sphiaConfig.mixedPort);
    }

    if (paras.enableTun) {
      inbounds.add(
        SingBoxGenerate.tunInbound(
          inet4Address: sphiaConfig.enableIpv4 ? sphiaConfig.ipv4Address : null,
          inet6Address: sphiaConfig.enableIpv6 ? sphiaConfig.ipv6Address : null,
          mtu: sphiaConfig.mtu,
          stack: TunStack.values[sphiaConfig.stack].name,
          autoRoute: sphiaConfig.autoRoute,
          strictRoute: sphiaConfig.strictRoute,
          sniff: sphiaConfig.enableSniffing,
          endpointIndependentNat: sphiaConfig.endpointIndependentNat,
        ),
      );
    }

    Route? route;
    if (paras.configureDns) {
      route = SingBoxGenerate.route(
        paras.rules,
        paras.configureDns,
      );
    }

    final outbounds = paras.outbounds;

    if (paras.configureDns) {
      outbounds.add(
        Outbound(type: 'dns', tag: 'dns-out'),
      );
    }
    outbounds.addAll([
      Outbound(type: 'direct', tag: 'direct'),
      Outbound(type: 'block', tag: 'block'),
    ]);

    Experimental? experimental;
    if (paras.enableApi) {
      final versionConfigProvider = GetIt.I.get<VersionConfigProvider>();
      final singBoxVersion =
          versionConfigProvider.config.singBoxVersion?.replaceAll('v', '');
      if (singBoxVersion == null) {
        logger.e('SingBox version is null');
        throw Exception('SingBox version is null');
      }
      if (Version.parse(singBoxVersion) >= Version.parse('1.8.0')) {
        experimental = Experimental(
          clashApi: ClashApi(
            externalController: '127.0.0.1:${paras.coreApiPort}',
          ),
          cacheFile: CacheFile(
            enabled: true,
            path: p.join(tempPath, paras.cacheDbFileName),
          ),
        );
      } else {
        experimental = Experimental(
          clashApi: ClashApi(
            externalController: '127.0.0.1:${paras.coreApiPort}',
            storeSelected: true,
            cacheFile: p.join(tempPath, paras.cacheDbFileName),
          ),
        );
      }
      usedPorts.add(paras.coreApiPort);
    }

    final singBoxConfig = SingBoxConfig(
      log: log,
      dns: dns,
      route: route,
      inbounds: inbounds,
      outbounds: outbounds,
      experimental: experimental,
    );

    return jsonEncode(singBoxConfig.toJson());
  }
}

class SingConfigParameters extends ConfigParameters {
  final List<Outbound> outbounds;
  final List<Rule> rules;
  final bool configureDns;
  final bool enableApi;
  final int coreApiPort;
  final bool enableTun;
  final bool addMixedInbound;
  final SphiaConfig sphiaConfig;
  final String cacheDbFileName;

  SingConfigParameters({
    required this.outbounds,
    required this.rules,
    required this.configureDns,
    required this.enableApi,
    required this.coreApiPort,
    required this.enableTun,
    required this.addMixedInbound,
    required this.sphiaConfig,
    this.cacheDbFileName = 'cache.db',
  });
}
