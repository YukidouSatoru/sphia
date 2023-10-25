import 'dart:convert';
import 'dart:core';

import 'package:path/path.dart' as p;
import 'package:sphia/app/database/database.dart';
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
    final log = XrayGenerate.log(coreLogPath, sphiaConfig.logLevel);

    Dns? dns;
    if (sphiaConfig.configureDns && sphiaConfig.routingProvider == coreName) {
      dns = XrayGenerate.dns(sphiaConfig.remoteDns, sphiaConfig.directDns);
    }

    final outbounds = [
      XrayGenerate.generateOutbound(server),
      Outbound(tag: 'direct', protocol: 'freedom'),
      Outbound(tag: 'block', protocol: 'blackhole'),
    ];

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

    if (sphiaConfig.enableStatistics &&
        sphiaConfig.routingProvider == coreName) {
      inbounds.add(
        Inbound(
          tag: 'api',
          port: 11110,
          listen: '127.0.0.1',
          protocol: 'dokodemo-door',
          settings: InboundSetting(address: '127.0.0.1'),
        ),
      );
    }

    Routing? routing;
    if (sphiaConfig.routingProvider == coreName) {
      routing = XrayGenerate.routing(
        sphiaConfig.domainStrategy,
        sphiaConfig.domainMatcher,
        await SphiaDatabase.ruleDao
            .getXrayRulesByGroupId(ruleConfig.selectedRuleGroupId),
        sphiaConfig.enableStatistics,
      );
    }

    Api? api;
    Policy? policy;
    Stats? stats;
    if (sphiaConfig.enableStatistics &&
        sphiaConfig.routingProvider == coreName) {
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
