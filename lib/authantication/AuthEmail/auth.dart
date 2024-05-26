import 'package:firebase_auth/firebase_auth.dart';
import 'package:mosaic_mind/authantication/Widgets/MyUser.dart';

class AuthService {
  // create auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static bool isSignUp = false;

  // create MyUser object based off firebase User object
  MyUser? _myUserFromUser(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // stream for if the users auth changes
  // mapping to get stream of MyUsers instead
  Stream<MyUser?> get user {
    return _auth.authStateChanges().map(_myUserFromUser);
  }

  // sign-in with email/password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _myUserFromUser(user);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-disabled':
          return 'Email corresponds to a disabled user';
        case 'wrong-password':
          return 'The password is invalid or the user does not have a password';
        case 'invalid-email':
          return 'Invalid email address';
        case 'user-not-found':
          return 'No user found for that email.';
        default:
          return 'An unknown error occurred';
      }
    } catch (e) {
      return 'An unknown error occurred';
    }
  }

  // register with email/password
  Future registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      return _myUserFromUser(user);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return 'Please enter a valid email';
        case 'email-already-in-use':
          return 'User already found with this email';
        case 'weak-password':
          return 'Please use a stronger password';
        case 'operation-not-allowed':
          return 'Email password authentication disabled';
        default:
          return 'An unknown error occurred';
      }
    } catch (e) {
      return 'An unknown error occurred';
    }
  }

  // sign-out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return 'An unknown error occurred';
    }
  }
}
