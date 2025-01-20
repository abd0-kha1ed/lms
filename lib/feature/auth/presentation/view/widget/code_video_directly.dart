import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/widget/custom_button.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class CodeVideoDirectly extends StatelessWidget {
  const CodeVideoDirectly({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.43,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(LocaleKeys.code.tr(),
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Icon(
                  Icons.close,
                  color: Colors.red,
                )
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                hintText: LocaleKeys.enterSecretCode.tr(),
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: kPrimaryColor,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 50),
            CustomButton(title: LocaleKeys.confirmText.tr())
          ],
        ),
      ),
    );
  }
}
