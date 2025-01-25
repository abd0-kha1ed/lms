import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player_app/feature/auth/data/model/assistant_model.dart';
import 'package:video_player_app/feature/auth/data/model/student_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register Assistant
  Future<User?> registerAssistant(
    AssistantModel assistant,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: assistant.email,
        password: assistant.email,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Update assistant model with the generated UID
        AssistantModel updatedAssistant = AssistantModel(
          id: user.uid,
          code: assistant.code,
          name: assistant.name,
          phone: assistant.phone,
          email: assistant.email,
          password: assistant.email,
          teacherCode: assistant.teacherCode,
          lastCheckedInAt: Timestamp.now(),
        );

        await FirebaseFirestore.instance
            .collection('assistants')
            .doc(user.uid)
            .set(updatedAssistant.toJson());
      }

      return user;
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  // Update Assistant
  Future<void> updateAssistantDetails(AssistantModel updatedAssistant) async {
    try {
      DocumentReference assistantDoc = FirebaseFirestore.instance
          .collection('assistants')
          .doc(updatedAssistant.id);

      await assistantDoc.update(updatedAssistant.toJson());
    } catch (e) {
      throw Exception("Failed to update assistant details: $e");
    }
  }

  // Register Student
  Future<User?> registerStudent(StudentModel student) async {
    try {
      String email = "${student.code}@gmail.com"; // Custom email format
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: student.password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Update student model with the generated UID
        StudentModel updatedStudent = StudentModel(
          id: user.uid,
          code: student.code,
          name: student.name,
          phone: student.phone,
          grade: student.grade,
          teacherCode: student.teacherCode,
          password: student.password,
          createdAt: Timestamp.now(),
        );

        await FirebaseFirestore.instance
            .collection('students')
            .doc(user.uid)
            .set(updatedStudent.toJson());
      }

      return user;
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  // Update Student
  Future<void> updateStudentDetails(StudentModel updatedStudent) async {
    try {
      DocumentReference studentDoc = FirebaseFirestore.instance
          .collection('students')
          .doc(updatedStudent.id);

      await studentDoc.update(updatedStudent.toJson());
    } catch (e) {
      throw Exception("Failed to update student details: $e");
    }
  }

  // Sign in with code and password
  Future<User?> signInWithCodeAndPassword(
      String code, String password, BuildContext context) async {
    try {
      String email = "$code@gmail.com"; // Custom email format
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
