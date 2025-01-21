import 'package:flutter/material.dart';
import 'package:video_player_app/feature/auth/presentation/view/widget/login_as_assistant_view_body.dart';

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
