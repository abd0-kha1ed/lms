import 'package:flutter/material.dart';
import 'package:video_player_app/feature/auth/presentation/view/widget/login_as_student_view_body.dart';

class LoginAsStudentView extends StatelessWidget {
  const LoginAsStudentView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginAsStudentViewBody(),
    );
  }
}
