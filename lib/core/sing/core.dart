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
  Future<void> configure(Server selectedServer) async {
    serverId = [selectedServer.id];
    final jsonString = await generateConfig(selectedServer);
    await writeConfig(jsonString);
  }

  @override
  Future<String> generateConfig(Server mainServer) async {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;

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
    if (sphiaConfig.enableTun || (sphiaConfig.configureDns && isRouting)) {
      dns = await SingBoxGenerate.dns(
        remoteDns: sphiaConfig.remoteDns,
        directDns: sphiaConfig.directDns,
        serverAddress: mainServer.address,
        ipv4Only: !sphiaConfig.enableIpv6,
      );
    }

    List<Inbound> inbounds = [
      SingBoxGenerate.mixedInbound(
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
      ),
    ];
    if (sphiaConfig.enableTun) {
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

    final ruleConfig = GetIt.I.get<RuleConfigProvider>().config;
    List<Rule> rules =
        await ruleDao.getOrderedRulesByGroupId(ruleConfig.selectedRuleGroupId);
    // remove disabled rules
    rules.removeWhere((rule) => !rule.enabled);
    List<Outbound> outboundsOnRouting = [];
    if (!sphiaConfig.multiOutboundSupport) {
      rules.removeWhere((rule) =>
          rule.outboundTag != outboundProxyId &&
          rule.outboundTag != outboundDirectId &&
          rule.outboundTag != outboundBlockId);
    } else {
      final serversOnRoutingId = await getRuleOutboundTagList(rules);
      final serversOnRouting =
          await serverDao.getServersByIdList(serversOnRoutingId);
      // add servers on routing to outbounds, outbound.tag is proxy-serverId
      for (final server in serversOnRouting) {
        outboundsOnRouting.add(
          SingBoxGenerate.generateOutbound(server)..tag = 'proxy-${server.id}',
        );
      }
      serverId.addAll(serversOnRoutingId);
    }
    Route? route;
    if (sphiaConfig.enableTun || (!sphiaConfig.enableTun && isRouting)) {
      route = SingBoxGenerate.route(
        rules,
        sphiaConfig.configureDns,
      );
    }

    final outbounds = [
      SingBoxGenerate.generateOutbound(mainServer)
        ..tag = 'proxy', // the main proxy
      ...outboundsOnRouting
    ];

    if (sphiaConfig.configureDns) {
      outbounds.add(
        Outbound(
          type: 'dns',
          tag: 'dns-out',
        ),
      );
    }
    outbounds.addAll(
      [
        Outbound(
          type: 'direct',
          tag: 'direct',
        ),
        Outbound(
          type: 'block',
          tag: 'block',
        ),
      ],
    );

    Experimental? experimental;
    if (sphiaConfig.enableStatistics && isRouting) {
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
            externalController: '127.0.0.1:${sphiaConfig.coreApiPort}',
          ),
          cacheFile: CacheFile(
            enabled: true,
            path: p.join(tempPath, 'cache.db'),
          ),
        );
      } else {
        experimental = Experimental(
          clashApi: ClashApi(
            externalController: '127.0.0.1:${sphiaConfig.coreApiPort}',
            storeSelected: true,
            cacheFile: p.join(tempPath, 'cache.db'),
          ),
        );
      }
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

Future<List<int>> getRuleOutboundTagList(List<Rule> rules) async {
  final outboundTags = <int>[];
  for (final rule in rules) {
    if (rule.outboundTag != outboundProxyId &&
        rule.outboundTag != outboundDirectId &&
        rule.outboundTag != outboundBlockId) {
      outboundTags.add(rule.outboundTag);
    }
  }
  return outboundTags;
}
