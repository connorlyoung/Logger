import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current logged in user
  User? get currentUser => _auth.currentUser;

  // register with email + pass
  Future<String?> registerWithEmailPass(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user?.uid;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.message}");
      return null; // Explicitly return null on failure
    } catch (e) {
      print("Unexpected error: $e");
      return null;
    }
  }

  // sign in with email + pass
  Future<String?> signInWithEmailPass(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user?.uid;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.message}");
      return null; // Explicitly return null on failure
    } catch (e) {
      print("Unexpected error: $e");
      return null;
    }
  }

  // google auth

  // sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  // passowrd reset function
  // Maybe improve on future to send a code that verifies then reset's password through app
  Future<String?> resetPassword(String email) async{
    try{
      await _auth.sendPasswordResetEmail(email: email);
      return "Password reset email sent! Check your inbox.";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}