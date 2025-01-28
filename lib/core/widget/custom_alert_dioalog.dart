// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player_app/core/services/auth_services.dart';
import 'package:video_player_app/core/utils/app_router.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

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

    // Delay the appearance of the "Yes" button by 1.8 seconds
    Future.delayed(const Duration(milliseconds: 1800), () {
      setState(() {
        showYesButton = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive layout
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      icon: const Icon(
        Icons.warning,
        color: Colors.red,
        size: 30,
      ),
      title: Text(
        LocaleKeys.accLogout.tr(),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
      content: SizedBox(
        height: screenHeight * 0.12, // Responsive height
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You are going to log out of your account.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.01), // Responsive spacing
            const Text(
              'Are you sure?',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // "Yes" button appears after delay
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
                child: Text(
                  LocaleKeys.yes.tr(),
                  style: TextStyle(fontSize: 22, color: Colors.red),
                ),
              )
            else
              // Placeholder for animation while waiting
              SizedBox(
                width: screenWidth * 0.15, // Responsive size
                height: screenHeight * 0.03,
                child: const Center(
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
              child: Text(
                LocaleKeys.no.tr(),
                style: TextStyle(fontSize: 22, color: Colors.black),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
