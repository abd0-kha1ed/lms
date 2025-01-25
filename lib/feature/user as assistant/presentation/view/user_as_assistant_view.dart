import 'package:flutter/material.dart';
import 'package:video_player_app/core/widget/custom_alert_dioalog.dart';

class UserAsAssistantView extends StatelessWidget {
  const UserAsAssistantView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Center(
          child: Text(
            'user as Assistant',
            style: TextStyle(fontSize: 40),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const CustomAlertDialogWidget();
                },
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.red,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      "Logout",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 33,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
