import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:video_player_app/feature/secure%20video/data/model/video_model.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/widget/edit_video_body.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class EditVideoView extends StatelessWidget {
  const EditVideoView({super.key, required this.videoModel});
  final VideoModel videoModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.editVideo.tr())),
      body: EditVideoBody(videoModel: videoModel),
    );
  }
}
