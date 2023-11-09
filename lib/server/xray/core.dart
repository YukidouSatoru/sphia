import 'dart:convert';
import 'dart:core';

import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as p;
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/rule_config.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/server/core_base.dart';
import 'package:sphia/server/server_base.dart';
import 'package:sphia/server/xray/config.dart';
import 'package:sphia/server/xray/generate.dart';
import 'package:sphia/util/system.dart';

class XrayCore extends CoreBase {
  XrayCore()
      : super(
          'xray-core',
          ['run', '-c', p.join(tempPath, 'xray.json')],
          'xray.json',
        );

  @override
  Future<void> configure(ServerBase server) async {
    final jsonString = await generateConfig(server);
    await writeConfig(jsonString);
  }

  @override
  Future<String> generateConfig(ServerBase server) async {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;

    final log = Log(
      access: SphiaLog.getLogPath(coreName),
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

    final outbounds = [
      XrayGenerate.generateOutbound(server),
      Outbound(tag: 'direct', protocol: 'freedom'),
      Outbound(tag: 'block', protocol: 'blackhole'),
    ];

    final ruleConfig = GetIt.I.get<RuleConfigProvider>().config;
    Routing? routing;
    if (isRouting) {
      routing = XrayGenerate.routing(
        DomainStrategy.values[sphiaConfig.domainStrategy].name,
        DomainMatcher.values[sphiaConfig.domainMatcher].name,
        await SphiaDatabase.ruleDao
            .getXrayRulesByGroupId(ruleConfig.selectedRuleGroupId),
        sphiaConfig.enableStatistics,
      );
    }

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
