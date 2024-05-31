//
//  Generated code. Do not modify.
//  source: test.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'test.pb.dart' as $0;

export 'test.pb.dart';

@$pb.GrpcServiceName('mosaic.Mosaic')
class MosaicClient extends $grpc.Client {
  static final _$processImageAndText = $grpc.ClientMethod<$0.ImageAndTextChunk, $0.TextResponse>(
      '/mosaic.Mosaic/ProcessImageAndText',
      ($0.ImageAndTextChunk value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.TextResponse.fromBuffer(value));
  static final _$trainModel = $grpc.ClientMethod<$0.ImageAndTextChunk, $0.TextResponse>(
      '/mosaic.Mosaic/TrainModel',
      ($0.ImageAndTextChunk value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.TextResponse.fromBuffer(value));

  MosaicClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.TextResponse> processImageAndText($async.Stream<$0.ImageAndTextChunk> request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$processImageAndText, request, options: options).single;
  }

  $grpc.ResponseFuture<$0.TextResponse> trainModel($async.Stream<$0.ImageAndTextChunk> request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$trainModel, request, options: options).single;
  }
}

@$pb.GrpcServiceName('mosaic.Mosaic')
abstract class MosaicServiceBase extends $grpc.Service {
  $core.String get $name => 'mosaic.Mosaic';

  MosaicServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ImageAndTextChunk, $0.TextResponse>(
        'ProcessImageAndText',
        processImageAndText,
        true,
        false,
        ($core.List<$core.int> value) => $0.ImageAndTextChunk.fromBuffer(value),
        ($0.TextResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ImageAndTextChunk, $0.TextResponse>(
        'TrainModel',
        trainModel,
        true,
        false,
        ($core.List<$core.int> value) => $0.ImageAndTextChunk.fromBuffer(value),
        ($0.TextResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.TextResponse> processImageAndText($grpc.ServiceCall call, $async.Stream<$0.ImageAndTextChunk> request);
  $async.Future<$0.TextResponse> trainModel($grpc.ServiceCall call, $async.Stream<$0.ImageAndTextChunk> request);
}
