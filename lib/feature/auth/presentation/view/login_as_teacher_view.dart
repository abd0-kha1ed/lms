import 'package:Ahmed_Hamed_lecture/feature/auth/presentation/view/widget/login_as_teacher_view_body.dart';
import 'package:flutter/material.dart';

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
