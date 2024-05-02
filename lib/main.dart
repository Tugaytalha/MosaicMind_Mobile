import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:mosaic_mind/selection.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter bindings are initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Selection(),
    );
  }
}



// class mainPage extends StatefulWidget {
//   const mainPage({Key? key}) : super(key: key);

//   @override
//   _mainPage createState() => _mainPage();
// }

// class _mainPage extends State<mainPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Color(0x403948), // Set your desired background color here
//     );
//   }
// }
