import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register Assistant
  Future<User?> registerAssistant({
    required String code,
    required String email,
    required String password,
    required String name,
    required String phone,
    required String teacherCode,
  }) async {
    try {
      // Create the user in Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      // Store assistant details in Firestore
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('assistants')
            .doc(user.uid)
            .set({
          'id': user.uid,
          'code': code,
          'name': name,
          'phone': phone,
          'email': email,
          'password': password,
          'teacherCode': teacherCode,
          'role': 'assistant',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  // Register Student
  Future<User?> registerStudent({
    required String code,
    required String name,
    required String phone,
    required String grade,
    required String teacherCode,
    required String password,
  }) async {
    try {
      // Create the user in Firebase Authentication
      String email = "$code@gmail.com"; // Custom email format for students
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      // Store student details in Firestore
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('students')
            .doc(user.uid)
            .set({
          'id': user.uid,
          'code': code,
          'name': name,
          'phone': phone,
          'grade': grade,
          'teacherCode': teacherCode,
          'password': password,
          'role': 'student',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  // Sign in with code and password
  Future<User?> signInWithCodeAndPassword(
      String code, String password, BuildContext context) async {
    try {
      // Convert code to email for authentication
      final String email = "$code@gmail.com"; // Custom email format
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage = "No account found for the provided code.";
        } else {
          errorMessage = "Login failed: ${e.message}";
        }
        throw Exception(errorMessage);
      }
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get user role (from Firestore)
  Future<String?> getUserRole() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users') // Unified user collection
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>?;
          return data?['role'] as String?;
        } else {
          return null; // Document does not exist
        }
      } catch (e) {
        throw Exception("Error fetching user role: $e");
      }
    }
    return null; // No user signed in
  }

  // Auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
