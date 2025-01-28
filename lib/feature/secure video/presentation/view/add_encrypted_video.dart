import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/widget/add_encrypted_video_body.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class AddEncryptedVideo extends StatelessWidget {
  const AddEncryptedVideo({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.createEncryptedVideo.tr())),
      body: AddEncryptedVideoBody(),
    );
  }
}
