// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerConfig _$ServerConfigFromJson(Map<String, dynamic> json) => ServerConfig(
      selectedServerGroupId: json['selectedServerGroupId'] as int,
      selectedServerId: json['selectedServerId'] as int,
      updatedSubscribeTime: json['updatedSubscribeTime'] as int,
    );

Map<String, dynamic> _$ServerConfigToJson(ServerConfig instance) =>
    <String, dynamic>{
      'selectedServerGroupId': instance.selectedServerGroupId,
      'selectedServerId': instance.selectedServerId,
      'updatedSubscribeTime': instance.updatedSubscribeTime,
    };
