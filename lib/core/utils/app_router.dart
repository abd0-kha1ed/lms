import 'package:Ahmed_Hamed_lecture/core/services/auth_services.dart';
import 'package:Ahmed_Hamed_lecture/feature/assistant/presentation/view/addnew_assistant_view.dart';
import 'package:Ahmed_Hamed_lecture/feature/auth/presentation/view/login_as_assistant_view.dart';
import 'package:Ahmed_Hamed_lecture/feature/auth/presentation/view/login_as_student_view.dart';
import 'package:Ahmed_Hamed_lecture/feature/auth/presentation/view/login_as_teacher_view.dart';
import 'package:Ahmed_Hamed_lecture/feature/report/presentation/view/approved_video.dart';
import 'package:Ahmed_Hamed_lecture/feature/report/presentation/view/pending_video.dart';
import 'package:Ahmed_Hamed_lecture/feature/report/presentation/view/rejected_video.dart';
import 'package:Ahmed_Hamed_lecture/feature/secure%20code/presentation/view/code_view.dart';
import 'package:Ahmed_Hamed_lecture/feature/secure%20code/presentation/view/manger/codes%20cubit/codes_cubit.dart';
import 'package:Ahmed_Hamed_lecture/feature/secure%20code/presentation/view/video_view_with_direct_code.dart';
import 'package:Ahmed_Hamed_lecture/feature/secure%20video/data/model/video_model.dart';
import 'package:Ahmed_Hamed_lecture/feature/secure%20video/presentation/view/add_encrypted_video.dart';
import 'package:Ahmed_Hamed_lecture/feature/secure%20video/presentation/view/add_new_video.dart';
import 'package:Ahmed_Hamed_lecture/feature/secure%20video/presentation/view/edit_encrypted_video_view.dart';
import 'package:Ahmed_Hamed_lecture/feature/secure%20video/presentation/view/edit_video_view.dart';
import 'package:Ahmed_Hamed_lecture/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:Ahmed_Hamed_lecture/feature/secure%20video/presentation/view/youtube_video_player.dart';
import 'package:Ahmed_Hamed_lecture/feature/splash/presentation/splash_view.dart';
import 'package:Ahmed_Hamed_lecture/feature/students/presentation/views/student_view.dart';
import 'package:Ahmed_Hamed_lecture/feature/user%20as%20assistant/presentation/view/user_as_assistant_view.dart';
import 'package:Ahmed_Hamed_lecture/feature/user%20as%20teacher/presentation/view/teacher_home_view.dart';
import 'package:Ahmed_Hamed_lecture/feature/user_as_student/presentation/view/user_as_student_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static const kTeacherLoginView = '/teacherLoginView';
  static const kAssistantLoginView = '/AssistantLoginView';
  static const kTeacherHomeView = '/teacherHomeView';
  static const kAddNewVideoView = '/addNewVideoView';
  static const kAddEncryptedVideoView = '/addEncryptedVideoView';
  static const kAddNewAssistantView = '/AddNewAssistantView';
  static const kLoginAsStudentView = '/LoginAsStudentView';
  static const kStudentView = '/StudentView';
  static const kUserAsAssistantView = '/UserAsAssistantView';
  static const kUserAsStudentView = '/UserAsStudentView';
  static const kYoutubeVideoPlayerView = '/youtubeVideo';
  static const kEditVideoView = '/editVideoView';
  static const kApprovedVideo = '/ApprovedVideo';
  static const kRejectedVideo = '/RejectedVideo';
  static const kPendingVideo = '/PendingVideo';
  static const kEditEncryptedVideo = '/editEncryptedVideo';
  static const kCodeView = '/codeView';
  static const kVideoViewWithDirectCode = '/videoViewWithDirectCode';

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
    GoRoute(
      path: kStudentView,
      builder: (context, state) => StudentView(),
    ),
    GoRoute(
      path: kAddNewAssistantView,
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
    GoRoute(
      path: kEditVideoView,
      builder: (context, state) => BlocProvider(
        create: (context) => VideoCubit(FirebaseServices()),
        child: EditVideoView(videoModel: state.extra as VideoModel),
      ),
    ),
    GoRoute(
      path: kApprovedVideo,
      builder: (context, state) => ApprovedVideo(),
    ),
    GoRoute(
      path: kRejectedVideo,
      builder: (context, state) => RejectedVideo(),
    ),
    GoRoute(
      path: kPendingVideo,
      builder: (context, state) => PendingVideo(),
    ),
    GoRoute(
      path: kEditEncryptedVideo,
      builder: (context, state) => BlocProvider(
        create: (context) => VideoCubit(
          FirebaseServices(),
        ),
        child: EditEncryptedVideoView(
          videoModel: state.extra as VideoModel,
        ),
      ),
    ),
    GoRoute(
      path: kCodeView,
      builder: (context, state) => BlocProvider(
        create: (context) => VideoCubit(
          FirebaseServices(),
        ),
        child: CodeView(
          videoModel: state.extra as VideoModel,
        ),
      ),
    ),
    GoRoute(
      path: kVideoViewWithDirectCode,
      builder: (context, state) => BlocProvider(
        create: (context) => CodesCubit(),
        child: VideoViewWithDirectCode(
          videoUrl: state.extra as String,
        ),
      ),
    ),
  ]);
}
