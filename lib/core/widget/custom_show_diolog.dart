import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class CustomShowDialog extends StatelessWidget {
  const CustomShowDialog({super.key, this.onPressed, required this.delete});
  final void Function()? onPressed;
  final String delete;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(
        Icons.warning,
        color: Colors.red,
        size: 30,
      ),
      title: Text(delete),
      content: SizedBox(
        height: 40,
        child: Column(
          children: [
            Text(
              LocaleKeys.areYouSure.tr(),
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
              child: Text(
                LocaleKeys.yes.tr(),
                style: TextStyle(fontSize: 22, color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                GoRouter.of(context).pop();
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
