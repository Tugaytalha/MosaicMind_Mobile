// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mosaic_mind/generated/proto/test.pbgrpc.dart';
import 'package:mosaic_mind/textbox.dart';

class CameraApp extends StatefulWidget {
  final String documentID;
  final String ipAddress;

  CameraApp({Key? key, required this.documentID, required this.ipAddress})
      : super(key: key);

  File? image;

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  bool _isLoading = false;
  bool _disableBackButton = false;

  Future<String> sendData(String ip, int port, File imageFile) async {
    var completer = Completer<String>();
    final socket = await Socket.connect(ip, port);
    final fileStream = imageFile.openRead();

    await fileStream.forEach(socket.add);

    socket.add(utf8.encode('EOF'));
    await socket.flush();

    socket.listen((List<int> data) {
      var response = utf8.decode(data);
      print('Received response from receiver: $response');
      if (!completer.isCompleted) {
        completer.complete(response);
      }
    }, onDone: () {
      socket.close();
      if (!completer.isCompleted) {
        completer.completeError('Connection closed without a response');
      }
    }, onError: (error) {
      print('Error: $error');
      socket.close();
      if (!completer.isCompleted) {
        completer.completeError('Error receiving data: $error');
      }
    }, cancelOnError: true);

    return completer.future;
  }

  Future<String> processImageAndText() async {
    setState(() {
      _disableBackButton = true;
    });
    const int _port = 8080;
    final channel = ClientChannel(
      widget.ipAddress,
      port: _port,
      options: ChannelOptions(credentials: ChannelCredentials.insecure()),
    );

    final client = MosaicClient(channel);
    final imageFile = widget.image;
    final int chunkSize = 1024 * 64;
    final List<int> imageBytes = imageFile!.readAsBytesSync();
    final StreamController<ImageAndTextChunk> chunkController =
        StreamController<ImageAndTextChunk>();

    Future<void> sendChunks() async {
      int offset = 0;
      final String text = "";

      while (offset < imageBytes.length) {
        final int end = offset + chunkSize;
        final Uint8List chunk = Uint8List.fromList(imageBytes.sublist(
            offset, end > imageBytes.length ? imageBytes.length : end));
        if (offset == 0) {
          chunkController.add(ImageAndTextChunk(chunkData: chunk, text: text));
        } else {
          chunkController.add(ImageAndTextChunk(chunkData: chunk));
        }
        offset = end;
        await Future.delayed(Duration(milliseconds: 10));
      }
      await chunkController.close();
    }

    sendChunks();

    final response = await client.processImageAndText(chunkController.stream);
    print(response.outputText);
    setState(() {
      _disableBackButton = false;
    });
    return response.outputText;
  }

  Future<void> pickImageAndSave(
      BuildContext context, ImageSource source) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) {
        return;
      }

      final imageTemporary = File(image.path);
      this.widget.image = imageTemporary;
      String caption = await processImageAndText();
      print("caption: $caption");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Textbox(
            image: this.widget.image!,
            docID: widget.documentID,
            caption: caption,
            ipAdd: widget.ipAddress,
          ),
        ),
      );
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_disableBackButton,
      child: Scaffold(
        backgroundColor: const Color(0xFF403948),
        appBar: AppBar(
          title: const Text('Image Upload'),
          centerTitle: true,
          backgroundColor: Colors.grey[200],
        ),
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () => !_isLoading
                            ? pickImageAndSave(context, ImageSource.camera)
                            : null,
                        child: Column(
                          children: [
                            Ink(
                              decoration: const ShapeDecoration(
                                color: Colors.white,
                                shape: CircleBorder(),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.camera_alt_rounded,
                                    size: 96, color: const Color(0xFF403948)),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Pick Image from Camera',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => !_isLoading
                            ? pickImageAndSave(context, ImageSource.gallery)
                            : null,
                        child: Column(
                          children: [
                            Ink(
                              decoration: const ShapeDecoration(
                                color: Colors.white,
                                shape: CircleBorder(),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.photo_library,
                                    size: 96, color: const Color(0xFF403948)),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Pick Image from Gallery',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // if (widget.image != null) Image.file(widget.image!),
                ],
              ),
            ),
            if (_isLoading)
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
