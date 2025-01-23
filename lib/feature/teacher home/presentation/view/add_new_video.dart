import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:video_player_app/feature/teacher%20home/presentation/view/widget/add_new_video_body.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class AddNewVideo extends StatelessWidget {
const AddNewVideo({ super.key });
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: Text(LocaleKeys.createVideo.tr()),),
body: AddNewVideoBody(),
);
}
}