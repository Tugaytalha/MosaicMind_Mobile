import 'package:flutter/material.dart';
import 'package:mosaic_mind/authantication/UserLoginPage.dart';
import 'package:mosaic_mind/authantication/UserRegisterPage.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  // state to keep track of which screen to show
  bool showSignIn = true;

  // toggles showSignIn by reversing whatever it is now
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    // if true sign in, otherwise register
    // pass toggle function as a parameter
    if (showSignIn) {
      return UserLoginPage(toggleView: toggleView);
    } else {
      return UserRegisterPage(toggleView: toggleView);
    }
  }
}
