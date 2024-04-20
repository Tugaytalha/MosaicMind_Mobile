import 'package:flutter/material.dart';

class Textbox extends StatefulWidget {
  const Textbox({Key? key}) : super(key: key);

  @override
  _TextboxState createState() => _TextboxState();
}

class _TextboxState extends State<Textbox> {
  String _text = 'Enter text here';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF403948), // Arka plan rengi #403948
        body: Center(
          child: Container(
            color: Color(0xFF403948), // Container rengi değiştirilmedi
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02, // Resmin ve TextFormFied'ın arasındaki boşluğu belirler
                  ),
                  Image.asset('assets/images.jpeg'),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05, // Resimden sonraki boşluğu belirler
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7, // TextFormField'ın genişliğini belirler
                    child: TextFormField(
                      initialValue: _text,
                      onTap: () {
                        _showEditDialog(context);
                      },
                      maxLines: null, // Alt satıra geçmesini sağlar
                      decoration: InputDecoration(
                        hintText: 'Enter text here',
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05, // Butonlar ile text arasındaki boşluğu belirler
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02), // İlk buton ile sol kenar arasındaki boşluğu belirler
                      ElevatedButton(
                        onPressed: () {
                          // Button 1 işlevi buraya eklenecek
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFC5524A)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: Text('I like the caption'),
                      ),
                      Spacer(), // Aralarındaki boşluğu belirler
                      ElevatedButton(
                        onPressed: () {
                          // Button 2 işlevi buraya eklenecek
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFC5524A)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: Text('Change the caption and send'),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02), // İkinci buton ile sağ kenar arasındaki boşluğu belirler
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05, // Metin ile alt kenar arasındaki boşluğu belirler
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
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context) async {
    final TextEditingController _controller = TextEditingController(text: _text);
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
