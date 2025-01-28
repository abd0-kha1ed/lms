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
import 'package:video_player_app/feature/auth/presentation/view/widget/code_video_directly.dart';
import 'package:video_player_app/feature/secure%20code/presentation/view/manger/codes%20cubit/codes_cubit.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class LoginAsStudentViewBody extends StatefulWidget {
  const LoginAsStudentViewBody({super.key});

  @override
  State<LoginAsStudentViewBody> createState() => _LoginAsStudentViewBodyState();
}

class _LoginAsStudentViewBodyState extends State<LoginAsStudentViewBody> {
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
        if (role == 'student') {
          GoRouter.of(context).go(AppRouter.kUserAsStudentView);
        } else {
          // Role not recognized
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(LocaleKeys.noCodeWasFound.tr())),
          );
        }
      }
    } catch (e) {
      // Log and display the error

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.noCodeWasFound.tr())),
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
                "My Lectures", // Replace with localization key if required
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 35),
            CustomTextFormField(
              hintText:
                  "Enter your code", // Replace with localization key if required
              onChanged: (value) {
                code = value;
              },
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return "Please enter your code.";
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            CustomTextFormField(
              hintText:
                  "Enter your password", // Replace with localization key if required
              onChanged: (value) {
                password = value;
              },
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return "Please enter your password.";
                }
                return null;
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
                ? Center(child: const CircularProgressIndicator())
                : CustomButton(
                    color: kPrimaryColor,
                    title: "Login", // Replace with localization key if required
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        await login(context, code!, password!);
                      }
                      context.read<VideoCubit>().fetchVideos();
                    },
                  ),
            const SizedBox(height: 30),
            TextButton(
                onPressed: () {
                  showCodeBottomSheet(context);
                },
                style: ButtonStyle(
                    foregroundColor: WidgetStatePropertyAll(kPrimaryColor)),
                child: Text(LocaleKeys.useVideoCode)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Login as "),
                GestureDetector(
                  onTap: () =>
                      GoRouter.of(context).push(AppRouter.kTeacherLoginView),
                  child: Text(
                    "Teacher",
                    style: TextStyle(
                      fontSize: 16,
                      color: kPrimaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const Text(" or "),
                GestureDetector(
                  onTap: () =>
                      GoRouter.of(context).push(AppRouter.kAssistantLoginView),
                  child: Text(
                    "Assistant",
                    style: TextStyle(
                      fontSize: 16,
                      color: kPrimaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> showCodeBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow full height control
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => CodesCubit()..fetchCodes(),
          child: BlocConsumer<CodesCubit, CodesState>(
            listener: (context, state) {
              if (state is CodeValid) {
                GoRouter.of(context).pop();
                GoRouter.of(context).go(
                  AppRouter.kVideoViewWithDirectCode,
                  extra: state.videoUrl,
                );
              } else if (state is CodeInvalid) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("الكود غير صالح أو مستخدم مسبقًا")),
                );
              }
            },
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context)
                      .viewInsets
                      .bottom, // Adjust for keyboard
                ),
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: CodeVideoDirectly(),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
