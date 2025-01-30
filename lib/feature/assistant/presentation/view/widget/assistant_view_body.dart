import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/utils/app_router.dart';
import 'package:video_player_app/core/widget/custom_button.dart';
// Import AssistantModel
import 'package:video_player_app/feature/assistant/presentation/view/widget/assistant_item.dart';
import 'package:video_player_app/feature/auth/data/model/assistant_model.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

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
                  return Center(
                      child: Text('There was an error... please try again'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text(LocaleKeys.noAssistants.tr()));
                }

                final assistants = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: assistants.length,
                  itemBuilder: (context, index) {
                    final assistantData =
                        assistants[index].data() as Map<String, dynamic>;
                    final assistant = AssistantModel.fromJson(assistantData);
                    return AssistantWidget(
                      name: assistant.name,
                      code: assistant.code,
                      phone: assistant.phone,
                      onDelete: () async {
                        await FirebaseFirestore.instance
                            .collection('assistants')
                            .doc(assistants[index].id)
                            .delete();
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            child: CustomButton(
              title: LocaleKeys.addNewAssistant.tr(),
              color: kPrimaryColor,
              onTap: () {
                GoRouter.of(context).push(AppRouter.kAddNewAssistantView);
              },
            ),
          ),
        ],
      ),
    );
  }
}
