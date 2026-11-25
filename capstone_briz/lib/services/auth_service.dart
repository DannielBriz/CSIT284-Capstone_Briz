import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current user.
  static User? get currentUser => _auth.currentUser;

  // Get the current user's UID.
  static String? get currentUserId => _auth.currentUser?.uid;

  // Check if a user is signed in.
  static bool get isSignedIn => _auth.currentUser != null;

  // Sign in anonymously if needed.
  static Future<User> ensureSignedIn() async {
    try {
      debugPrint('AUTH: Checking current Firebase user...');

      final existingUser = _auth.currentUser;

      if (existingUser != null) {
        debugPrint('AUTH: User already signed in.');
        debugPrint('AUTH: UID = ${existingUser.uid}');
        return existingUser;
      }

      debugPrint('AUTH: No user found. Signing in anonymously...');

      final credential = await _auth.signInAnonymously();

      final user = credential.user;

      if (user == null) {
        throw Exception('Firebase returned a null user.');
      }

      debugPrint('AUTH: Anonymous sign-in successful!');
      debugPrint('AUTH: UID = ${user.uid}');

      return user;
    } catch (e) {
      debugPrint('AUTH ERROR: $e');
      rethrow;
    }
  }

  // Listen to authentication changes.
  static Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }

  // Sign out.
  static Future<void> signOut() async {
    await _auth.signOut();
    debugPrint('AUTH: User signed out.');
  }
}