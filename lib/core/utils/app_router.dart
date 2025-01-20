import 'package:go_router/go_router.dart';
import 'package:video_player_app/feature/auth/presentation/view/login_view.dart';

abstract class AppRouter {
  
  static final routes = GoRouter(routes: [
    GoRoute(path: '/',
    builder: (context, state) => LoginView(),)
  ]);
}
