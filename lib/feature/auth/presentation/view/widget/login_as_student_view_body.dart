import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/services/auth_services.dart';
import 'package:video_player_app/core/utils/app_router.dart';
import 'package:video_player_app/core/widget/custom_button.dart';
import 'package:video_player_app/core/widget/custom_text_form_field.dart';
import 'package:video_player_app/feature/auth/presentation/view/widget/code_video_directly.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';
// Import AuthService

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
  final FirebaseServices _authService =
      FirebaseServices(); // Create an instance of AuthService

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
                LocaleKeys.myLectures.tr(),
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
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
            CustomButton(
              color: kPrimaryColor,
              title: LocaleKeys.login.tr(),
              onTap: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();

                  // Call the signIn method from AuthService for student login
                  final user = await _authService.signInWithCodeAndPassword(
                      code!, password!, context);
                  if (user != null) {
                    // Handle successful login (e.g., navigate to student dashboard)
                    Navigator.pushReplacementNamed(
                        context, '/studentDashboard'); // Example navigation
                  } else {
                    // Handle failed login (show an error message)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(LocaleKeys.noCodeWasFound.tr())),
                    );
                  }
                } else {
                  autovalidateMode = AutovalidateMode.always;
                  setState(() {});
                }
              },
            ),
            const SizedBox(height: 50),
            TextButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return CodeVideoDirectly();
                    });
              },
              style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(kPrimaryColor)),
              child: Text(
                LocaleKeys.useVideoCode.tr(),
                style: TextStyle(color: kPrimaryColor, fontSize: 18),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys.login.tr(),
                  style: TextStyle(fontSize: 18),
                ),
                GestureDetector(
                  onTap: () =>
                      GoRouter.of(context).push(AppRouter.kTeacherLoginView),
                  child: Text(
                    LocaleKeys.teacher.tr(),
                    style: TextStyle(
                        fontSize: 18,
                        color: kPrimaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: kPrimaryColor),
                  ),
                ),
                Text(
                  LocaleKeys.or.tr(),
                  style: TextStyle(fontSize: 18),
                ),
                GestureDetector(
                  onTap: () =>
                      GoRouter.of(context).push(AppRouter.kAssistantLoginView),
                  child: Text(
                    LocaleKeys.assistant.tr(),
                    style: TextStyle(
                        fontSize: 18,
                        color: kPrimaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: kPrimaryColor),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
