import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with code and password
  Future<User?> signInWithCodeAndPassword(String code, String password) async {
    try {
      // Example: Assuming code is the email or username
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: code, password: password);
      return userCredential.user;
    } catch (e) {
      // print("Sign-in error: $e");
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Get user role (teacher, assistant, or student)
  Future<String?> getUserRole() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Assuming that the role is stored in Firestore under the 'users' collection
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          return userDoc.data()?['role']; // Return role from Firestore
        } else {
          return null;
        }
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Listen for auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Check if the current user is a teacher, assistant, or student
  Future<String?> getUserType() async {
    final String? role = await getUserRole();
    switch (role) {
      case 'teacher':
        return 'Teacher';
      case 'assistant':
        return 'Assistant';
      case 'student':
        return 'Student';
      default:
        return 'Unknown';
    }
  }
}
