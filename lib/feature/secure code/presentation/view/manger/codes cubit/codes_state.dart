part of 'codes_cubit.dart';

@immutable
abstract class CodesState {}

class CodesInitial extends CodesState {}






class CodeVerificationLoading extends CodesState {}

class CodeValid extends CodesState {
  final String videoUrl;
  CodeValid({required this.videoUrl});
}

class CodeInvalid extends CodesState {}

class CodeVerificationError extends CodesState {
  final String message;
  CodeVerificationError({required this.message});
}

class CodeSessionActive extends CodesState {
  final String videoUrl;
  final Timestamp sessionEndTime;

  CodeSessionActive({required this.videoUrl, required this.sessionEndTime});
}

class CodeSessionExpired extends CodesState {}