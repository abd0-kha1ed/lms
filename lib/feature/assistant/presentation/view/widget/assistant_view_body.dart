import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/utils/app_router.dart';
import 'package:video_player_app/core/widget/custom_button.dart';

import 'package:video_player_app/feature/assistant/presentation/view/widget/assistant_item.dart';

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
