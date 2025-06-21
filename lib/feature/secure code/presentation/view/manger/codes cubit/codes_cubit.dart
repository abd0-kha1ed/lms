import 'package:Ahmed_Hamed_lecture/feature/secure%20code/data/code_model.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:meta/meta.dart';
import 'dart:io';

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

      int videoDurationSeconds = _parseDuration(matchedCode.videoDuration);
      Timestamp newSessionEndTime = Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch +
              (videoDurationSeconds * 1.5 * 1000).toInt());

      if (data['deviceId'] == null &&
          data['sessionStartTime'] == null &&
          data['sessionEndTime'] == null) {
        await docRef.update({
          'deviceId': deviceId,
          'sessionStartTime': Timestamp.now(),
          'sessionEndTime': newSessionEndTime,
        });

        DocumentSnapshot updatedDoc = await docRef.get();
        data = updatedDoc.data() as Map<String, dynamic>;
      }

      if (matchedCode.deviceId != null && matchedCode.deviceId != deviceId) {
        emit(CodeVerificationError(message: 'هذا الكود مستخدم عبي جهاز اخر'));
        return;
      }

      if (data['sessionEndTime'] is Timestamp) {
        Timestamp sessionEndTimestamp = data['sessionEndTime'] as Timestamp;

        DateTime sessionEndTimeUTC = sessionEndTimestamp.toDate().toUtc();

        DateTime nowUTC = DateTime.now().toUtc();
        if (nowUTC.isBefore(sessionEndTimeUTC)) {
          emit(CodeSessionActive(
              videoUrl: matchedCode.videoUrl,
              sessionEndTime: newSessionEndTime));
        } else {
          await snapshot.docs.first.reference.update({'isUsed': true});
          emit(CodeSessionExpired());
        }
      } else {
        emit(CodeSessionExpired());
      }
    } catch (e) {
      emit(CodeVerificationError(message: "هناك خطاء... حاول مرة اخري"));
    }
  }

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
