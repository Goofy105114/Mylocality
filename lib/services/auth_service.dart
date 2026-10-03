import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
    } on FirebaseAuthException catch (e) {
      throw _friendly(e);
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      // Save the display name so the greeting can use it immediately.
      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();
    } on FirebaseAuthException catch (e) {
      throw _friendly(e);
    }
  }

  Future<void> signOut() => _auth.signOut();

  String _friendly(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'weak-password':
        return 'Password is too weak (min 6 characters).';
      case 'network-request-failed':
        return 'No internet connection.';
      default:
        return e.message ?? 'Authentication failed. Try again.';
    }
  }
}
