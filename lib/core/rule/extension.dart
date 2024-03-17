import 'package:sphia/app/database/database.dart';
import 'package:sphia/core/rule/sing.dart';
import 'package:sphia/core/rule/xray.dart';

const defaultRuleId = -1;
const defaultRuleGroupId = -1;

extension RuleExtension on Rule {
  XrayRule toXrayRule() {
    final domain = this.domain?.split(',');
    final ip = this.ip?.split(',');
    return XrayRule(
      outboundTag: outboundTag.toString(),
      domain: domain,
      ip: ip,
      port: port,
      source: source?.split(','),
      sourcePort: sourcePort,
      network: network,
      protocol: protocol?.split(','),
    );
  }

  SingBoxRule toSingBoxRule() {
    List<String> geosite = [];
    List<String> domain = [];
    List<String> geoip = [];
    List<String> ipCidr = [];
    List<int> port = [];
    List<String> portRange = [];
    List<String> sourceGeoip = [];
    List<String> sourceIpCidr = [];
    List<int> sourcePort = [];
    List<String> sourcePortRange = [];
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
          } catch (_) {
            // ignore
          }
        }
      }
    }
    if (source != null) {
      for (var sourceItem in source!.split(',')) {
        if (sourceItem.startsWith('geoip:')) {
          sourceGeoip.add(sourceItem.replaceFirst('geoip:', ''));
        } else {
          sourceIpCidr.add(sourceItem);
        }
      }
    }
    if (this.sourcePort != null) {
      for (var sourcePortItem in this.sourcePort!.split(',')) {
        if (sourcePortItem.contains('-')) {
          sourcePortRange.add(sourcePortItem.replaceAll('-', ':'));
        } else {
          try {
            sourcePort.add(int.parse(sourcePortItem));
          } catch (_) {}
        }
      }
    }
    return SingBoxRule(
      outbound: outboundTag.toString(),
      geosite: geosite.isEmpty ? null : geosite,
      domain: domain.isEmpty ? null : domain,
      geoip: geoip.isEmpty ? null : geoip,
      ipCidr: ipCidr.isEmpty ? null : ipCidr,
      port: port.isEmpty ? null : port,
      portRange: portRange.isEmpty ? null : portRange,
      sourceGeoip: sourceGeoip.isEmpty ? null : sourceGeoip,
      sourceIpCidr: sourceIpCidr.isEmpty ? null : sourceIpCidr,
      sourcePort: sourcePort.isEmpty ? null : sourcePort,
      sourcePortRange: sourcePortRange.isEmpty ? null : sourcePortRange,
      network: network,
      protocol: protocol?.split(','),
      processName: processName?.split(','),
    );
  }
}
