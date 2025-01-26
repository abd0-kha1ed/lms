// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        backgroundColor: Colors.white,
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              // Show loading spinner while checking authentication state
              // return const Center(
              //   child: CircularProgressIndicator(),
              // );
            } else if (state is AuthAuthenticated) {
              // Navigate based on role
              Future.microtask(() {
                if (state.role == 'teacher') {
                  GoRouter.of(context).go(AppRouter.kTeacherHomeView);
                  context.read<VideoCubit>().fetchVideos();
                } else if (state.role == 'assistant') {
                  GoRouter.of(context).go(AppRouter.kUserAsAssistantView);
                } else if (state.role == 'student') {
                  GoRouter.of(context).go(AppRouter.kUserAsStudentView);
                }
              });
              return const SizedBox.shrink(); // Avoid rendering unnecessary UI
            } else if (state is AuthUnauthenticated) {
              // Navigate to login view if unauthenticated
              Future.microtask(() {
                GoRouter.of(context).go(AppRouter.kLoginAsStudentView);
              });
              return const SizedBox.shrink(); // Avoid rendering unnecessary UI
            } else if (state is AuthError) {
              // Handle errors
              Future.microtask(() {
                GoRouter.of(context).go(AppRouter.kLoginAsStudentView);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              });
              return const SizedBox.shrink(); // Avoid rendering unnecessary UI
            }

            // Default case (initial state)
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.school, size: 100, color: Colors.blue),
                  SizedBox(height: 20),
                  Text(
                    "Welcome to the App",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
