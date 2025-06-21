import 'package:Ahmed_Hamed_lecture/feature/secure%20video/presentation/view/widget/add_encrypted_video_body.dart';
import 'package:Ahmed_Hamed_lecture/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


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
