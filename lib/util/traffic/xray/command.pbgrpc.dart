//
//  Generated code. Do not modify.
//  source: command.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'command.pb.dart' as $0;

export 'command.pb.dart';

@$pb.GrpcServiceName('xray.app.stats.command.StatsService')
class StatsServiceClient extends $grpc.Client {
  static final _$getStats =
      $grpc.ClientMethod<$0.GetStatsRequest, $0.GetStatsResponse>(
          '/xray.app.stats.command.StatsService/GetStats',
          ($0.GetStatsRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.GetStatsResponse.fromBuffer(value));
  static final _$queryStats =
      $grpc.ClientMethod<$0.QueryStatsRequest, $0.QueryStatsResponse>(
          '/xray.app.stats.command.StatsService/QueryStats',
          ($0.QueryStatsRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.QueryStatsResponse.fromBuffer(value));
  static final _$getSysStats =
      $grpc.ClientMethod<$0.SysStatsRequest, $0.SysStatsResponse>(
          '/xray.app.stats.command.StatsService/GetSysStats',
          ($0.SysStatsRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.SysStatsResponse.fromBuffer(value));

  StatsServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.GetStatsResponse> getStats($0.GetStatsRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryStatsResponse> queryStats(
      $0.QueryStatsRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$queryStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.SysStatsResponse> getSysStats(
      $0.SysStatsRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getSysStats, request, options: options);
  }
}

@$pb.GrpcServiceName('xray.app.stats.command.StatsService')
abstract class StatsServiceBase extends $grpc.Service {
  $core.String get $name => 'xray.app.stats.command.StatsService';

  StatsServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetStatsRequest, $0.GetStatsResponse>(
        'GetStats',
        getStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetStatsRequest.fromBuffer(value),
        ($0.GetStatsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryStatsRequest, $0.QueryStatsResponse>(
        'QueryStats',
        queryStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.QueryStatsRequest.fromBuffer(value),
        ($0.QueryStatsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SysStatsRequest, $0.SysStatsResponse>(
        'GetSysStats',
        getSysStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SysStatsRequest.fromBuffer(value),
        ($0.SysStatsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetStatsResponse> getStats_Pre(
      $grpc.ServiceCall call, $async.Future<$0.GetStatsRequest> request) async {
    return getStats(call, await request);
  }

  $async.Future<$0.QueryStatsResponse> queryStats_Pre($grpc.ServiceCall call,
      $async.Future<$0.QueryStatsRequest> request) async {
    return queryStats(call, await request);
  }

  $async.Future<$0.SysStatsResponse> getSysStats_Pre(
      $grpc.ServiceCall call, $async.Future<$0.SysStatsRequest> request) async {
    return getSysStats(call, await request);
  }

  $async.Future<$0.GetStatsResponse> getStats(
      $grpc.ServiceCall call, $0.GetStatsRequest request);

  $async.Future<$0.QueryStatsResponse> queryStats(
      $grpc.ServiceCall call, $0.QueryStatsRequest request);

  $async.Future<$0.SysStatsResponse> getSysStats(
      $grpc.ServiceCall call, $0.SysStatsRequest request);
}
