import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/feature/assistant/presentation/view/widget/assistant_view_body.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class AssistantsView extends StatelessWidget {
  const AssistantsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Text(
          LocaleKeys.myAssistants.tr(),
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: AssistantViewBody(),
    );
  }
}
