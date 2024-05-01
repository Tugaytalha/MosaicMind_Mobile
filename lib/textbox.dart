import 'package:flutter/material.dart';
import 'package:mosaic_mind/database.dart';

class Textbox extends StatefulWidget {
  final String imagePath;
  final String docID;

  Textbox({Key? key, required this.imagePath, required this.docID})
      : super(key: key);

  @override
  _TextboxState createState() => _TextboxState();
}

class _TextboxState extends State<Textbox> {
  int _correctC = 0;
  int _failC = 0;
  int _updateC = 0;
  late DatabaseService databaseService;

  @override
  void initState() {
    super.initState();
    fetchDataAndUpdateCounts();
  }

  void fetchDataAndUpdateCounts() async {
    databaseService = DatabaseService(widget.docID);
    await databaseService.fetchData();

    setState(() {
      _correctC = databaseService.correctC;
      _failC = databaseService.failC;
      _updateC = databaseService.updateC;
    });
  }

  void updateDatabase() async {
    await databaseService.updateData(_correctC, _failC, _updateC);
  }

  String _text = 'Enter text here';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF403948), // Arka plan rengi #403948
      body: Center(
        child: Container(
          color: Color(0xFF403948), // Container rengi değiştirilmedi
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(widget.imagePath),
                SizedBox(height: 20.0),
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
                      child: Text('I like the caption'),
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
                      child: Text('Change the caption and send'),
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
