//
//  Generated code. Do not modify.
//  source: test.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Define the message for sending an image chunk with text
class ImageAndTextChunk extends $pb.GeneratedMessage {
  factory ImageAndTextChunk({
    $core.List<$core.int>? chunkData,
    $core.String? text,
  }) {
    final $result = create();
    if (chunkData != null) {
      $result.chunkData = chunkData;
    }
    if (text != null) {
      $result.text = text;
    }
    return $result;
  }
  ImageAndTextChunk._() : super();
  factory ImageAndTextChunk.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ImageAndTextChunk.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ImageAndTextChunk', package: const $pb.PackageName(_omitMessageNames ? '' : 'mosaic'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chunkData', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ImageAndTextChunk clone() => ImageAndTextChunk()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ImageAndTextChunk copyWith(void Function(ImageAndTextChunk) updates) => super.copyWith((message) => updates(message as ImageAndTextChunk)) as ImageAndTextChunk;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ImageAndTextChunk create() => ImageAndTextChunk._();
  ImageAndTextChunk createEmptyInstance() => create();
  static $pb.PbList<ImageAndTextChunk> createRepeated() => $pb.PbList<ImageAndTextChunk>();
  @$core.pragma('dart2js:noInline')
  static ImageAndTextChunk getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ImageAndTextChunk>(create);
  static ImageAndTextChunk? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chunkData => $_getN(0);
  @$pb.TagNumber(1)
  set chunkData($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChunkData() => $_has(0);
  @$pb.TagNumber(1)
  void clearChunkData() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => clearField(2);
}

/// Define the message for receiving the response text
class TextResponse extends $pb.GeneratedMessage {
  factory TextResponse({
    $core.String? outputText,
  }) {
    final $result = create();
    if (outputText != null) {
      $result.outputText = outputText;
    }
    return $result;
  }
  TextResponse._() : super();
  factory TextResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TextResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TextResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'mosaic'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'outputText')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TextResponse clone() => TextResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TextResponse copyWith(void Function(TextResponse) updates) => super.copyWith((message) => updates(message as TextResponse)) as TextResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TextResponse create() => TextResponse._();
  TextResponse createEmptyInstance() => create();
  static $pb.PbList<TextResponse> createRepeated() => $pb.PbList<TextResponse>();
  @$core.pragma('dart2js:noInline')
  static TextResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TextResponse>(create);
  static TextResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get outputText => $_getSZ(0);
  @$pb.TagNumber(1)
  set outputText($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOutputText() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutputText() => clearField(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
