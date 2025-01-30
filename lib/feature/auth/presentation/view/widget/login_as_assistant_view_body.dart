// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/services/auth_services.dart';
import 'package:video_player_app/core/utils/app_router.dart';
import 'package:video_player_app/core/widget/custom_button.dart';
import 'package:video_player_app/core/widget/custom_text_form_field.dart';
import 'package:video_player_app/feature/auth/presentation/view/widget/custom_login_container.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class LoginAsAssistantViewBody extends StatefulWidget {
  const LoginAsAssistantViewBody({super.key});

  @override
  State<LoginAsAssistantViewBody> createState() =>
      _LoginAsAssistantViewBodyState();
}

class _LoginAsAssistantViewBodyState extends State<LoginAsAssistantViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? code, password;
  bool _isPasswordVisible = false;
  bool _isLoading = false; // Loading state for login button

  final FirebaseServices _authService = FirebaseServices();

  Future<void> login(BuildContext context, String code, String password) async {
    if (!formKey.currentState!.validate()) {
      return; // Form is not valid
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      Map<String, dynamic>? userData =
          await _authService.signInWithCodeAndPassword(code, password, context);

      if (userData != null) {
        String role = userData['role'];
        if (role == 'assistant') {
          // Navigate to Assistant Dashboard
          GoRouter.of(context).go(AppRouter.kUserAsAssistantView);
        } else {
          // Role not recognized
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Unrecognized user role. Please try again.")),
          );
        }
      } else {
        // Failed login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Invalid login credentials. Please try again.")),
        );
      }
    } catch (e) {
      // Log and display the error
      // print("Login error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("An error occurred during login. Please try again.")),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: ListView(
          children: [
            const SizedBox(height: 100),
            Icon(FontAwesomeIcons.video, color: kPrimaryColor, size: 120),
            const SizedBox(height: 20),
            Center(
              child: Text(
                LocaleKeys.dashboard.tr(),
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            Center(
                child: CustomLoginContainer(
              title: LocaleKeys.assistant.tr(),
              icon: Icons.assignment_ind,
            )),
            const SizedBox(height: 35),
            CustomTextFormField(
              keyboardType: TextInputType.number,
              hintText: LocaleKeys.code.tr(),
              onChanged: (value) {
                code = value;
              },
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return LocaleKeys.enterYourCode.tr();
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: 15),
            CustomTextFormField(
              hintText: LocaleKeys.password.tr(),
              onChanged: (value) {
                password = value;
              },
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return LocaleKeys.enterYourPassword.tr();
                } else {
                  return null;
                }
              },
              obscureText: !_isPasswordVisible,
              suffixIcon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: kPrimaryColor,
              ),
              onTapSuffixIcon: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 30),
            _isLoading
                ? Center(child: const CircularProgressIndicator(color: kPrimaryColor))
                : CustomButton(
                    color: kPrimaryColor,
                    title: LocaleKeys.login.tr(),
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        await login(context, code!, password!);
                      }
                      context.read<VideoCubit>().fetchVideos();
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
