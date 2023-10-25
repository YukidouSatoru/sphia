import 'dart:convert';
import 'dart:core';

import 'package:path/path.dart' as p;
import 'package:sphia/app/database/database.dart';
import 'package:sphia/server/core_base.dart';
import 'package:sphia/server/server_base.dart';
import 'package:sphia/server/sing-box/config.dart';
import 'package:sphia/server/sing-box/generate.dart';
import 'package:sphia/util/system.dart';

class SingBoxCore extends CoreBase {
  SingBoxCore()
      : super(
          'sing-box',
          ['run', '-c', p.join(tempPath, 'sing-box.json'), '--disable-color'],
          'sing-box.json',
        );

  @override
  Future<void> configure(ServerBase server) async {
    String level = sphiaConfig.logLevel;
    if (level == 'warning') {
      level = 'warn';
    }
    final log = Log(
      disabled: level == 'none',
      level: level == 'none' ? null : level,
      output: sphiaConfig.saveCoreLog ? coreLogPath : null,
      timestamp: true,
    );

    Dns? dns;
    if (sphiaConfig.enableTun ||
        (sphiaConfig.configureDns && sphiaConfig.routingProvider == coreName)) {
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
          sphiaConfig.stack,
          sphiaConfig.autoRoute,
          sphiaConfig.strictRoute,
          sphiaConfig.enableSniffing,
        ),
      );
    }

    Route? route;
    if (sphiaConfig.enableTun ||
        (!sphiaConfig.enableTun && sphiaConfig.routingProvider == coreName)) {
      route = SingBoxGenerate.route(
        await SphiaDatabase.ruleDao
            .getXrayRulesByGroupId(ruleConfig.selectedRuleGroupId),
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
    if (sphiaConfig.enableStatistics &&
        sphiaConfig.routingProvider == 'sing-box') {
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

    String jsonString = jsonEncode(singBoxConfig.toJson());
    await writeConfig(jsonString);
  }
}
