import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:mosaic_mind/authantication/AuthEmail/auth.dart';
import 'package:mosaic_mind/authantication/AuthEmail/authenticate.dart';
import 'package:mosaic_mind/authantication/Widgets/MyUser.dart';
import 'package:mosaic_mind/selection.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter bindings are initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (context) {
            final user = Provider.of<MyUser?>(context);
            if (user == null) {
              return const Authenticate();
            } else {
              return const Selection();
            }
          },
        ),
      ),
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
