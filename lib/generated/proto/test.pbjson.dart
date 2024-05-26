//
//  Generated code. Do not modify.
//  source: test.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use imageAndTextChunkDescriptor instead')
const ImageAndTextChunk$json = {
  '1': 'ImageAndTextChunk',
  '2': [
    {'1': 'chunk_data', '3': 1, '4': 1, '5': 12, '10': 'chunkData'},
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
  ],
};

/// Descriptor for `ImageAndTextChunk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageAndTextChunkDescriptor = $convert.base64Decode(
    'ChFJbWFnZUFuZFRleHRDaHVuaxIdCgpjaHVua19kYXRhGAEgASgMUgljaHVua0RhdGESEgoEdG'
    'V4dBgCIAEoCVIEdGV4dA==');

@$core.Deprecated('Use textResponseDescriptor instead')
const TextResponse$json = {
  '1': 'TextResponse',
  '2': [
    {'1': 'output_text', '3': 1, '4': 1, '5': 9, '10': 'outputText'},
  ],
};

/// Descriptor for `TextResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textResponseDescriptor = $convert.base64Decode(
    'CgxUZXh0UmVzcG9uc2USHwoLb3V0cHV0X3RleHQYASABKAlSCm91dHB1dFRleHQ=');

