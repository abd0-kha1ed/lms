import 'package:go_router/go_router.dart';
import 'package:video_player_app/feature/auth/presentation/view/login_as_assistant_view.dart';
import 'package:video_player_app/feature/auth/presentation/view/login_as_student_view.dart';
import 'package:video_player_app/feature/auth/presentation/view/login_as_teacher_view.dart';
import 'package:video_player_app/feature/teacher%20home/presentation/view/add_encrypted_video.dart';
import 'package:video_player_app/feature/teacher%20home/presentation/view/add_new_video.dart';
import 'package:video_player_app/feature/teacher%20home/presentation/view/teacher_home_view.dart';

abstract class AppRouter {
  static const kTeacherLoginView = '/teacherLoginView';
  static const kAssistantLoginView = '/AssistantLoginView';
  static const kTeacherHomeView = '/teacherHomeView';
  static const kAddNewVideoView = '/addNewVideoView';
  static const kAddEncryptedVideoView = '/addEncryptedVideoView';

  static final routes = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => LoginAsStudentView(),
    ),
    GoRoute(
      path: kTeacherLoginView,
      builder: (context, state) => LoginAsTeacherView(),
    ),
    GoRoute(
      path: kAssistantLoginView,
      builder: (context, state) => LoginAsAssistantView(),
    ),
    GoRoute(
      path: kTeacherHomeView,
      builder: (context, state) => TeacherHomeView(),
    ),
    GoRoute(
      path: kAddNewVideoView,
      builder: (context, state) => AddNewVideo(),
    ),
    GoRoute(
      path: kAddEncryptedVideoView,
      builder: (context, state) => AddEncryptedVideo(),
    ),
  ]);
}
