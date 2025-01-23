import 'package:go_router/go_router.dart';
import 'package:video_player_app/feature/assistant/presentation/view/addnew_assistant_view.dart';
import 'package:video_player_app/feature/auth/presentation/view/login_as_assistant_view.dart';
import 'package:video_player_app/feature/auth/presentation/view/login_as_student_view.dart';
import 'package:video_player_app/feature/auth/presentation/view/login_as_teacher_view.dart';
import 'package:video_player_app/feature/students/presentation/views/student_view.dart';
import 'package:video_player_app/feature/teacher%20home/presentation/view/teacher_home_view.dart';

abstract class AppRouter {
  static const kTeacherLoginView = '/teacherLoginView';
  static const kAssistantLoginView = '/AssistantLoginView';
  static const kTeacherHomeView = '/teacherHomeView';
  static const kAddnewAssistantView = '/AddnewAssistantView';
  static const kLoginAsStudentView = '/';
  static const kStudentView = '/StudentView';

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
      path: kAddnewAssistantView,
      builder: (context, state) => AddnewAssistantView(),
    ),
    GoRoute(
      path: kStudentView,
      builder: (context, state) => StudentView(),
    ),
  ]);
}
