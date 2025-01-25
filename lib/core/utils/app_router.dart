import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player_app/core/services/auth_services.dart';
import 'package:video_player_app/feature/assistant/presentation/view/addnew_assistant_view.dart';
import 'package:video_player_app/feature/auth/presentation/view/login_as_assistant_view.dart';
import 'package:video_player_app/feature/auth/presentation/view/login_as_student_view.dart';
import 'package:video_player_app/feature/auth/presentation/view/login_as_teacher_view.dart';
import 'package:video_player_app/feature/splash/presentation/splash_view.dart';
import 'package:video_player_app/feature/secure%20video/data/model/video_model.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/youtube_video_player.dart';
import 'package:video_player_app/feature/teacher%20home/presentation/view/add_encrypted_video.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/add_new_video.dart';
import 'package:video_player_app/feature/students/presentation/views/student_view.dart';
import 'package:video_player_app/feature/teacher%20home/presentation/view/teacher_home_view.dart';
import 'package:video_player_app/feature/user%20as%20assistant/presentation/view/user_as_assistant_view.dart';
import 'package:video_player_app/feature/user_as_student/presentation/view/user_as_student_view.dart';

abstract class AppRouter {
  static const kTeacherLoginView = '/teacherLoginView';
  static const kAssistantLoginView = '/AssistantLoginView';
  static const kTeacherHomeView = '/teacherHomeView';
  static const kAddNewVideoView = '/addNewVideoView';
  static const kAddEncryptedVideoView = '/addEncryptedVideoView';
  static const kAddnewAssistantView = '/AddnewAssistantView';
  static const kLoginAsStudentView = '/LoginAsStudentView';
  static const kStudentView = '/StudentView';
  static const kUserAsAssistantView = '/UserAsAssistantView';
  static const kUserAsStudentView = '/UserAsStudentView';
  static const kYoutubeVideoPlayerView = '/youtubeVideo';

  static final routes = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashView(),
    ),
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
      builder: (context, state) => BlocProvider(
        create: (context) => VideoCubit(FirebaseServices())..fetchVideos(),
        child: TeacherHomeView(),
      ),
    ),
    GoRoute(
      path: kAddNewVideoView,
      builder: (context, state) => AddNewVideo(),
    ),
    GoRoute(
      path: kAddEncryptedVideoView,
      builder: (context, state) => AddEncryptedVideo(),
    ),
    GoRoute(
      path: kStudentView,
      builder: (context, state) => StudentView(),
    ),
    GoRoute(
      path: kAddnewAssistantView,
      builder: (context, state) => AddNewAssistantView(),
    ),
    GoRoute(
      path: kUserAsAssistantView,
      builder: (context, state) => UserAsAssistantView(),
    ),
    GoRoute(
      path: kUserAsStudentView,
      builder: (context, state) => UserAsStudentView(),
    ),
    GoRoute(
      path: kYoutubeVideoPlayerView,
      builder: (context, state) => BlocProvider(
        create: (context) => VideoCubit(FirebaseServices()),
        child: YouTubeVideoPlayer(videoModel: state.extra as VideoModel),
      ),
    ),
  ]);
}
