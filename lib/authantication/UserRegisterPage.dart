import 'package:flutter/material.dart';
import 'package:mosaic_mind/authantication/AuthEmail/auth.dart';
import 'package:mosaic_mind/authantication/Widgets/UiButton.dart';
import 'package:mosaic_mind/authantication/Widgets/UiTextField.dart';
import 'package:mosaic_mind/authantication/Widgets/loading.dart';

class UserRegisterPage extends StatefulWidget {
  // set toggle function
  final Function toggleView;
  const UserRegisterPage({super.key, required this.toggleView});

  @override
  State<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  // import the auth service
  final AuthService _auth = AuthService();

  // key to allow us to validate form
  final _formKey = GlobalKey<FormState>();

  // whether we are now loading a result
  bool loading = false;

  // track the entry fields
  String email = '';
  String password = '';
  String username = '';
  String error = '';

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final mailController = TextEditingController();

  // sign user in method
  void register() async {
    AuthService.isSignUp = true;
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);

      dynamic result =
          await _auth.registerWithEmailAndPassword(email, password);

      if (result is String) {
        setState(() => {
              error = result,
              loading = false,
            });
      } else if (result == null) {
        setState(() => {
              error = 'Authentication error',
              loading = false,
            });
      }
    }
  }

  void returnLogIn() {
    widget.toggleView();
  }

  @override
  Widget build(BuildContext context) {
    // if loading display widget, otherwise display Scaffold
    return loading
        ? const Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false, // set it to false

            backgroundColor: Color(0xFF403948),
            body: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 28.0),
              // sign in button
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),

                    // email textfield
                    UiTextField(
                      controller: mailController,
                      hintText: 'Email',
                      obscureText: false,
                      validator: (val) => val!.isEmpty
                          ? 'Email is required'
                          : null, // use to check if valid input
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),

                    const SizedBox(height: 10),

                    // password textfield
                    UiTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),

                    const SizedBox(height: 25),

                    // register button
                    UiButton(
                      buttonName: "Register",
                      onTap: register,
                    ),

                    const SizedBox(height: 18),

                    UiButton(
                      buttonName: "Sign in",
                      onTap: returnLogIn,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
