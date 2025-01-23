import 'package:go_router/go_router.dart';
import 'package:video_player_app/feature/assistant/presentation/view/addnew_assistant_view.dart';
import 'package:video_player_app/feature/auth/presentation/view/login_as_assistant_view.dart';
import 'package:video_player_app/feature/auth/presentation/view/login_as_student_view.dart';
import 'package:video_player_app/feature/auth/presentation/view/login_as_teacher_view.dart';
<<<<<<< HEAD
import 'package:video_player_app/feature/teacher%20home/presentation/view/add_encrypted_video.dart';
import 'package:video_player_app/feature/teacher%20home/presentation/view/add_new_video.dart';
=======
import 'package:video_player_app/feature/students/presentation/views/student_view.dart';
>>>>>>> 10e550b324c57538990c9e7208253d7eff9c79d7
import 'package:video_player_app/feature/teacher%20home/presentation/view/teacher_home_view.dart';

abstract class AppRouter {
  static const kTeacherLoginView = '/teacherLoginView';
  static const kAssistantLoginView = '/AssistantLoginView';
  static const kTeacherHomeView = '/teacherHomeView';
<<<<<<< HEAD
  static const kAddNewVideoView = '/addNewVideoView';
  static const kAddEncryptedVideoView = '/addEncryptedVideoView';
=======
  static const kAddnewAssistantView = '/AddnewAssistantView';
  static const kLoginAsStudentView = '/';
  static const kStudentView = '/StudentView';
>>>>>>> 10e550b324c57538990c9e7208253d7eff9c79d7

  static final routes = GoRouter(routes: [
    GoRoute(
      path: kLoginAsStudentView,
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
<<<<<<< HEAD
      path: kAddNewVideoView,
      builder: (context, state) => AddNewVideo(),
    ),
    GoRoute(
      path: kAddEncryptedVideoView,
      builder: (context, state) => AddEncryptedVideo(),
=======
      path: kAddnewAssistantView,
      builder: (context, state) => AddnewAssistantView(),
    ),
    GoRoute(
      path: kStudentView,
      builder: (context, state) => StudentView(),
>>>>>>> 10e550b324c57538990c9e7208253d7eff9c79d7
    ),
  ]);
}
