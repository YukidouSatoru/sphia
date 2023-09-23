//
//  Generated code. Do not modify.
//  source: command.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class GetStatsRequest extends $pb.GeneratedMessage {
  factory GetStatsRequest() => create();

  GetStatsRequest._() : super();

  factory GetStatsRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory GetStatsRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStatsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xray.app.stats.command'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOB(2, _omitFieldNames ? '' : 'reset')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GetStatsRequest clone() => GetStatsRequest()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GetStatsRequest copyWith(void Function(GetStatsRequest) updates) =>
      super.copyWith((message) => updates(message as GetStatsRequest))
          as GetStatsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetStatsRequest create() => GetStatsRequest._();

  GetStatsRequest createEmptyInstance() => create();

  static $pb.PbList<GetStatsRequest> createRepeated() =>
      $pb.PbList<GetStatsRequest>();

  @$core.pragma('dart2js:noInline')
  static GetStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetStatsRequest>(create);
  static GetStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);

  @$pb.TagNumber(1)
  set name($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);

  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get reset => $_getBF(1);

  @$pb.TagNumber(2)
  set reset($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasReset() => $_has(1);

  @$pb.TagNumber(2)
  void clearReset() => clearField(2);
}

class Stat extends $pb.GeneratedMessage {
  factory Stat() => create();

  Stat._() : super();

  factory Stat.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory Stat.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Stat',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xray.app.stats.command'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aInt64(2, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Stat clone() => Stat()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Stat copyWith(void Function(Stat) updates) =>
      super.copyWith((message) => updates(message as Stat)) as Stat;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Stat create() => Stat._();

  Stat createEmptyInstance() => create();

  static $pb.PbList<Stat> createRepeated() => $pb.PbList<Stat>();

  @$core.pragma('dart2js:noInline')
  static Stat getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Stat>(create);
  static Stat? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);

  @$pb.TagNumber(1)
  set name($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);

  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get value => $_getI64(1);

  @$pb.TagNumber(2)
  set value($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);

  @$pb.TagNumber(2)
  void clearValue() => clearField(2);
}

class GetStatsResponse extends $pb.GeneratedMessage {
  factory GetStatsResponse() => create();

  GetStatsResponse._() : super();

  factory GetStatsResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory GetStatsResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStatsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xray.app.stats.command'),
      createEmptyInstance: create)
    ..aOM<Stat>(1, _omitFieldNames ? '' : 'stat', subBuilder: Stat.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GetStatsResponse clone() => GetStatsResponse()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GetStatsResponse copyWith(void Function(GetStatsResponse) updates) =>
      super.copyWith((message) => updates(message as GetStatsResponse))
          as GetStatsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetStatsResponse create() => GetStatsResponse._();

  GetStatsResponse createEmptyInstance() => create();

  static $pb.PbList<GetStatsResponse> createRepeated() =>
      $pb.PbList<GetStatsResponse>();

  @$core.pragma('dart2js:noInline')
  static GetStatsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetStatsResponse>(create);
  static GetStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Stat get stat => $_getN(0);

  @$pb.TagNumber(1)
  set stat(Stat v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasStat() => $_has(0);

  @$pb.TagNumber(1)
  void clearStat() => clearField(1);

  @$pb.TagNumber(1)
  Stat ensureStat() => $_ensure(0);
}

class QueryStatsRequest extends $pb.GeneratedMessage {
  factory QueryStatsRequest() => create();

  QueryStatsRequest._() : super();

  factory QueryStatsRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory QueryStatsRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QueryStatsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xray.app.stats.command'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'pattern')
    ..aOB(2, _omitFieldNames ? '' : 'reset')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryStatsRequest clone() => QueryStatsRequest()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryStatsRequest copyWith(void Function(QueryStatsRequest) updates) =>
      super.copyWith((message) => updates(message as QueryStatsRequest))
          as QueryStatsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QueryStatsRequest create() => QueryStatsRequest._();

  QueryStatsRequest createEmptyInstance() => create();

  static $pb.PbList<QueryStatsRequest> createRepeated() =>
      $pb.PbList<QueryStatsRequest>();

  @$core.pragma('dart2js:noInline')
  static QueryStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryStatsRequest>(create);
  static QueryStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pattern => $_getSZ(0);

  @$pb.TagNumber(1)
  set pattern($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPattern() => $_has(0);

  @$pb.TagNumber(1)
  void clearPattern() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get reset => $_getBF(1);

  @$pb.TagNumber(2)
  set reset($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasReset() => $_has(1);

  @$pb.TagNumber(2)
  void clearReset() => clearField(2);
}

class QueryStatsResponse extends $pb.GeneratedMessage {
  factory QueryStatsResponse() => create();

  QueryStatsResponse._() : super();

  factory QueryStatsResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory QueryStatsResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QueryStatsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xray.app.stats.command'),
      createEmptyInstance: create)
    ..pc<Stat>(1, _omitFieldNames ? '' : 'stat', $pb.PbFieldType.PM,
        subBuilder: Stat.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryStatsResponse clone() => QueryStatsResponse()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryStatsResponse copyWith(void Function(QueryStatsResponse) updates) =>
      super.copyWith((message) => updates(message as QueryStatsResponse))
          as QueryStatsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QueryStatsResponse create() => QueryStatsResponse._();

  QueryStatsResponse createEmptyInstance() => create();

  static $pb.PbList<QueryStatsResponse> createRepeated() =>
      $pb.PbList<QueryStatsResponse>();

  @$core.pragma('dart2js:noInline')
  static QueryStatsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryStatsResponse>(create);
  static QueryStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Stat> get stat => $_getList(0);
}

class SysStatsRequest extends $pb.GeneratedMessage {
  factory SysStatsRequest() => create();

  SysStatsRequest._() : super();

  factory SysStatsRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory SysStatsRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SysStatsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xray.app.stats.command'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SysStatsRequest clone() => SysStatsRequest()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SysStatsRequest copyWith(void Function(SysStatsRequest) updates) =>
      super.copyWith((message) => updates(message as SysStatsRequest))
          as SysStatsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SysStatsRequest create() => SysStatsRequest._();

  SysStatsRequest createEmptyInstance() => create();

  static $pb.PbList<SysStatsRequest> createRepeated() =>
      $pb.PbList<SysStatsRequest>();

  @$core.pragma('dart2js:noInline')
  static SysStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SysStatsRequest>(create);
  static SysStatsRequest? _defaultInstance;
}

class SysStatsResponse extends $pb.GeneratedMessage {
  factory SysStatsResponse() => create();

  SysStatsResponse._() : super();

  factory SysStatsResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory SysStatsResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SysStatsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xray.app.stats.command'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1, _omitFieldNames ? '' : 'NumGoroutine', $pb.PbFieldType.OU3,
        protoName: 'NumGoroutine')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'NumGC', $pb.PbFieldType.OU3,
        protoName: 'NumGC')
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'Alloc', $pb.PbFieldType.OU6,
        protoName: 'Alloc', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'TotalAlloc', $pb.PbFieldType.OU6,
        protoName: 'TotalAlloc', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'Sys', $pb.PbFieldType.OU6,
        protoName: 'Sys', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(6, _omitFieldNames ? '' : 'Mallocs', $pb.PbFieldType.OU6,
        protoName: 'Mallocs', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(7, _omitFieldNames ? '' : 'Frees', $pb.PbFieldType.OU6,
        protoName: 'Frees', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        8, _omitFieldNames ? '' : 'LiveObjects', $pb.PbFieldType.OU6,
        protoName: 'LiveObjects', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        9, _omitFieldNames ? '' : 'PauseTotalNs', $pb.PbFieldType.OU6,
        protoName: 'PauseTotalNs', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(10, _omitFieldNames ? '' : 'Uptime', $pb.PbFieldType.OU3,
        protoName: 'Uptime')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SysStatsResponse clone() => SysStatsResponse()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SysStatsResponse copyWith(void Function(SysStatsResponse) updates) =>
      super.copyWith((message) => updates(message as SysStatsResponse))
          as SysStatsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SysStatsResponse create() => SysStatsResponse._();

  SysStatsResponse createEmptyInstance() => create();

  static $pb.PbList<SysStatsResponse> createRepeated() =>
      $pb.PbList<SysStatsResponse>();

  @$core.pragma('dart2js:noInline')
  static SysStatsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SysStatsResponse>(create);
  static SysStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get numGoroutine => $_getIZ(0);

  @$pb.TagNumber(1)
  set numGoroutine($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasNumGoroutine() => $_has(0);

  @$pb.TagNumber(1)
  void clearNumGoroutine() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get numGC => $_getIZ(1);

  @$pb.TagNumber(2)
  set numGC($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasNumGC() => $_has(1);

  @$pb.TagNumber(2)
  void clearNumGC() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get alloc => $_getI64(2);

  @$pb.TagNumber(3)
  set alloc($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasAlloc() => $_has(2);

  @$pb.TagNumber(3)
  void clearAlloc() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get totalAlloc => $_getI64(3);

  @$pb.TagNumber(4)
  set totalAlloc($fixnum.Int64 v) {
    $_setInt64(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasTotalAlloc() => $_has(3);

  @$pb.TagNumber(4)
  void clearTotalAlloc() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get sys => $_getI64(4);

  @$pb.TagNumber(5)
  set sys($fixnum.Int64 v) {
    $_setInt64(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasSys() => $_has(4);

  @$pb.TagNumber(5)
  void clearSys() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get mallocs => $_getI64(5);

  @$pb.TagNumber(6)
  set mallocs($fixnum.Int64 v) {
    $_setInt64(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasMallocs() => $_has(5);

  @$pb.TagNumber(6)
  void clearMallocs() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get frees => $_getI64(6);

  @$pb.TagNumber(7)
  set frees($fixnum.Int64 v) {
    $_setInt64(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasFrees() => $_has(6);

  @$pb.TagNumber(7)
  void clearFrees() => clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get liveObjects => $_getI64(7);

  @$pb.TagNumber(8)
  set liveObjects($fixnum.Int64 v) {
    $_setInt64(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasLiveObjects() => $_has(7);

  @$pb.TagNumber(8)
  void clearLiveObjects() => clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get pauseTotalNs => $_getI64(8);

  @$pb.TagNumber(9)
  set pauseTotalNs($fixnum.Int64 v) {
    $_setInt64(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasPauseTotalNs() => $_has(8);

  @$pb.TagNumber(9)
  void clearPauseTotalNs() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get uptime => $_getIZ(9);

  @$pb.TagNumber(10)
  set uptime($core.int v) {
    $_setUnsignedInt32(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasUptime() => $_has(9);

  @$pb.TagNumber(10)
  void clearUptime() => clearField(10);
}

class Config extends $pb.GeneratedMessage {
  factory Config() => create();

  Config._() : super();

  factory Config.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory Config.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Config',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xray.app.stats.command'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Config clone() => Config()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Config copyWith(void Function(Config) updates) =>
      super.copyWith((message) => updates(message as Config)) as Config;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Config create() => Config._();

  Config createEmptyInstance() => create();

  static $pb.PbList<Config> createRepeated() => $pb.PbList<Config>();

  @$core.pragma('dart2js:noInline')
  static Config getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Config>(create);
  static Config? _defaultInstance;
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
