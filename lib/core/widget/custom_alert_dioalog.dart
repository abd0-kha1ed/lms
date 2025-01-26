// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player_app/core/services/auth_services.dart';
import 'package:video_player_app/core/utils/app_router.dart';

class CustomAlertDialogWidget extends StatefulWidget {
  const CustomAlertDialogWidget({super.key});

  @override
  State<CustomAlertDialogWidget> createState() =>
      _CustomAlertDialogWidgetState();
}

class _CustomAlertDialogWidgetState extends State<CustomAlertDialogWidget> {
  bool showYesButton = false;

  @override
  void initState() {
    super.initState();

    // Delay the appearance of the "Yes" button by 3 seconds
    Future.delayed(const Duration(milliseconds: 1800), () {
      setState(() {
        showYesButton = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(
        Icons.warning,
        color: Colors.red,
        size: 30,
      ),
      title: const Text('Account Logout'),
      content: const SizedBox(
        height: 90,
        child: Column(
          children: [
            Text(
              'You are going to log out of your account.',
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(height: 10),
            Text(
              'Are you sure?',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // "Yes" button appears after 3 seconds
            if (showYesButton)
              TextButton(
                onPressed: () async {
                  try {
                    await FirebaseServices().signOut();

                    // Navigate to login page
                    GoRouter.of(context).go(
                      AppRouter.kLoginAsStudentView,
                      extra: {'animation': 'fade'},
                    );
                  } on Exception catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(fontSize: 22, color: Colors.red),
                ),
              )
            else
              // Placeholder for animation while waiting
              const SizedBox(
                width: 60,
                height: 30,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.red,
                  ),
                ),
              ),
            TextButton(
              onPressed: () {
                GoRouter.of(context).pop(); // Dismiss the dialog
              },
              child: const Text(
                'No',
                style: TextStyle(fontSize: 22, color: Colors.black),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
