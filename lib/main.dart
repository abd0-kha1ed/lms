import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:video_player_app/core/services/auth_services.dart';
import 'package:video_player_app/core/utils/app_router.dart';
import 'package:video_player_app/feature/secure%20code/presentation/view/manger/codes%20cubit/codes_cubit.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';

import 'package:video_player_app/firebase_options.dart';
import 'package:video_player_app/generated/codegen_loader.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // Check and delete expired videos at startup

  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar')],
        path:
            'assets/translations', // <-- change the path of the translation files
        fallbackLocale: Locale('en'),
        assetLoader: CodegenLoader(),
        child: SecureVideoPlayer()),
  );
}

class SecureVideoPlayer extends StatelessWidget {
  const SecureVideoPlayer({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => VideoCubit(FirebaseServices()),
        ),
        BlocProvider(
          create: (context) => CodesCubit(),
        ),
      ],
      child: MaterialApp.router(
        theme: ThemeData(
        textTheme: GoogleFonts.cairoTextTheme(),
      ),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          routerConfig: AppRouter.routes,
          builder: (context, child) => ResponsiveWrapper.builder(child,
              maxWidth: 1200,
              minWidth: 480,
              defaultScale: true,
              breakpoints: [
                const ResponsiveBreakpoint.resize(480, name: MOBILE),
                const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
              ],
              background: Container(color: Colors.white))),
    );
  }
}
