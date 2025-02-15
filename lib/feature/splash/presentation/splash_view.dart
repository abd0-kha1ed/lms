// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/utils/assets.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:video_player_app/feature/splash/presentation/manger/auth_cubit.dart';

import 'package:go_router/go_router.dart';
import 'package:video_player_app/core/utils/app_router.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit()..checkAuthState(),
      child: Scaffold(
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              Future.delayed(const Duration(seconds: 2), () {
                if (state.role == 'teacher') {
                  GoRouter.of(context).go(AppRouter.kTeacherHomeView);
                  context.read<VideoCubit>().fetchVideos();
                } else if (state.role == 'assistant') {
                  GoRouter.of(context).go(AppRouter.kUserAsAssistantView);
                  context.read<VideoCubit>().fetchVideos();
                } else if (state.role == 'student') {
                  GoRouter.of(context).go(AppRouter.kUserAsStudentView);
                  context.read<VideoCubit>().fetchVideos();
                }
              });
            } else if (state is AuthUnauthenticated || state is AuthError) {
              Future.delayed(const Duration(seconds: 1), () {
                GoRouter.of(context).go(AppRouter.kLoginAsStudentView);
              });
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.253,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(Assets.teacherLogo)),
                        borderRadius: BorderRadius.circular(400)),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "📚  تعلّم بذكاء، وانطلق  ",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    " نحو القمة !",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 50),
                  const CircularProgressIndicator(color: kPrimaryColor)
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
