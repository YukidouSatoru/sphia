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
import 'package:sphia/core/helper.dart';
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
  Future<void> configure() async {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;
    final ruleConfig = GetIt.I.get<RuleConfigProvider>().config;
    final outbounds = [
      XrayGenerate.generateOutbound(servers.first)..tag = 'proxy',
    ];
    List<Rule> rules =
        await ruleDao.getOrderedRulesByGroupId(ruleConfig.selectedRuleGroupId);
    late final XrayConfigParameters parameters;

    rules.removeWhere((rule) => !rule.enabled);

    if (sphiaConfig.multiOutboundSupport) {
      final serversOnRoutingId = await CoreHelper.getRuleOutboundTagList(rules);
      final serversOnRouting =
          await serverDao.getServersByIdList(serversOnRoutingId);
      for (final server in serversOnRouting) {
        outbounds.add(
          XrayGenerate.generateOutbound(server)..tag = 'proxy-${server.id}',
        );
      }
      servers.addAll(serversOnRouting);
    } else {
      rules.removeWhere((rule) =>
          rule.outboundTag != outboundProxyId &&
          rule.outboundTag != outboundDirectId &&
          rule.outboundTag != outboundBlockId);
    }

    final configureDns = sphiaConfig.configureDns && isRouting;
    final enableApi = sphiaConfig.enableStatistics && isRouting;
    parameters = XrayConfigParameters(
      outbounds: outbounds,
      rules: rules,
      configureDns: configureDns,
      enableApi: enableApi,
      sphiaConfig: sphiaConfig,
    );

    final jsonString = await generateConfig(parameters);
    await writeConfig(jsonString);
  }

  @override
  Future<String> generateConfig(ConfigParameters parameters) async {
    final paras = parameters as XrayConfigParameters;
    final sphiaConfig = paras.sphiaConfig;
    final log = Log(
      access: sphiaConfig.saveCoreLog ? SphiaLog.getLogPath(name) : null,
      loglevel: LogLevel.values[sphiaConfig.logLevel].name,
    );

    Dns? dns;
    if (paras.configureDns) {
      dns = XrayGenerate.dns(sphiaConfig.remoteDns, sphiaConfig.directDns);
    }

    List<Inbound> inbounds = [
      XrayGenerate.inbound(
        protocol: 'socks',
        port: sphiaConfig.socksPort,
        listen: sphiaConfig.listen,
        enableSniffing: sphiaConfig.enableSniffing,
        isAuth: sphiaConfig.authentication,
        user: sphiaConfig.user,
        pass: sphiaConfig.password,
        enableUdp: sphiaConfig.enableUdp,
      ),
      XrayGenerate.inbound(
        protocol: 'http',
        port: sphiaConfig.httpPort,
        listen: sphiaConfig.listen,
        enableSniffing: sphiaConfig.enableSniffing,
        isAuth: sphiaConfig.authentication,
        user: sphiaConfig.user,
        pass: sphiaConfig.password,
        enableUdp: sphiaConfig.enableUdp,
      ),
    ];
    usedPorts.addAll([sphiaConfig.socksPort, sphiaConfig.httpPort]);

    Routing? routing;
    if (isRouting) {
      routing = XrayGenerate.routing(
        domainStrategy: DomainStrategy.values[sphiaConfig.domainStrategy].name,
        domainMatcher: DomainMatcher.values[sphiaConfig.domainMatcher].name,
        rules: paras.rules,
        enableApi: sphiaConfig.enableStatistics,
      );
    }

    final outbounds = paras.outbounds;

    outbounds.addAll([
      Outbound(tag: 'direct', protocol: 'freedom'),
      Outbound(tag: 'block', protocol: 'blackhole'),
    ]);

    Api? api;
    Policy? policy;
    Stats? stats;
    if (paras.enableApi) {
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
      usedPorts.add(sphiaConfig.coreApiPort);
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

class XrayConfigParameters extends ConfigParameters {
  final List<Outbound> outbounds;
  final List<Rule> rules;
  final bool configureDns;
  final bool enableApi;
  final SphiaConfig sphiaConfig;

  XrayConfigParameters({
    required this.outbounds,
    required this.rules,
    required this.configureDns,
    required this.enableApi,
    required this.sphiaConfig,
  });
}
