import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/utils/app_router.dart';
import 'package:video_player_app/core/widget/custom_button.dart';
import 'package:video_player_app/core/widget/custom_icon_button.dart';
import 'package:video_player_app/core/widget/custom_show_diolog.dart';
import 'package:video_player_app/feature/assistant/presentation/view/widget/whats_phone.dart';

class AssistantViewBody extends StatelessWidget {
  const AssistantViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('assistants')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No assistants found.'));
                }

                final assistants = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: assistants.length,
                  itemBuilder: (context, index) {
                    final assistant = assistants[index];
                    return AssistantWidget(
                      name: assistant['name'],
                      code: assistant['code'],
                      email: assistant['email'],
                      phone: assistant['phone'],
                      onDelete: () async {
                        await FirebaseFirestore.instance
                            .collection('assistants')
                            .doc(assistant.id)
                            .delete();
                      },
                    );
                  },
                );
              },
            ),
          ),
          CustomButton(
            title: 'Add New Assistant',
            color: kPrimaryColor,
            onTap: () {
              GoRouter.of(context).push(AppRouter.kAddnewAssistantView);
            },
          ),
        ],
      ),
    );
  }
}

class AssistantWidget extends StatelessWidget {
  final String name;
  final String code;
  final String email;
  final String phone;
  final VoidCallback onDelete;

  const AssistantWidget({
    super.key,
    required this.name,
    required this.code,
    required this.email,
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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  code,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  email,
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
                size: 40,
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
