import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mosaic_mind/database.dart';

class Textbox extends StatefulWidget {
  final String imagePath;
  final String docID;
  final String ipAdd;

  Textbox(
      {Key? key,
      required this.imagePath,
      required this.docID,
      required this.ipAdd})
      : super(key: key);

  @override
  _TextboxState createState() => _TextboxState();
}

class _TextboxState extends State<Textbox> {
  int _correctC = 0;
  int _failC = 0;
  int _updateC = 0;
  late DatabaseService databaseService;
  String _text = 'Enter text here';

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
    await databaseService.updateData(_correctC, _failC, _correctC + _failC);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF403948),
      body: Center(
        child: Container(
          color: Color(0xFF403948),
          padding: EdgeInsets.all(16.0), // Add padding around the container
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0), // Add padding around the image
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.white, width: 2.0), // Add border
                    borderRadius:
                        BorderRadius.circular(10.0), // Add border radius
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(10.0), // Add border radius
                    child: Image.file(
                      File(widget
                          .imagePath), // Display the image from the file path
                      fit: BoxFit
                          .cover, // Cover the available space while maintaining aspect ratio
                      width: MediaQuery.of(context).size.width *
                          0.9, // Adjust width
                      height: MediaQuery.of(context).size.height *
                          0.4, // Adjust height
                    ),
                  ),
                ),
                SizedBox(
                    height:
                        20.0), // Add space between the image and other widgets
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextFormField(
                    initialValue: _text,
                    onTap: () {
                      _showEditDialog(context);
                    },
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Enter text here',
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    ElevatedButton(
                      onPressed: () {
                        _correctC++;
                        updateDatabase();
                      },
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
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        _failC++;
                        updateDatabase();
                      },
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
                      child: Text('Fail'),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
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
      });
    }
  }
}
