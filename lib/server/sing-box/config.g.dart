// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SingBoxConfig _$SingBoxConfigFromJson(Map<String, dynamic> json) =>
    SingBoxConfig(
      log: json['log'] == null
          ? null
          : Log.fromJson(json['log'] as Map<String, dynamic>),
      dns: json['dns'] == null
          ? null
          : Dns.fromJson(json['dns'] as Map<String, dynamic>),
      route: json['route'] == null
          ? null
          : Route.fromJson(json['route'] as Map<String, dynamic>),
      inbounds: (json['inbounds'] as List<dynamic>?)
          ?.map((e) => Inbound.fromJson(e as Map<String, dynamic>))
          .toList(),
      outbounds: (json['outbounds'] as List<dynamic>?)
          ?.map((e) => Outbound.fromJson(e as Map<String, dynamic>))
          .toList(),
      experimental: json['experimental'] == null
          ? null
          : Experimental.fromJson(json['experimental'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SingBoxConfigToJson(SingBoxConfig instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('log', instance.log);
  writeNotNull('dns', instance.dns);
  writeNotNull('route', instance.route);
  writeNotNull('inbounds', instance.inbounds);
  writeNotNull('outbounds', instance.outbounds);
  writeNotNull('experimental', instance.experimental);
  return val;
}

Log _$LogFromJson(Map<String, dynamic> json) => Log(
      disabled: json['disabled'] as bool,
      level: json['level'] as String?,
      output: json['output'] as String?,
      timestamp: json['timestamp'] as bool,
    );

Map<String, dynamic> _$LogToJson(Log instance) {
  final val = <String, dynamic>{
    'disabled': instance.disabled,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('level', instance.level);
  writeNotNull('output', instance.output);
  val['timestamp'] = instance.timestamp;
  return val;
}

Dns _$DnsFromJson(Map<String, dynamic> json) => Dns(
      servers: (json['servers'] as List<dynamic>)
          .map((e) => DnsServer.fromJson(e as Map<String, dynamic>))
          .toList(),
      rules: (json['rules'] as List<dynamic>)
          .map((e) => DnsRule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DnsToJson(Dns instance) => <String, dynamic>{
      'servers': instance.servers,
      'rules': instance.rules,
    };

DnsServer _$DnsServerFromJson(Map<String, dynamic> json) => DnsServer(
      tag: json['tag'] as String,
      address: json['address'] as String,
      addressResolver: json['address_resolver'] as String?,
      strategy: json['strategy'] as String?,
      detour: json['detour'] as String?,
    );

Map<String, dynamic> _$DnsServerToJson(DnsServer instance) {
  final val = <String, dynamic>{
    'tag': instance.tag,
    'address': instance.address,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('address_resolver', instance.addressResolver);
  writeNotNull('strategy', instance.strategy);
  writeNotNull('detour', instance.detour);
  return val;
}

RouteRule _$RouteRuleFromJson(Map<String, dynamic> json) => RouteRule(
      protocol: json['protocol'] as String?,
      geosite:
          (json['geosite'] as List<dynamic>?)?.map((e) => e as String).toList(),
      geoip:
          (json['geoip'] as List<dynamic>?)?.map((e) => e as String).toList(),
      domain:
          (json['domain'] as List<dynamic>?)?.map((e) => e as String).toList(),
      ipCidr:
          (json['ip_cidr'] as List<dynamic>?)?.map((e) => e as String).toList(),
      port: (json['port'] as List<dynamic>?)?.map((e) => e as int).toList(),
      portRange: (json['port_range'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      outbound: json['outbound'] as String?,
      processName: (json['process_name'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$RouteRuleToJson(RouteRule instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('protocol', instance.protocol);
  writeNotNull('geosite', instance.geosite);
  writeNotNull('geoip', instance.geoip);
  writeNotNull('domain', instance.domain);
  writeNotNull('ip_cidr', instance.ipCidr);
  writeNotNull('port', instance.port);
  writeNotNull('port_range', instance.portRange);
  writeNotNull('outbound', instance.outbound);
  writeNotNull('process_name', instance.processName);
  return val;
}

DnsRule _$DnsRuleFromJson(Map<String, dynamic> json) => DnsRule(
      geosite:
          (json['geosite'] as List<dynamic>?)?.map((e) => e as String).toList(),
      geoip:
          (json['geoip'] as List<dynamic>?)?.map((e) => e as String).toList(),
      domain:
          (json['domain'] as List<dynamic>?)?.map((e) => e as String).toList(),
      server: json['server'] as String?,
      disableCache: json['disable_cache'] as bool?,
      outbound: (json['outbound'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$DnsRuleToJson(DnsRule instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('geosite', instance.geosite);
  writeNotNull('geoip', instance.geoip);
  writeNotNull('domain', instance.domain);
  writeNotNull('server', instance.server);
  writeNotNull('disable_cache', instance.disableCache);
  writeNotNull('outbound', instance.outbound);
  return val;
}

Route _$RouteFromJson(Map<String, dynamic> json) => Route(
      geoip: json['geoip'] == null
          ? null
          : Geoip.fromJson(json['geoip'] as Map<String, dynamic>),
      geosite: json['geosite'] == null
          ? null
          : Geosite.fromJson(json['geosite'] as Map<String, dynamic>),
      rules: (json['rules'] as List<dynamic>?)
          ?.map((e) => RouteRule.fromJson(e as Map<String, dynamic>))
          .toList(),
      autoDetectInterface: json['auto_detect_interface'] as bool,
      finalTag: json['final'] as String?,
    );

Map<String, dynamic> _$RouteToJson(Route instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('geoip', instance.geoip);
  writeNotNull('geosite', instance.geosite);
  writeNotNull('rules', instance.rules);
  val['auto_detect_interface'] = instance.autoDetectInterface;
  writeNotNull('final', instance.finalTag);
  return val;
}

Geoip _$GeoipFromJson(Map<String, dynamic> json) => Geoip(
      path: json['path'] as String,
    );

Map<String, dynamic> _$GeoipToJson(Geoip instance) => <String, dynamic>{
      'path': instance.path,
    };

Geosite _$GeositeFromJson(Map<String, dynamic> json) => Geosite(
      path: json['path'] as String,
    );

Map<String, dynamic> _$GeositeToJson(Geosite instance) => <String, dynamic>{
      'path': instance.path,
    };

Inbound _$InboundFromJson(Map<String, dynamic> json) => Inbound(
      type: json['type'] as String,
      tag: json['tag'] as String?,
      listen: json['listen'] as String?,
      listenPort: json['listen_port'] as int?,
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      interfaceName: json['interface_name'] as String?,
      inet4Address: json['inet4_address'] as String?,
      inet6Address: json['inet6_address'] as String?,
      mtu: json['mtu'] as int?,
      autoRoute: json['auto_route'] as bool?,
      strictRoute: json['strict_route'] as bool?,
      stack: json['stack'] as String?,
      sniff: json['sniff'] as bool?,
    );

Map<String, dynamic> _$InboundToJson(Inbound instance) {
  final val = <String, dynamic>{
    'type': instance.type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('tag', instance.tag);
  writeNotNull('listen', instance.listen);
  writeNotNull('listen_port', instance.listenPort);
  writeNotNull('users', instance.users);
  writeNotNull('interface_name', instance.interfaceName);
  writeNotNull('inet4_address', instance.inet4Address);
  writeNotNull('inet6_address', instance.inet6Address);
  writeNotNull('mtu', instance.mtu);
  writeNotNull('auto_route', instance.autoRoute);
  writeNotNull('strict_route', instance.strictRoute);
  writeNotNull('stack', instance.stack);
  writeNotNull('sniff', instance.sniff);
  return val;
}

Outbound _$OutboundFromJson(Map<String, dynamic> json) => Outbound(
      type: json['type'] as String,
      tag: json['tag'] as String?,
      server: json['server'] as String?,
      serverPort: json['server_port'] as int?,
      version: json['version'] as String?,
      username: json['username'] as String?,
      method: json['method'] as String?,
      password: json['password'] as String?,
      plugin: json['plugin'] as String?,
      pluginOpts: json['plugin_opts'] as String?,
      uuid: json['uuid'] as String?,
      flow: json['flow'] as String?,
      security: json['security'] as String?,
      alterId: json['alter_id'] as int?,
      network: json['network'] as String?,
      tls: json['tls'] == null
          ? null
          : Tls.fromJson(json['tls'] as Map<String, dynamic>),
      transport: json['transport'] == null
          ? null
          : Transport.fromJson(json['transport'] as Map<String, dynamic>),
      upMbps: json['upMbps'] as int?,
      downMbps: json['downMbps'] as int?,
      obfs: json['obfs'] as String?,
      auth: json['auth'] as String?,
      authStr: json['auth_str'] as String?,
      recvWindowConn: json['recv_window_conn'] as int?,
      recvWindow: json['recv_window'] as int?,
      disableMtuDiscovery: json['disable_mtu_discovery'] as int?,
    );

Map<String, dynamic> _$OutboundToJson(Outbound instance) {
  final val = <String, dynamic>{
    'type': instance.type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('tag', instance.tag);
  writeNotNull('server', instance.server);
  writeNotNull('server_port', instance.serverPort);
  writeNotNull('version', instance.version);
  writeNotNull('username', instance.username);
  writeNotNull('method', instance.method);
  writeNotNull('password', instance.password);
  writeNotNull('plugin', instance.plugin);
  writeNotNull('plugin_opts', instance.pluginOpts);
  writeNotNull('uuid', instance.uuid);
  writeNotNull('flow', instance.flow);
  writeNotNull('security', instance.security);
  writeNotNull('alter_id', instance.alterId);
  writeNotNull('network', instance.network);
  writeNotNull('tls', instance.tls);
  writeNotNull('transport', instance.transport);
  writeNotNull('upMbps', instance.upMbps);
  writeNotNull('downMbps', instance.downMbps);
  writeNotNull('obfs', instance.obfs);
  writeNotNull('auth', instance.auth);
  writeNotNull('auth_str', instance.authStr);
  writeNotNull('recv_window_conn', instance.recvWindowConn);
  writeNotNull('recv_window', instance.recvWindow);
  writeNotNull('disable_mtu_discovery', instance.disableMtuDiscovery);
  return val;
}

Tls _$TlsFromJson(Map<String, dynamic> json) => Tls(
      enabled: json['enabled'] as bool,
      serverName: json['server_name'] as String,
      insecure: json['insecure'] as bool,
      alpn: (json['alpn'] as List<dynamic>?)?.map((e) => e as String).toList(),
      utls: json['utls'] == null
          ? null
          : UTls.fromJson(json['utls'] as Map<String, dynamic>),
      reality: json['reality'] == null
          ? null
          : Reality.fromJson(json['reality'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TlsToJson(Tls instance) {
  final val = <String, dynamic>{
    'enabled': instance.enabled,
    'server_name': instance.serverName,
    'insecure': instance.insecure,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('alpn', instance.alpn);
  writeNotNull('utls', instance.utls);
  writeNotNull('reality', instance.reality);
  return val;
}

UTls _$UTlsFromJson(Map<String, dynamic> json) => UTls(
      enabled: json['enabled'] as bool,
      fingerprint: json['fingerprint'] as String?,
    );

Map<String, dynamic> _$UTlsToJson(UTls instance) {
  final val = <String, dynamic>{
    'enabled': instance.enabled,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('fingerprint', instance.fingerprint);
  return val;
}

Reality _$RealityFromJson(Map<String, dynamic> json) => Reality(
      enabled: json['enabled'] as bool,
      publicKey: json['public_key'] as String,
      shortId: json['short_id'] as String?,
    );

Map<String, dynamic> _$RealityToJson(Reality instance) {
  final val = <String, dynamic>{
    'enabled': instance.enabled,
    'public_key': instance.publicKey,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('short_id', instance.shortId);
  return val;
}

Transport _$TransportFromJson(Map<String, dynamic> json) => Transport(
      type: json['type'] as String,
      host: json['host'] as String?,
      path: json['path'] as String?,
      serviceName: json['service_name'] as String?,
    );

Map<String, dynamic> _$TransportToJson(Transport instance) {
  final val = <String, dynamic>{
    'type': instance.type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('host', instance.host);
  writeNotNull('path', instance.path);
  writeNotNull('service_name', instance.serviceName);
  return val;
}

User _$UserFromJson(Map<String, dynamic> json) => User(
      username: json['username'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('username', instance.username);
  writeNotNull('password', instance.password);
  return val;
}

Experimental _$ExperimentalFromJson(Map<String, dynamic> json) => Experimental(
      clashApi: json['clash_api'] == null
          ? null
          : ClashApi.fromJson(json['clash_api'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExperimentalToJson(Experimental instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('clash_api', instance.clashApi);
  return val;
}

ClashApi _$ClashApiFromJson(Map<String, dynamic> json) => ClashApi(
      externalController: json['external_controller'] as String,
      storeSelected: json['store_selected'] as bool,
      cacheFile: json['cache_file'] as String?,
    );

Map<String, dynamic> _$ClashApiToJson(ClashApi instance) {
  final val = <String, dynamic>{
    'external_controller': instance.externalController,
    'store_selected': instance.storeSelected,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('cache_file', instance.cacheFile);
  return val;
}
