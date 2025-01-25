// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/services/auth_services.dart';
import 'package:video_player_app/core/widget/custom_button.dart';
import 'package:video_player_app/core/widget/custom_text_form_field.dart';
import 'package:video_player_app/feature/auth/presentation/view/widget/custom_login_container.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class LoginAsTeacherViewBody extends StatefulWidget {
  const LoginAsTeacherViewBody({super.key});

  @override
  State<LoginAsTeacherViewBody> createState() => _LoginAsTeacherViewBodyState();
}

class _LoginAsTeacherViewBodyState extends State<LoginAsTeacherViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? code, password;
  bool _isPasswordVisible = false;
<<<<<<< HEAD
  bool _isLoading = false; // Loading state for login button

  final AuthService _authService = AuthService();

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
        if (role == 'teacher') {
          // Navigate to Teacher Home View
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TeacherHomeView()),
          );
        }
      } else {
        // No user data found

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.noCodeWasFound.tr())),
        );
      }
    } catch (e) {
      // Handle login error

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.noCodeWasFound.tr())),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }
=======
  final FirebaseServices _authService =
      FirebaseServices(); // Create an instance of AuthService
>>>>>>> a503750f58cf8d83edc430b52a1b89f82b48ef99

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
              title: LocaleKeys.teacher.tr(),
              icon: Icons.school,
            )),
            const SizedBox(height: 35),
            CustomTextFormField(
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
                ? Center(child: const CircularProgressIndicator())
                : CustomButton(
                    color: kPrimaryColor,
                    title: LocaleKeys.login.tr(),
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        await login(context, code!, password!);
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
