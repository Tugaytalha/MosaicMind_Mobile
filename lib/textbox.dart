import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:mosaic_mind/database.dart';
import 'package:mosaic_mind/generated/proto/test.pbgrpc.dart';
import 'package:mosaic_mind/camera.dart';
import 'package:mosaic_mind/selection.dart';

class Textbox extends StatefulWidget {
  final File image;
  final String docID;
  final String caption;
  final String ipAdd;

  Textbox({
    Key? key,
    required this.image,
    required this.docID,
    required this.caption,
    required this.ipAdd,
  }) : super(key: key);

  @override
  _TextboxState createState() => _TextboxState();
}

class _TextboxState extends State<Textbox> {
  int _correctC = 0;
  int _failC = 0;
  int _updateC = 0;
  late DatabaseService databaseService;
  late TextEditingController _textController;
  bool _isLoading = false;
  bool _disableBackButton = false;

  @override
  void initState() {
    super.initState();
    databaseService = DatabaseService(widget.docID);
    _textController = TextEditingController(text: widget.caption);
    fetchDataAndUpdateCounts();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void fetchDataAndUpdateCounts() async {
    await databaseService.fetchData();
    setState(() {
      _correctC = databaseService.correctC;
      _failC = databaseService.failC;
      _updateC = databaseService.updateC;
    });
  }

  Future<String> trainModel() async {
    setState(() {
      _isLoading = true;
      _disableBackButton = true;
    });
    const int _port = 8080;
    final channel = ClientChannel(
      widget.ipAdd,
      port: _port,
      options: ChannelOptions(credentials: ChannelCredentials.insecure()),
    );

    final client = MosaicClient(channel);

    try {
      final imageFile = widget.image;
      final int chunkSize = 1024 * 64;
      final List<int> imageBytes = imageFile.readAsBytesSync();
      final StreamController<ImageAndTextChunk> chunkController =
          StreamController<ImageAndTextChunk>();

      Future<void> sendChunks() async {
        int offset = 0;
        final String text = _textController.text;

        while (offset < imageBytes.length) {
          final int end = offset + chunkSize;
          final Uint8List chunk = Uint8List.fromList(imageBytes.sublist(
              offset, end > imageBytes.length ? imageBytes.length : end));
          if (offset == 0) {
            chunkController
                .add(ImageAndTextChunk(chunkData: chunk, text: text));
          } else {
            chunkController.add(ImageAndTextChunk(chunkData: chunk));
          }
          offset = end;
          await Future.delayed(Duration(milliseconds: 10));
        }
        await chunkController.close();
      }

      sendChunks();

      final response = await client.trainModel(chunkController.stream);
      print(response.outputText);
      return response.outputText;
    } catch (error) {
      print('Error communicating with server: $error');
      return "Error: $error";
    } finally {
      await channel.shutdown();
      setState(() {
        _isLoading = false;
        _disableBackButton = false;
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Selection()),
        (Route<dynamic> route) => false,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CameraApp(documentID: widget.docID, ipAddress: widget.ipAdd)),
      );
    }
  }

  void updateDatabase() async {
    await databaseService.updateData(_correctC, _failC, _updateC);
  }

  Future<void> _showEditDialog() async {
    final TextEditingController editController =
        TextEditingController(text: _textController.text);
    final String? newText = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Text'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(hintText: 'Enter new text'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, editController.text),
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (newText != null && newText != _textController.text) {
      setState(() {
        _textController.text = newText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_disableBackButton,
      child: Scaffold(
        backgroundColor: Color(0xFF403948),
        body: Stack(
          children: [
            Center(
              child: Container(
                color: Color(0xFF403948),
                padding: EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.file(
                            widget.image,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.4,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextFormField(
                          controller: _textController,
                          onTap: _showEditDialog,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02),
                          ElevatedButton(
                            onPressed: () {
                              _correctC++;
                              updateDatabase();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Selection()),
                                (Route<dynamic> route) => false,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CameraApp(
                                        documentID: widget.docID,
                                        ipAddress: widget.ipAdd)),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFFC5524A)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            child: const Text('Correct'),
                          ),
                          Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              if (widget.caption
                                      .compareTo(_textController.text) !=
                                  0) {
                                _failC++;
                                updateDatabase();
                                trainModel();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFFC5524A)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            child: const Text('Fail'),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      const Text(
                        'Mosaic Mind V1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
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
