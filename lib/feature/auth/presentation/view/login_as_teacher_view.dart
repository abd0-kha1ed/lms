import 'package:flutter/material.dart';
import 'package:video_player_app/feature/auth/presentation/view/widget/login_as_teacher_view_body.dart';

class LoginAsTeacherView extends StatelessWidget {
  const LoginAsTeacherView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
      ),
      body: LoginAsTeacherViewBody(),
    );
  }
}
