import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

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
}