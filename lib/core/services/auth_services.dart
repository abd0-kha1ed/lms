import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player_app/feature/secure%20video/data/model/video_model.dart';
import 'package:video_player_app/feature/auth/data/model/assistant_model.dart';
import 'package:video_player_app/feature/auth/data/model/student_model.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class FirebaseServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference videosCollection =
      FirebaseFirestore.instance.collection('videos');

  // Register Assistant
  Future<User?> registerAssistant(AssistantModel assistant) async {
    try {
      // 🔥 1. حفظ بيانات المعلم الحالي قبل إنشاء الحساب الجديد
      User? currentTeacher = _auth.currentUser;
      if (currentTeacher == null) {
        throw Exception("no teacher now");
      }

      String teacherId = currentTeacher.uid;

      // 🔥 2. جلب كلمة مرور المعلم من Firestore
      DocumentSnapshot teacherDoc = await FirebaseFirestore.instance
          .collection('teachers')
          .doc(teacherId)
          .get();

      if (!teacherDoc.exists) {
        throw Exception("not exist");
      }

      String teacherPassword = teacherDoc.get('password'); // جلب كلمة المرور
      if (teacherPassword.isEmpty) {
        throw Exception("password does not exsist in firebase");
      }

      // 🔥 3. إنشاء حساب المساعد الجديد
      String email = "${assistant.code}@gmail.com";
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: assistant.password,
      );

      User? user = userCredential.user;

      if (user != null) {
        AssistantModel updatedAssistant = AssistantModel(
          id: user.uid,
          code: assistant.code,
          name: assistant.name,
          phone: assistant.phone,
          password: assistant.password,
          teacherCode: assistant.teacherCode,
          lastCheckedInAt: Timestamp.now(),
        );

        await FirebaseFirestore.instance
            .collection('assistants')
            .doc(user.uid)
            .set({
          "role": "assistant",
          ...updatedAssistant.toJson(),
        });
      }

      // 🔥 4. تسجيل خروج المساعد الجديد فورًا بعد إضافته
      await _auth.signOut();

      // 🔥 5. إعادة تسجيل المعلم باستخدام كلمة المرور المسترجعة من Firestore
      await _auth.signInWithEmailAndPassword(
        email: currentTeacher.email!,
        password: teacherPassword,
      );

      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Register Student
  Future<User?> registerStudent(StudentModel student) async {
    try {
      // 🔥 1. حفظ بيانات المستخدم الحالي (قد يكون معلمًا أو مساعدًا)
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("not exsit");
      }

      String userId = currentUser.uid;
      String? userPassword;
      String? userRole;
      String? userEmail = currentUser.email;

      // 🔥 2. التحقق مما إذا كان المستخدم الحالي معلمًا أو مساعدًا وجلب كلمة المرور
      DocumentSnapshot teacherDoc = await FirebaseFirestore.instance
          .collection('teachers')
          .doc(userId)
          .get();

      if (teacherDoc.exists) {
        userPassword = teacherDoc.get('password');
        userRole = "teacher";
      } else {
        DocumentSnapshot assistantDoc = await FirebaseFirestore.instance
            .collection('assistants')
            .doc(userId)
            .get();

        if (assistantDoc.exists) {
          userPassword = assistantDoc.get('password');
          userRole = "assistant";
        }
      }

      if (userPassword == null || userPassword.isEmpty) {
        throw Exception(
            "❌ لا يمكن استرجاع كلمة مرور المستخدم (${userRole ?? 'غير معروف'}).");
      }

      // 🔥 3. إنشاء حساب الطالب الجديد
      String email = "${student.code}@gmail.com";
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: student.password,
      );

      User? user = userCredential.user;

      if (user != null) {
        StudentModel updatedStudent = StudentModel(
          id: user.uid,
          code: student.code,
          name: student.name,
          phone: student.phone,
          grade: student.grade,
          teacherCode: student.teacherCode,
          password: student.password,
          isPaid: student.isPaid,
          createdAt: Timestamp.now(),
        );

        await FirebaseFirestore.instance
            .collection('students')
            .doc(user.uid)
            .set({
          "role": "student",
          ...updatedStudent.toJson(),
        });
      }

      // 🔥 4. تسجيل خروج الطالب الجديد فورًا بعد إضافته
      await _auth.signOut();

      // 🔥 5. إعادة تسجيل المستخدم السابق (معلم أو مساعد) تلقائيًا بعد إنشاء الطالب
      await _auth.signInWithEmailAndPassword(
        email: userEmail!,
        password: userPassword,
      );

      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Update Student Details
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

  // Register Teacher
  // Future<User?> registerTeacher(
  //     String email, String password, String name) async {
  //   try {
  //     UserCredential userCredential =
  //         await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     User? user = userCredential.user;

  //     if (user != null) {
  //       await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
  //         "role": "teacher",
  //         "id": user.uid,
  //         "name": name,
  //         "email": email,
  //         "createdAt": Timestamp.now(),
  //       });
  //     }

  //     return user;
  //   } catch (e) {
  //     throw Exception("Registration failed: $e");
  //   }
  // }

  // Sign in with code and password
  // ignore: body_might_complete_normally_nullable
  Future<Map<String, dynamic>?> signInWithCodeAndPassword(
      String code, String password, BuildContext context) async {
    try {
      String email = "$code@gmail.com"; // Custom email format
      // print("Attempting to log in with email: $email");
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // print("Login successful. UID: ${user.uid}");

        // Define the collections to search
        final List<String> collections = ['students', 'assistants', 'teachers'];

        for (String collection in collections) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection(collection)
              .doc(user.uid)
              .get();

          if (userDoc.exists) {
            // print("User document found in $collection: ${userDoc.data()}");
            final data = userDoc.data() as Map<String, dynamic>?;
            return data; // Return the user data
          }
        }

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.noCodeWasFound.tr())),
        );

        throw Exception("User data not found.");
      }

      return null;
    } catch (e) {
      // print("Error during login: $e");

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.noCodeWasFound.tr())),
      );
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
        // Define the collections to search
        final List<String> collections = ['students', 'assistants', 'teachers'];

        for (String collection in collections) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection(collection)
              .doc(user.uid)
              .get();

          if (userDoc.exists) {
            final data = userDoc.data() as Map<String, dynamic>?;
            return data?['role'] as String?; // Return the role if found
          }
        }

        return null; // User not found in any collection
      } catch (e) {
        throw Exception("Error fetching user role: $e");
      }
    }
    return null; // No user signed in
  }

  // Auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> addVideo(VideoModel video) async {
    final docRef = videosCollection.doc(); // Generate a unique ID
    final newVideo = VideoModel(
      id: docRef.id, // Assign the generated ID
      title: video.title,
      description: video.description,
      videoUrl: video.videoUrl,
      grade: video.grade,
      uploaderName: video.uploaderName,
      videoDuration: video.videoDuration,
      isVideoVisible: video.isVideoVisible,
      isVideoExpirable: video.isVideoExpirable,
      expiryDate: video.expiryDate,
      isApproved: video.isApproved,
      createdAt: Timestamp.now(), hasCodes: false,
      isViewableOnPlatformIfEncrypted: true,
    );
    await docRef.set(newVideo.toMap());
  }

  Future<List<VideoModel>> fetchVideos() async {
    final querySnapshot = await videosCollection.get();
    return querySnapshot.docs
        .map((doc) => VideoModel.fromMap(doc.data() as Map<String, dynamic>)
          ..id = doc.id) // Ensure the id is set properly from Firestore
        .toList();
  }

  Future<void> updateVideoDetails(VideoModel updatedVideo) async {
    try {
      DocumentReference videoDoc =
          FirebaseFirestore.instance.collection('videos').doc(updatedVideo.id);

      await videoDoc.update(updatedVideo.toMap());
    } catch (e) {
      throw Exception("Failed to update student details: $e");
    }
  }

  void approveVideo(String videoId) async {
    try {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoId)
          .update({'isApproved': true, 'isVideoVisible': true});
    } catch (e) {
      // print("Error approving video: $e");
    }
  }

  Future<void> deleteVideo(String id) async {
    videosCollection.doc(id).delete();
  }

  Future<void> addCodesToFirestore(String videoId, List<String> codes,
      String videoUrl, String videoDuration) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    CollectionReference codesCollection =
        FirebaseFirestore.instance.collection('codes');

    try {
      for (var code in codes) {
        DocumentReference docRef = codesCollection.doc();
        batch.set(docRef, {
          'code': code,
          'videoId': videoId,
          'videoUrl': videoUrl,
          'videoDuration': videoDuration,
          'deviceId': null,
          'sessionStartTime': null,
          'sessionEndTime': null,
          'isUsed': false,
          'createdAt': Timestamp.now(),
        });
      }
      await batch.commit();
    } catch (e) {
      // print("Error adding codes: $e");
    }
  }

  Future<void> deleteCodesByVideoId(String videoId) async {
    try {
      QuerySnapshot codesSnapshot = await firestore
          .collection('codes')
          .where('videoId', isEqualTo: videoId)
          .get();

      for (QueryDocumentSnapshot doc in codesSnapshot.docs) {
        await firestore.collection('codes').doc(doc.id).delete();
      }
    } catch (e) {
      debugPrint('There was an error try again');
    }
  }

  Future<void> addEncryptedVideo(VideoModel video) async {
    final docRef = videosCollection.doc(); // Generate a unique ID
    final newVideo = VideoModel(
      id: docRef.id, // Assign the generated ID
      title: video.title,
      description: video.description,
      videoUrl: video.videoUrl,
      grade: video.grade,
      uploaderName: video.uploaderName,
      videoDuration: video.videoDuration,
      isVideoVisible: video.isVideoVisible,
      isVideoExpirable: video.isVideoExpirable,
      expiryDate: video.expiryDate,
      createdAt: Timestamp.now(),
      hasCodes: video.hasCodes,
      isViewableOnPlatformIfEncrypted: video.isViewableOnPlatformIfEncrypted,
      codes: video.codes,
      isApproved: video.isApproved,
      approvedAt: DateTime.now(),
    );
    await docRef.set(newVideo.toMap());
    await addCodesToFirestore(
        docRef.id, video.codes!, video.videoUrl, video.videoDuration);
  }
}
