import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/database/dao/rule.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/notifier/config/rule_config.dart';
import 'package:sphia/app/notifier/config/sphia_config.dart';
import 'package:sphia/core/core.dart';
import 'package:sphia/core/helper.dart';
import 'package:sphia/core/xray/config.dart';
import 'package:sphia/core/xray/generate.dart';
import 'package:sphia/util/system.dart';

class XrayCore extends Core {
  late final Ref ref;
  final _logStreamController = StreamController<String>.broadcast();

  Stream<String> get logStream => _logStreamController.stream;

  XrayCore()
      : super(
          'xray-core',
          ['run', '-c', p.join(tempPath, 'xray.json')],
          'xray.json',
        );

  @override
  Future<void> stop([bool checkPorts = true]) async {
    await super.stop();
    if (!_logStreamController.isClosed) {
      await _logStreamController.close();
    }
  }

  @override
  void listenToProcessStream(Stream<List<int>> stream) {
    logSubscription = stream.transform(utf8.decoder).listen((data) {
      if (data.trim().isNotEmpty) {
        _logStreamController.add(data);
        if (isPreLog) {
          preLogList.add(data);
        }
      }
    });
  }

  @override
  Future<void> configure() async {
    final sphiaConfig = ref.read(sphiaConfigNotifierProvider);
    final ruleConfig = ref.read(ruleConfigNotifierProvider);
    final userAgent = sphiaConfig.getUserAgent();
    final outbounds = [
      XrayGenerate.generateOutbound(servers.first, userAgent)..tag = 'proxy',
    ];
    List<Rule> rules =
        await ruleDao.getOrderedRulesByGroupId(ruleConfig.selectedRuleGroupId);
    late final XrayConfigParameters parameters;

    rules.removeWhere((rule) => !rule.enabled);

    if (sphiaConfig.multiOutboundSupport) {
      final serversOnRoutingId = await CoreHelper.getRuleOutboundTagList(rules);
      final serversOnRouting =
          await serverDao.getServerModelsByIdList(serversOnRoutingId);
      for (final server in serversOnRouting) {
        outbounds.add(
          XrayGenerate.generateOutbound(server, userAgent)
            ..tag = 'proxy-${server.id}',
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
      loglevel: sphiaConfig.logLevel.name,
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
        domainStrategy: sphiaConfig.domainStrategy.name,
        domainMatcher: sphiaConfig.domainMatcher.name,
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
