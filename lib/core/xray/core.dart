import 'dart:convert';
import 'dart:core';

import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as p;
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/database/dao/rule.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/rule_config.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/core/core.dart';
import 'package:sphia/core/xray/config.dart';
import 'package:sphia/core/xray/generate.dart';
import 'package:sphia/util/system.dart';

class XrayCore extends Core {
  XrayCore()
      : super(
          'xray-core',
          ['run', '-c', p.join(tempPath, 'xray.json')],
          'xray.json',
        );

  @override
  Future<void> configure(Server selectedServer) async {
    serverId = [selectedServer.id];
    final jsonString = await generateConfig(selectedServer);
    await writeConfig(jsonString);
  }

  @override
  Future<String> generateConfig(Server mainServer) async {
    final server = mainServer;
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;

    final log = Log(
      access: sphiaConfig.saveCoreLog ? SphiaLog.getLogPath(coreName) : null,
      loglevel: LogLevel.values[sphiaConfig.logLevel].name,
    );

    Dns? dns;
    if (sphiaConfig.configureDns && isRouting) {
      dns = XrayGenerate.dns(sphiaConfig.remoteDns, sphiaConfig.directDns);
    }

    List<Inbound> inbounds = [
      XrayGenerate.inbound(
        'socks',
        sphiaConfig.socksPort,
        sphiaConfig.listen,
        sphiaConfig.enableSniffing,
        sphiaConfig.authentication,
        sphiaConfig.user,
        sphiaConfig.password,
        sphiaConfig.enableUdp,
      ),
      XrayGenerate.inbound(
        'http',
        sphiaConfig.httpPort,
        sphiaConfig.listen,
        sphiaConfig.enableSniffing,
        sphiaConfig.authentication,
        sphiaConfig.user,
        sphiaConfig.password,
        sphiaConfig.enableUdp,
      ),
    ];

    final ruleConfig = GetIt.I.get<RuleConfigProvider>().config;
    List<Rule> rules =
        await ruleDao.getOrderedRulesByGroupId(ruleConfig.selectedRuleGroupId);
    rules.removeWhere((rule) => !rule.enabled);
    List<Outbound> outboundsOnRouting = [];
    if (!sphiaConfig.multiOutboundSupport) {
      rules.removeWhere((rule) =>
          rule.outboundTag != outboundProxyId &&
          rule.outboundTag != outboundDirectId &&
          rule.outboundTag != outboundBlockId);
    } else {
      final serversOnRoutingId =
          await ruleDao.getRuleOutboundTagsByGroupId(rules);
      final serversOnRouting =
          await serverDao.getServersById(serversOnRoutingId);
      for (final server in serversOnRouting) {
        outboundsOnRouting.add(
          XrayGenerate.generateOutbound(server)..tag = 'proxy-${server.id}',
        );
      }
      serverId.addAll(serversOnRoutingId);
    }
    Routing? routing;
    if (isRouting) {
      routing = XrayGenerate.routing(
        DomainStrategy.values[sphiaConfig.domainStrategy].name,
        DomainMatcher.values[sphiaConfig.domainMatcher].name,
        rules,
        sphiaConfig.enableStatistics,
      );
    }

    final outbounds = [
      XrayGenerate.generateOutbound(server)..tag = 'proxy',
      ...outboundsOnRouting,
      Outbound(tag: 'direct', protocol: 'freedom'),
      Outbound(tag: 'block', protocol: 'blackhole'),
    ];

    Api? api;
    Policy? policy;
    Stats? stats;
    if (sphiaConfig.enableStatistics && isRouting) {
      api = Api(
        tag: 'api',
        services: ['StatsService'],
      );
      policy = Policy(
        system: System(
          statsOutboundDownlink: true,
          statsOutboundUplink: true,
        ),
      );
      stats = Stats();
      inbounds.add(XrayGenerate.dokodemoInbound(sphiaConfig.coreApiPort));
    }

    final xrayConfig = XrayConfig(
      log: log,
      dns: dns,
      inbounds: inbounds,
      outbounds: outbounds,
      routing: routing,
      api: api,
      policy: policy,
      stats: stats,
    );

    return jsonEncode(xrayConfig.toJson());
  }
}
