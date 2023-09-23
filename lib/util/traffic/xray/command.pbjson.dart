//
//  Generated code. Do not modify.
//  source: command.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use getStatsRequestDescriptor instead')
const GetStatsRequest$json = {
  '1': 'GetStatsRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'reset', '3': 2, '4': 1, '5': 8, '10': 'reset'},
  ],
};

/// Descriptor for `GetStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStatsRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRTdGF0c1JlcXVlc3QSEgoEbmFtZRgBIAEoCVIEbmFtZRIUCgVyZXNldBgCIAEoCFIFcm'
    'VzZXQ=');

@$core.Deprecated('Use statDescriptor instead')
const Stat$json = {
  '1': 'Stat',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'value', '3': 2, '4': 1, '5': 3, '10': 'value'},
  ],
};

/// Descriptor for `Stat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statDescriptor = $convert.base64Decode(
    'CgRTdGF0EhIKBG5hbWUYASABKAlSBG5hbWUSFAoFdmFsdWUYAiABKANSBXZhbHVl');

@$core.Deprecated('Use getStatsResponseDescriptor instead')
const GetStatsResponse$json = {
  '1': 'GetStatsResponse',
  '2': [
    {
      '1': 'stat',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.xray.app.stats.command.Stat',
      '10': 'stat'
    },
  ],
};

/// Descriptor for `GetStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStatsResponseDescriptor = $convert.base64Decode(
    'ChBHZXRTdGF0c1Jlc3BvbnNlEjAKBHN0YXQYASABKAsyHC54cmF5LmFwcC5zdGF0cy5jb21tYW'
    '5kLlN0YXRSBHN0YXQ=');

@$core.Deprecated('Use queryStatsRequestDescriptor instead')
const QueryStatsRequest$json = {
  '1': 'QueryStatsRequest',
  '2': [
    {'1': 'pattern', '3': 1, '4': 1, '5': 9, '10': 'pattern'},
    {'1': 'reset', '3': 2, '4': 1, '5': 8, '10': 'reset'},
  ],
};

/// Descriptor for `QueryStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryStatsRequestDescriptor = $convert.base64Decode(
    'ChFRdWVyeVN0YXRzUmVxdWVzdBIYCgdwYXR0ZXJuGAEgASgJUgdwYXR0ZXJuEhQKBXJlc2V0GA'
    'IgASgIUgVyZXNldA==');

@$core.Deprecated('Use queryStatsResponseDescriptor instead')
const QueryStatsResponse$json = {
  '1': 'QueryStatsResponse',
  '2': [
    {
      '1': 'stat',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.xray.app.stats.command.Stat',
      '10': 'stat'
    },
  ],
};

/// Descriptor for `QueryStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryStatsResponseDescriptor = $convert.base64Decode(
    'ChJRdWVyeVN0YXRzUmVzcG9uc2USMAoEc3RhdBgBIAMoCzIcLnhyYXkuYXBwLnN0YXRzLmNvbW'
    '1hbmQuU3RhdFIEc3RhdA==');

@$core.Deprecated('Use sysStatsRequestDescriptor instead')
const SysStatsRequest$json = {
  '1': 'SysStatsRequest',
};

/// Descriptor for `SysStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sysStatsRequestDescriptor =
    $convert.base64Decode('Cg9TeXNTdGF0c1JlcXVlc3Q=');

@$core.Deprecated('Use sysStatsResponseDescriptor instead')
const SysStatsResponse$json = {
  '1': 'SysStatsResponse',
  '2': [
    {'1': 'NumGoroutine', '3': 1, '4': 1, '5': 13, '10': 'NumGoroutine'},
    {'1': 'NumGC', '3': 2, '4': 1, '5': 13, '10': 'NumGC'},
    {'1': 'Alloc', '3': 3, '4': 1, '5': 4, '10': 'Alloc'},
    {'1': 'TotalAlloc', '3': 4, '4': 1, '5': 4, '10': 'TotalAlloc'},
    {'1': 'Sys', '3': 5, '4': 1, '5': 4, '10': 'Sys'},
    {'1': 'Mallocs', '3': 6, '4': 1, '5': 4, '10': 'Mallocs'},
    {'1': 'Frees', '3': 7, '4': 1, '5': 4, '10': 'Frees'},
    {'1': 'LiveObjects', '3': 8, '4': 1, '5': 4, '10': 'LiveObjects'},
    {'1': 'PauseTotalNs', '3': 9, '4': 1, '5': 4, '10': 'PauseTotalNs'},
    {'1': 'Uptime', '3': 10, '4': 1, '5': 13, '10': 'Uptime'},
  ],
};

/// Descriptor for `SysStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sysStatsResponseDescriptor = $convert.base64Decode(
    'ChBTeXNTdGF0c1Jlc3BvbnNlEiIKDE51bUdvcm91dGluZRgBIAEoDVIMTnVtR29yb3V0aW5lEh'
    'QKBU51bUdDGAIgASgNUgVOdW1HQxIUCgVBbGxvYxgDIAEoBFIFQWxsb2MSHgoKVG90YWxBbGxv'
    'YxgEIAEoBFIKVG90YWxBbGxvYxIQCgNTeXMYBSABKARSA1N5cxIYCgdNYWxsb2NzGAYgASgEUg'
    'dNYWxsb2NzEhQKBUZyZWVzGAcgASgEUgVGcmVlcxIgCgtMaXZlT2JqZWN0cxgIIAEoBFILTGl2'
    'ZU9iamVjdHMSIgoMUGF1c2VUb3RhbE5zGAkgASgEUgxQYXVzZVRvdGFsTnMSFgoGVXB0aW1lGA'
    'ogASgNUgZVcHRpbWU=');

@$core.Deprecated('Use configDescriptor instead')
const Config$json = {
  '1': 'Config',
};

/// Descriptor for `Config`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List configDescriptor =
    $convert.base64Decode('CgZDb25maWc=');
