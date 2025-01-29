import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:video_player_app/feature/secure%20code/data/code_model.dart';

part 'codes_state.dart';

class CodesCubit extends Cubit<CodesState> {
  CodesCubit() : super(CodesInitial());

  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? '';
    }
    return '';
  }

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

      // التحقق من استخدام الكود مسبقًا
      if (matchedCode.deviceId != null && matchedCode.deviceId != deviceId) {
        emit(CodeVerificationError(message: "هذا الكود مستخدم على جهاز آخر."));
        return;
      }

      // حساب وقت انتهاء الجلسة
      int videoDurationSeconds = _parseDuration(matchedCode.videoDuration);
      Timestamp sessionEndTime = Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch +
              (videoDurationSeconds * 1.5 * 1000).toInt());

      // تحديث بيانات الجلسة في Firestore
      if (data['deviceId'] == null &&
          data['sessionStartTime'] == null &&
          data['sessionEndTime'] == null) {
        await docRef.update({
          'deviceId': deviceId,
          'sessionStartTime': Timestamp.now(),
          'sessionEndTime': sessionEndTime,
        });
      }

      if (data['isUsed'] == false &&
          DateTime.now().isBefore(sessionEndTime.toDate())) {
        DateTime nowUTC = DateTime.now().toUtc(); // تحويل الوقت الحالي إلى UTC
        DateTime sessionEndTimeUTC = data['sessionEndTime']
            .toDate()
            .toUtc(); // تحويل sessionEndTime إلى UTC
        print(sessionEndTimeUTC);
        print(nowUTC);
        if (nowUTC.isAfter(sessionEndTimeUTC)) {
          await snapshot.docs.first.reference.update({'isUsed': true});
        } else {
          emit(CodeSessionActive(
              videoUrl: matchedCode.videoUrl, sessionEndTime: sessionEndTime));
        }
      }
    } catch (e) {
      emit(CodeVerificationError(message: "حدث خطأ أثناء بدء الجلسة: $e"));
    }
  }

  // التحقق من الجلسة
  Future<void> checkSession(String enteredCode) async {
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

      var data = snapshot.docs.first.data() as Map<String, dynamic>;
      var sessionEndTime = data['sessionEndTime'] != null
          ? (data['sessionEndTime'] as Timestamp).toDate()
          : null;
      var storedDeviceId = data['deviceId'];

      // التحقق من تطابق الجهاز
      if (storedDeviceId != null && storedDeviceId != deviceId) {
        emit(CodeVerificationError(message: "هذا الكود مستخدم على جهاز آخر."));
        return;
      }
      // التحقق مما إذا كانت الجلسة لا تزال نشطة
      if (sessionEndTime != null && DateTime.now().isBefore(sessionEndTime)) {
        emit(CodeSessionActive(
            videoUrl: data['videoUrl'],
            sessionEndTime: Timestamp.fromDate(sessionEndTime)));
      } else {
        await snapshot.docs.first.reference.update({'isUsed': true});
        emit(CodeSessionExpired());
      }
    } catch (e) {
      emit(
          CodeVerificationError(message: "حدث خطأ أثناء التحقق من الجلسة: $e"));
    }
  }

  // تحليل مدة الفيديو إلى ثوانٍ
  int _parseDuration(String duration) {
    try {
      List<String> parts = duration.split(':');
      if (parts.length != 3) return 0;
      int hours = int.tryParse(parts[0]) ?? 0;
      int minutes = int.tryParse(parts[1]) ?? 0;
      int seconds = int.tryParse(parts[2]) ?? 0;
      return (hours * 3600) + (minutes * 60) + seconds;
    } catch (e) {
      return 0;
    }
  }
}
