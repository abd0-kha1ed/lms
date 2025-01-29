import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:meta/meta.dart';
import 'dart:io'; // For Platform.isAndroid and Platform.isIOS
import 'package:video_player_app/feature/secure%20code/data/code_model.dart';

part 'codes_state.dart';

class CodesCubit extends Cubit<CodesState> {
  CodesCubit() : super(CodesInitial());

  List<CodeModel> _codes = [];

  // Helper method to get device ID
  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Device ID for Android
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? ''; // Device ID for iOS
    }
    return '';
  }

  // Fetch all codes from Firestore
  Future<void> fetchCodes() async {
    try {
      emit(CodesLoading());

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('codes').get();

      _codes = querySnapshot.docs.map((doc) {
        return CodeModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();

      emit(CodesLoaded(codes: _codes));
    } catch (e) {
      emit(CodesError(message: "حدث خطأ أثناء تحميل الأكواد: $e"));
    }
  }

  // Verify if the entered code is valid
  Future<void> verifyCode(String enteredCode) async {
    try {
      emit(CodeVerificationLoading());

      // Fetch the code from Firestore
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('codes')
          .where('code', isEqualTo: enteredCode)
          .get();

      if (snapshot.docs.isEmpty) {
        emit(CodeInvalid());
        return;
      }

      var docRef = snapshot.docs.first.reference;
      var data = snapshot.docs.first.data() as Map<String, dynamic>;
      var matchedCode = CodeModel.fromFirestore(data);

      if (matchedCode.isUsed) {
        emit(CodeInvalid()); // الكود تم استخدامه مسبقًا
        return;
      }

      // Mark the code as used
      await docRef.update({'isUsed': true});

      emit(CodeValid(videoUrl: matchedCode.videoUrl));
    } catch (e) {
      emit(CodeVerificationError(message: "حدث خطأ أثناء التحقق من الكود: $e"));
    }
  }

  // Parse video duration string into seconds
  int _parseDuration(String duration) {
    try {
      List<String> parts = duration.split(':');
      if (parts.length != 3) return 0;
      int hours = int.tryParse(parts[0]) ?? 0;
      int minutes = int.tryParse(parts[1]) ?? 0;
      int seconds = int.tryParse(parts[2]) ?? 0;
      return (hours * 3600) + (minutes * 60) + seconds;
    } catch (e) {
      return 0; // في حالة وجود خطأ في التنسيق
    }
  }

  // Start a new session for the entered code
  Future<void> startSession(String enteredCode) async {
    try {
      emit(CodeVerificationLoading());

      String deviceId = await getDeviceId();

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('codes')
          .where('code', isEqualTo: enteredCode)
          .get();

      if (snapshot.docs.isEmpty) {
        emit(CodeInvalid());
        return;
      }

      var docRef = snapshot.docs.first.reference;
      var data = snapshot.docs.first.data() as Map<String, dynamic>;
      var matchedCode = CodeModel.fromFirestore(data);

      if (matchedCode.isUsed) {
        emit(CodeInvalid()); // الكود تم استخدامه مسبقًا
        return;
      }

      int videoDurationSeconds = _parseDuration(matchedCode.videoDuration);
      Timestamp sessionEndTime = Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch +
              (videoDurationSeconds * 1.5 * 1000).toInt());

      await docRef.update({
        'isUsed': true,
        'deviceId': deviceId,
        'sessionStartTime': Timestamp.now(),
        'sessionEndTime': sessionEndTime,
      });

      emit(CodeSessionActive(
          videoUrl: matchedCode.videoUrl, sessionEndTime: sessionEndTime));
    } catch (e) {
      emit(CodeVerificationError(message: "حدث خطأ أثناء بدء الجلسة: $e"));
    }
  }

  // Check if the session is still active
  Future<void> checkSession(String enteredCode, String deviceId) async {
    try {
      emit(CodeVerificationLoading());

      // Fetch the code from Firestore
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('codes')
          .where('code', isEqualTo: enteredCode)
          .get();

      if (snapshot.docs.isEmpty) {
        emit(CodeInvalid());
        return;
      }

      // قراءة البيانات من المستند
      var data = snapshot.docs.first.data() as Map<String, dynamic>;
      var sessionEndTime = data['sessionEndTime'] != null
          ? data['sessionEndTime'] as Timestamp
          : null;

      var storedDeviceId =
          data['deviceId'] != null ? data['deviceId'] as String : null;

// إذا كانت الحقول غير موجودة، افترض أن الجلسة لم تبدأ بعد
      if (sessionEndTime == null || storedDeviceId == null) {
        emit(CodeValid(videoUrl: data['videoUrl'])); // السماح باستخدام الكود
        return;
      }

      // التحقق مما إذا كانت الجلسة لا تزال نشطة
      if (DateTime.now().isBefore(sessionEndTime.toDate())) {
        if (storedDeviceId == deviceId) {
          // الجلسة نشطة والجهاز متطابق
          emit(CodeSessionActive(
            videoUrl: data['videoUrl'] ?? '',
            sessionEndTime: sessionEndTime,
          ));
        } else {
          // الجهاز لا يطابق
          emit(
              CodeVerificationError(message: "هذا الكود مستخدم على جهاز آخر."));
        }
      } else {
        // الجلسة انتهت
        emit(CodeSessionExpired());
      }
    } catch (e) {
      emit(
          CodeVerificationError(message: "حدث خطأ أثناء التحقق من الجلسة: $e"));
    }
  }
}
