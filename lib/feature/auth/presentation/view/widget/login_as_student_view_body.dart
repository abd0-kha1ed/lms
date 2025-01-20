import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/utils/app_router.dart';
import 'package:video_player_app/core/widget/custom_button.dart';
import 'package:video_player_app/core/widget/custom_text_form_field.dart';

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
              child: const Text(
                'My Lectures',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 35),
            CustomTextFormField(
              hintText: 'Code',
              onChanged: (value) {
                code = value;
              },
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Enter Your Code';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: 15),
            CustomTextFormField(
              hintText: 'Password',
              onChanged: (value) {
                password = value;
              },
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Enter Your Password';
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
              title: 'Login',
              onTap: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                } else {
                  autovalidateMode = AutovalidateMode.always;
                  setState(() {});
                }
              },
            ),
            const SizedBox(height: 50),
            TextButton(
              onPressed: () {},
              style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(kPrimaryColor)),
              child: Text(
                'Use Video\'s Code directly',
                style: TextStyle(color: kPrimaryColor, fontSize: 18),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login as ',
                  style: TextStyle(fontSize: 18),
                ),
                GestureDetector(
                  onTap: () =>
                      GoRouter.of(context).push(AppRouter.kTeacherLoginView),
                  child: Text(
                    'Teacher ',
                    style: TextStyle(
                        fontSize: 18,
                        color: kPrimaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: kPrimaryColor),
                  ),
                ),
                Text(
                  'or ',
                  style: TextStyle(fontSize: 18),
                ),
                GestureDetector(
                  onTap: () =>
                      GoRouter.of(context).push(AppRouter.kAssistantLoginView),
                  child: Text(
                    'Assistant',
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
