import 'package:sphia/app/database/database.dart';
import 'package:sphia/core/rule/sing.dart';
import 'package:sphia/core/rule/xray.dart';

extension RuleExtension on Rule {
  XrayRule toXrayRule() {
    final domain = this.domain?.split(',');
    final ip = this.ip?.split(',');
    return XrayRule(
      outboundTag: outboundTag.toString(),
      domain: domain,
      ip: ip,
      port: port,
    );
  }

  SingBoxRule toSingBoxRule() {
    List<String> geosite = [];
    List<String> domain = [];
    List<String> geoip = [];
    List<String> ipCidr = [];
    List<int> port = [];
    List<String> portRange = [];
    if (this.domain != null) {
      for (var domainItem in this.domain!.split(',')) {
        if (domainItem.startsWith('geosite:')) {
          geosite.add(domainItem.replaceFirst('geosite:', ''));
        } else {
          domain.add(domainItem);
        }
      }
    }
    if (ip != null) {
      for (var ipItem in ip!.split(',')) {
        if (ipItem.startsWith('geoip:')) {
          geoip.add(ipItem.replaceFirst('geoip:', ''));
        } else {
          ipCidr.add(ipItem);
        }
      }
    }
    if (this.port != null) {
      for (var portItem in this.port!.split(',')) {
        if (portItem.contains('-')) {
          portRange.add(portItem.replaceAll('-', ':'));
        } else {
          try {
            port.add(int.parse(portItem));
          } catch (e) {
            // ignore
          }
        }
      }
    }
    final processName = this.processName?.split(',');
    return SingBoxRule(
      geosite: geosite.isEmpty ? null : geosite,
      domain: domain.isEmpty ? null : domain,
      geoip: geoip.isEmpty ? null : geoip,
      ipCidr: ipCidr.isEmpty ? null : ipCidr,
      port: port.isEmpty ? null : port,
      portRange: portRange.isEmpty ? null : portRange,
      outbound: outboundTag.toString(),
      processName: processName,
    );
  }
}
