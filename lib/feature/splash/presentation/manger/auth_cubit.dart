import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> checkAuthState() async {
    emit(AuthLoading());

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in, determine their role
      await _fetchUserRole(user.uid);
    } else {
      // User is not logged in
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _fetchUserRole(String uid) async {
    try {
      final List<String> collections = ['teachers', 'assistants', 'students'];
      String? role;

      for (String collection in collections) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection(collection)
            .doc(uid)
            .get();

        if (doc.exists) {
          role = collection;
          break;
        }
      }

      if (role == 'teachers') {
        emit(AuthAuthenticated(role: 'teacher'));
      } else if (role == 'assistants') {
        emit(AuthAuthenticated(role: 'assistant'));
      } else if (role == 'students') {
        emit(AuthAuthenticated(role: 'student'));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: "Error determining user role: $e"));
    }
  }
}
