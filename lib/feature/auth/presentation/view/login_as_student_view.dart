import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:video_player_app/feature/auth/presentation/view/widget/login_as_student_view_body.dart';

class LoginAsStudentView extends StatelessWidget {
  const LoginAsStudentView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        GestureDetector(
              onTap: () {
                if (context.locale == Locale('en')) {
                  context.setLocale(Locale('ar'));
                } else {
                  context.setLocale(Locale('en'));
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black),
                child: Center(
                  child: Text(
                    context.locale == const Locale('en') ? 'عربي' : 'English',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ))
      ],),
      body: LoginAsStudentViewBody(),
    );
  }
}
