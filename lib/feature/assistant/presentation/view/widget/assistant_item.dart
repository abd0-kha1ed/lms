import 'package:flutter/material.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/widget/custom_icon_button.dart';
import 'package:video_player_app/core/widget/custom_show_diolog.dart';
import 'package:video_player_app/feature/assistant/presentation/view/widget/whats_phone.dart';

class AssistantWidget extends StatelessWidget {
  final String name;
  final String code;

  final String phone;
  final VoidCallback onDelete;

  const AssistantWidget({
    super.key,
    required this.name,
    required this.code,
    required this.phone,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.person,
              size: 50,
              color: kPrimaryColor,
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  code,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  phone,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Spacer(
              flex: 6,
            ),
            CustomIconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomShowDialog(
                      onPressed: () async {
                        onDelete();
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.delete_forever,
                size: 36,
                color: Colors.red,
              ),
            )
          ],
        ),
        WhatsPhone(phoneNumber: phone),
        Divider(
          indent: 40,
          endIndent: 40,
        ),
      ],
    );
  }
}
