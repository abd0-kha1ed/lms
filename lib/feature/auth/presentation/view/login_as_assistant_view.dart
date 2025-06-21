import 'package:Ahmed_Hamed_lecture/feature/auth/presentation/view/widget/login_as_assistant_view_body.dart';
import 'package:flutter/material.dart';

class LoginAsAssistantView extends StatelessWidget {
  const LoginAsAssistantView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
      ),
      body: LoginAsAssistantViewBody(),
    );
  }
}
