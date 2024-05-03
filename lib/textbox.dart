import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mosaic_mind/camera.dart';
import 'package:mosaic_mind/database.dart';
import 'package:mosaic_mind/selection.dart';

class Textbox extends StatefulWidget {
  final String imagePath;
  final String docID;
  final String ipAdd;

  Textbox({
    Key? key,
    required this.imagePath,
    required this.docID,
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
  String _text = 'Enter text here';
  bool _textChanged = false;

  @override
  void initState() {
    super.initState();
    databaseService = DatabaseService(widget.docID);
    fetchDataAndUpdateCounts();
  }

  void fetchDataAndUpdateCounts() async {
    await databaseService.fetchData();
    setState(() {
      _correctC = databaseService.correctC;
      _failC = databaseService.failC;
      _updateC = databaseService.updateC;
    });
  }

  void updateDatabase() async {
    await databaseService.updateData(_correctC, _failC, _failC);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Selection(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF403948),
      body: Center(
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
                      File(widget.imagePath),
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Builder(// Wrap TextFormField in Builder
                      builder: (context) {
                    return TextFormField(
                      initialValue: _text,
                      onTap: () {
                        _showEditDialog(context);
                      },
                      maxLines: null,
                      readOnly: !_textChanged,
                      decoration: InputDecoration(
                        hintText: 'Enter text here',
                        hintStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Color(0xFF635F5E),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 10.0),
                      ),
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {
                        setState(() {
                          _textChanged = true;
                        });
                      },
                    );
                  }),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: !_textChanged
                          ? () {
                              _correctC++;
                              updateDatabase();
                            }
                          : null,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFFC5524A)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: Text('Correct'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _textChanged
                          ? () {
                              _failC++;
                              updateDatabase();
                            }
                          : null,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFFC5524A)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: Text('Update Model'),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Text(
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
    );
  }

  Future<void> _showEditDialog(BuildContext context) async {
    final TextEditingController _controller =
        TextEditingController(text: _text);
    String? newText = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Text'),
          content: TextFormField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Enter new text'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, _controller.text);
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
    if (newText != null) {
      setState(() {
        _text = newText;
        _textChanged = true;
      });
    }
  }
}
