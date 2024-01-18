// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

XrayConfig _$XrayConfigFromJson(Map<String, dynamic> json) => XrayConfig(
      log: json['log'] == null
          ? null
          : Log.fromJson(json['log'] as Map<String, dynamic>),
      dns: json['dns'] == null
          ? null
          : Dns.fromJson(json['dns'] as Map<String, dynamic>),
      inbounds: (json['inbounds'] as List<dynamic>?)
          ?.map((e) => Inbound.fromJson(e as Map<String, dynamic>))
          .toList(),
      outbounds: (json['outbounds'] as List<dynamic>?)
          ?.map((e) => Outbound.fromJson(e as Map<String, dynamic>))
          .toList(),
      routing: json['routing'] == null
          ? null
          : Routing.fromJson(json['routing'] as Map<String, dynamic>),
      api: json['api'] == null
          ? null
          : Api.fromJson(json['api'] as Map<String, dynamic>),
      policy: json['policy'] == null
          ? null
          : Policy.fromJson(json['policy'] as Map<String, dynamic>),
      stats: json['stats'] == null
          ? null
          : Stats.fromJson(json['stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$XrayConfigToJson(XrayConfig instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('log', instance.log);
  writeNotNull('dns', instance.dns);
  writeNotNull('inbounds', instance.inbounds);
  writeNotNull('outbounds', instance.outbounds);
  writeNotNull('routing', instance.routing);
  writeNotNull('api', instance.api);
  writeNotNull('policy', instance.policy);
  writeNotNull('stats', instance.stats);
  return val;
}

Sniffing _$SniffingFromJson(Map<String, dynamic> json) => Sniffing()
  ..enabled = json['enabled'] as bool
  ..destOverride =
      (json['destOverride'] as List<dynamic>).map((e) => e as String).toList();

Map<String, dynamic> _$SniffingToJson(Sniffing instance) => <String, dynamic>{
      'enabled': instance.enabled,
      'destOverride': instance.destOverride,
    };

Dns _$DnsFromJson(Map<String, dynamic> json) => Dns(
      servers: (json['servers'] as List<dynamic>)
          .map((e) => DnsServer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DnsToJson(Dns instance) => <String, dynamic>{
      'servers': instance.servers,
    };

DnsServer _$DnsServerFromJson(Map<String, dynamic> json) => DnsServer(
      address: json['address'] as String,
      domains:
          (json['domains'] as List<dynamic>?)?.map((e) => e as String).toList(),
      skipFallback: json['skipFallback'] as bool?,
    );

Map<String, dynamic> _$DnsServerToJson(DnsServer instance) {
  final val = <String, dynamic>{
    'address': instance.address,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('domains', instance.domains);
  writeNotNull('skipFallback', instance.skipFallback);
  return val;
}

Log _$LogFromJson(Map<String, dynamic> json) => Log(
      access: json['access'] as String?,
      error: json['error'] as String?,
      loglevel: json['loglevel'] as String,
    );

Map<String, dynamic> _$LogToJson(Log instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('access', instance.access);
  writeNotNull('error', instance.error);
  val['loglevel'] = instance.loglevel;
  return val;
}

Inbound _$InboundFromJson(Map<String, dynamic> json) => Inbound(
      tag: json['tag'] as String?,
      port: json['port'] as int,
      listen: json['listen'] as String,
      protocol: json['protocol'] as String,
      sniffing: json['sniffing'] == null
          ? null
          : Sniffing.fromJson(json['sniffing'] as Map<String, dynamic>),
      settings:
          InboundSetting.fromJson(json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InboundToJson(Inbound instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('tag', instance.tag);
  val['port'] = instance.port;
  val['listen'] = instance.listen;
  val['protocol'] = instance.protocol;
  writeNotNull('sniffing', instance.sniffing);
  val['settings'] = instance.settings;
  return val;
}

InboundSetting _$InboundSettingFromJson(Map<String, dynamic> json) =>
    InboundSetting(
      auth: json['auth'] as String?,
      accounts: (json['accounts'] as List<dynamic>?)
          ?.map((e) => Accounts.fromJson(e as Map<String, dynamic>))
          .toList(),
      udp: json['udp'] as bool?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$InboundSettingToJson(InboundSetting instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('auth', instance.auth);
  writeNotNull('accounts', instance.accounts);
  writeNotNull('udp', instance.udp);
  writeNotNull('address', instance.address);
  return val;
}

Accounts _$AccountsFromJson(Map<String, dynamic> json) => Accounts(
      user: json['user'] as String,
      pass: json['pass'] as String,
    );

Map<String, dynamic> _$AccountsToJson(Accounts instance) => <String, dynamic>{
      'user': instance.user,
      'pass': instance.pass,
    };

Outbound _$OutboundFromJson(Map<String, dynamic> json) => Outbound(
      tag: json['tag'] as String?,
      protocol: json['protocol'] as String,
      settings: json['settings'] == null
          ? null
          : OutboundSetting.fromJson(json['settings'] as Map<String, dynamic>),
      streamSettings: json['streamSettings'] == null
          ? null
          : StreamSettings.fromJson(
              json['streamSettings'] as Map<String, dynamic>),
      mux: json['mux'] == null
          ? null
          : Mux.fromJson(json['mux'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OutboundToJson(Outbound instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('tag', instance.tag);
  val['protocol'] = instance.protocol;
  writeNotNull('settings', instance.settings);
  writeNotNull('streamSettings', instance.streamSettings);
  writeNotNull('mux', instance.mux);
  return val;
}

OutboundSetting _$OutboundSettingFromJson(Map<String, dynamic> json) =>
    OutboundSetting(
      vnext: (json['vnext'] as List<dynamic>?)
          ?.map((e) => Vnext.fromJson(e as Map<String, dynamic>))
          .toList(),
      servers: json['servers'] as List<dynamic>?,
    );

Map<String, dynamic> _$OutboundSettingToJson(OutboundSetting instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('vnext', instance.vnext);
  writeNotNull('servers', instance.servers);
  return val;
}

Socks _$SocksFromJson(Map<String, dynamic> json) => Socks(
      address: json['address'] as String,
      port: json['port'] as int,
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SocksToJson(Socks instance) {
  final val = <String, dynamic>{
    'address': instance.address,
    'port': instance.port,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('users', instance.users);
  return val;
}

Vnext _$VnextFromJson(Map<String, dynamic> json) => Vnext(
      address: json['address'] as String,
      port: json['port'] as int,
      users: (json['users'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VnextToJson(Vnext instance) => <String, dynamic>{
      'address': instance.address,
      'port': instance.port,
      'users': instance.users,
    };

Shadowsocks _$ShadowsocksFromJson(Map<String, dynamic> json) => Shadowsocks(
      address: json['address'] as String,
      port: json['port'] as int,
      method: json['method'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$ShadowsocksToJson(Shadowsocks instance) =>
    <String, dynamic>{
      'address': instance.address,
      'port': instance.port,
      'method': instance.method,
      'password': instance.password,
    };

Trojan _$TrojanFromJson(Map<String, dynamic> json) => Trojan(
      address: json['address'] as String,
      port: json['port'] as int,
      password: json['password'] as String,
    );

Map<String, dynamic> _$TrojanToJson(Trojan instance) => <String, dynamic>{
      'address': instance.address,
      'port': instance.port,
      'password': instance.password,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      user: json['user'] as String?,
      pass: json['pass'] as String?,
      id: json['id'] as String?,
      alterId: json['alterId'] as int?,
      security: json['security'] as String?,
      encryption: json['encryption'] as String?,
      flow: json['flow'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('user', instance.user);
  writeNotNull('pass', instance.pass);
  writeNotNull('id', instance.id);
  writeNotNull('alterId', instance.alterId);
  writeNotNull('security', instance.security);
  writeNotNull('encryption', instance.encryption);
  writeNotNull('flow', instance.flow);
  return val;
}

StreamSettings _$StreamSettingsFromJson(Map<String, dynamic> json) =>
    StreamSettings(
      network: json['network'] as String,
      security: json['security'] as String,
      tlsSettings: json['tlsSettings'] == null
          ? null
          : TlsSettings.fromJson(json['tlsSettings'] as Map<String, dynamic>),
      realitySettings: json['realitySettings'] == null
          ? null
          : RealitySettings.fromJson(
              json['realitySettings'] as Map<String, dynamic>),
      tcpSettings: json['tcpSettings'] == null
          ? null
          : TcpSettings.fromJson(json['tcpSettings'] as Map<String, dynamic>),
      wsSettings: json['wsSettings'] == null
          ? null
          : WsSettings.fromJson(json['wsSettings'] as Map<String, dynamic>),
      grpcSettings: json['grpcSettings'] == null
          ? null
          : GrpcSettings.fromJson(json['grpcSettings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StreamSettingsToJson(StreamSettings instance) {
  final val = <String, dynamic>{
    'network': instance.network,
    'security': instance.security,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('tlsSettings', instance.tlsSettings);
  writeNotNull('realitySettings', instance.realitySettings);
  writeNotNull('tcpSettings', instance.tcpSettings);
  writeNotNull('wsSettings', instance.wsSettings);
  writeNotNull('grpcSettings', instance.grpcSettings);
  return val;
}

TcpSettings _$TcpSettingsFromJson(Map<String, dynamic> json) => TcpSettings(
      header: json['header'] == null
          ? null
          : Header.fromJson(json['header'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TcpSettingsToJson(TcpSettings instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('header', instance.header);
  return val;
}

Header _$HeaderFromJson(Map<String, dynamic> json) => Header(
      type: json['type'] as String?,
      request: json['request'] == null
          ? null
          : Request.fromJson(json['request'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HeaderToJson(Header instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('type', instance.type);
  writeNotNull('request', instance.request);
  return val;
}

Request _$RequestFromJson(Map<String, dynamic> json) => Request(
      version: json['version'] as String?,
      method: json['method'] as String?,
      path: (json['path'] as List<dynamic>?)?.map((e) => e as String).toList(),
      headers: json['headers'] == null
          ? null
          : TcpHeaders.fromJson(json['headers'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RequestToJson(Request instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('version', instance.version);
  writeNotNull('method', instance.method);
  writeNotNull('path', instance.path);
  writeNotNull('headers', instance.headers);
  return val;
}

TcpHeaders _$TcpHeadersFromJson(Map<String, dynamic> json) => TcpHeaders(
      host: (json['Host'] as List<dynamic>?)?.map((e) => e as String).toList(),
      userAgent: (json['User-Agent'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      acceptEncoding: (json['Accept-Encoding'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      connection: (json['Connection'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      pragma: json['Pragma'] as String?,
    );

Map<String, dynamic> _$TcpHeadersToJson(TcpHeaders instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('Host', instance.host);
  writeNotNull('User-Agent', instance.userAgent);
  writeNotNull('Accept-Encoding', instance.acceptEncoding);
  writeNotNull('Connection', instance.connection);
  writeNotNull('Pragma', instance.pragma);
  return val;
}

GrpcSettings _$GrpcSettingsFromJson(Map<String, dynamic> json) => GrpcSettings(
      serviceName: json['serviceName'] as String?,
      multiMode: json['multiMode'] as bool?,
    );

Map<String, dynamic> _$GrpcSettingsToJson(GrpcSettings instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('serviceName', instance.serviceName);
  writeNotNull('multiMode', instance.multiMode);
  return val;
}

WsSettings _$WsSettingsFromJson(Map<String, dynamic> json) => WsSettings(
      path: json['path'] as String,
      headers: json['headers'] == null
          ? null
          : Headers.fromJson(json['headers'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WsSettingsToJson(WsSettings instance) {
  final val = <String, dynamic>{
    'path': instance.path,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('headers', instance.headers);
  return val;
}

Headers _$HeadersFromJson(Map<String, dynamic> json) => Headers(
      host: json['host'] as String?,
    );

Map<String, dynamic> _$HeadersToJson(Headers instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('host', instance.host);
  return val;
}

TlsSettings _$TlsSettingsFromJson(Map<String, dynamic> json) => TlsSettings(
      allowInsecure: json['allowInsecure'] as bool,
      serverName: json['serverName'] as String?,
      fingerprint: json['fingerprint'] as String?,
    );

Map<String, dynamic> _$TlsSettingsToJson(TlsSettings instance) {
  final val = <String, dynamic>{
    'allowInsecure': instance.allowInsecure,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('serverName', instance.serverName);
  writeNotNull('fingerprint', instance.fingerprint);
  return val;
}

RealitySettings _$RealitySettingsFromJson(Map<String, dynamic> json) =>
    RealitySettings(
      serverName: json['serverName'] as String?,
      fingerprint: json['fingerprint'] as String,
      shortId: json['shortId'] as String?,
      publicKey: json['publicKey'] as String,
      spiderX: json['spiderX'] as String?,
    );

Map<String, dynamic> _$RealitySettingsToJson(RealitySettings instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('serverName', instance.serverName);
  val['fingerprint'] = instance.fingerprint;
  writeNotNull('shortId', instance.shortId);
  val['publicKey'] = instance.publicKey;
  writeNotNull('spiderX', instance.spiderX);
  return val;
}

Mux _$MuxFromJson(Map<String, dynamic> json) => Mux(
      enabled: json['enabled'] as bool,
      concurrency: json['concurrency'] as int,
    );

Map<String, dynamic> _$MuxToJson(Mux instance) => <String, dynamic>{
      'enabled': instance.enabled,
      'concurrency': instance.concurrency,
    };

Routing _$RoutingFromJson(Map<String, dynamic> json) => Routing(
      domainStrategy: json['domainStrategy'] as String,
      domainMatcher: json['domainMatcher'] as String,
      rules: (json['rules'] as List<dynamic>)
          .map((e) => XrayRule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RoutingToJson(Routing instance) => <String, dynamic>{
      'domainStrategy': instance.domainStrategy,
      'domainMatcher': instance.domainMatcher,
      'rules': instance.rules,
    };

Api _$ApiFromJson(Map<String, dynamic> json) => Api(
      tag: json['tag'] as String,
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ApiToJson(Api instance) {
  final val = <String, dynamic>{
    'tag': instance.tag,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('services', instance.services);
  return val;
}

Policy _$PolicyFromJson(Map<String, dynamic> json) => Policy(
      system: System.fromJson(json['system'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PolicyToJson(Policy instance) => <String, dynamic>{
      'system': instance.system,
    };

System _$SystemFromJson(Map<String, dynamic> json) => System(
      statsInboundUplink: json['statsInboundUplink'] as bool?,
      statsInboundDownlink: json['statsInboundDownlink'] as bool?,
      statsOutboundUplink: json['statsOutboundUplink'] as bool?,
      statsOutboundDownlink: json['statsOutboundDownlink'] as bool?,
    );

Map<String, dynamic> _$SystemToJson(System instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('statsInboundUplink', instance.statsInboundUplink);
  writeNotNull('statsInboundDownlink', instance.statsInboundDownlink);
  writeNotNull('statsOutboundUplink', instance.statsOutboundUplink);
  writeNotNull('statsOutboundDownlink', instance.statsOutboundDownlink);
  return val;
}

Stats _$StatsFromJson(Map<String, dynamic> json) => Stats();

Map<String, dynamic> _$StatsToJson(Stats instance) => <String, dynamic>{};
