import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player_app/constant.dart';
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
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
            CustomButton(
              title: LocaleKeys.login.tr(),
              onTap: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                } else {
                  autovalidateMode = AutovalidateMode.always;
                  setState(() {});
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
