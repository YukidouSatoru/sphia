import 'dart:convert';
import 'dart:core';

import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as p;
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/app/log.dart';
import 'package:sphia/app/provider/rule_config.dart';
import 'package:sphia/app/provider/sphia_config.dart';
import 'package:sphia/core/core_base.dart';
import 'package:sphia/core/sing/config.dart';
import 'package:sphia/core/sing/generate.dart';
import 'package:sphia/util/system.dart';

class SingBoxCore extends CoreBase {
  SingBoxCore()
      : super(
          'sing-box',
          ['run', '-c', p.join(tempPath, 'sing-box.json'), '--disable-color'],
          'sing-box.json',
        );

  @override
  Future<void> configure(Server server) async {
    final jsonString = await generateConfig(server);
    await writeConfig(jsonString);
  }

  @override
  Future<String> generateConfig(Server server) async {
    final sphiaConfig = GetIt.I.get<SphiaConfigProvider>().config;

    String level = LogLevel.values[sphiaConfig.logLevel].name;
    if (level == 'warning') {
      level = 'warn';
    }
    final log = Log(
      disabled: level == 'none',
      level: level == 'none' ? null : level,
      output: sphiaConfig.saveCoreLog ? SphiaLog.getLogPath(coreName) : null,
      timestamp: true,
    );

    Dns? dns;
    if (sphiaConfig.enableTun || (sphiaConfig.configureDns && isRouting)) {
      dns = await SingBoxGenerate.dns(
        sphiaConfig.remoteDns,
        sphiaConfig.directDns,
        server.address,
        !sphiaConfig.enableIpv6,
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
          sphiaConfig.enableIpv4 ? sphiaConfig.ipv4Address : null,
          sphiaConfig.enableIpv6 ? sphiaConfig.ipv6Address : null,
          sphiaConfig.mtu,
          TunStack.values[sphiaConfig.stack].name,
          sphiaConfig.autoRoute,
          sphiaConfig.strictRoute,
          sphiaConfig.enableSniffing,
          sphiaConfig.endpointIndependentNat,
        ),
      );
    }

    final ruleConfig = GetIt.I.get<RuleConfigProvider>().config;
    Route? route;
    if (sphiaConfig.enableTun || (!sphiaConfig.enableTun && isRouting)) {
      route = SingBoxGenerate.route(
        await SphiaDatabase.ruleDao
            .getRulesByGroupId(ruleConfig.selectedRuleGroupId),
        sphiaConfig.configureDns,
      );
    }

    final outbounds = [SingBoxGenerate.generateOutbound(server)];

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
      experimental = Experimental(
        clashApi: ClashApi(
          externalController: '127.0.0.1:${sphiaConfig.coreApiPort}',
          storeSelected: true,
          cacheFile: p.join(tempPath, 'cache.db'),
        ),
      );
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
