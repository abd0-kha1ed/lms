part of 'codes_cubit.dart';
@immutable
abstract class CodesState {}

class CodesInitial extends CodesState {}

class CodesLoading extends CodesState {}

class CodesLoaded extends CodesState {
  final List<CodeModel> codes;
  CodesLoaded({required this.codes});
}

class CodesError extends CodesState {
  final String message;
  CodesError({required this.message});
}

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
