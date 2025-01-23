import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class CustomShowDialog extends StatelessWidget {
  const CustomShowDialog({super.key, this.onPressed});
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(
        Icons.warning,
        color: Colors.red,
        size: 30,
      ),
      title: Text(LocaleKeys.assistantDeletion.tr()),
      content: SizedBox(
        height: 90,
        child: Column(
          children: [
            Text(
              '',
              style: TextStyle(fontSize: 17),
            ),
            Text(
              'this item',
              style: TextStyle(fontSize: 17),
            ),
            Text(
              'are you sure?',
              style: TextStyle(fontSize: 17),
            )
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: onPressed,
              child: const Text(
                'yes',
                style: TextStyle(fontSize: 22, color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                GoRouter.of(context).pop();
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
