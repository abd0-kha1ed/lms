import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:video_player_app/core/utils/assets.dart';
import 'package:video_player_app/feature/auth/presentation/view/widget/login_view_body.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
              onTap: () {
                if (context.locale == Locale('en')) {
                  context.setLocale(Locale('ar'));
                } else {
                  context.setLocale(Locale('en'));
                }
              },
              child: Container(
                height: 40,
                width: 120,
                color: Colors.blueAccent,
                child: Center(
                  child: Text(
                    context.locale == const Locale('en') ? 'عربي' : 'English',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ))
        ],
      ),
      body: LoginViewBody(),
    );
  }
}
