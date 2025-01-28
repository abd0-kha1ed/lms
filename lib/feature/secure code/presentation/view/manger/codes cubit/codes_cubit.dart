import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:video_player_app/feature/secure%20code/data/code_model.dart';

part 'codes_state.dart';

class CodesCubit extends Cubit<CodesState> {
  CodesCubit() : super(CodesInitial());

  List<CodeModel> _codes = []; 

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

  Future<void> verifyCode(String enteredCode) async {
    try {
      emit(CodeVerificationLoading());

      CodeModel? matchedCode = _codes.firstWhere(
        (code) => code.code == enteredCode && !code.isUsed,
        orElse: () => CodeModel.empty(),
      );

      if (matchedCode.code.isEmpty) {
        emit(CodeInvalid());
      } else {
        await FirebaseFirestore.instance
            .collection('codes')
            .where('code', isEqualTo: enteredCode)
            .get()
            .then((snapshot) {
          for (var doc in snapshot.docs) {
            doc.reference.update({'isUsed': true});
          }
        });

        emit(CodeValid(videoUrl: matchedCode.videoUrl));
      }
    } catch (e) {
      emit(CodeVerificationError(message: "حدث خطأ أثناء التحقق من الكود: $e"));
    }
  }
}
