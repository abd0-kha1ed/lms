import 'package:Ahmed_Hamed_lecture/core/services/auth_services.dart';
import 'package:Ahmed_Hamed_lecture/feature/secure%20video/data/model/video_model.dart';
import 'package:Ahmed_Hamed_lecture/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:Ahmed_Hamed_lecture/feature/secure%20video/presentation/view/widget/edit_encrypted_video_body.dart';
import 'package:Ahmed_Hamed_lecture/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


class EditEncryptedVideoView extends StatelessWidget {
  const EditEncryptedVideoView({super.key, required this.videoModel});
  final VideoModel videoModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.editEncryptedVideo.tr()),
        actions: [
          IconButton(
              onPressed: () async {
                context.read<VideoCubit>().deleteVideo(videoModel.id);
                await FirebaseServices().deleteCodesByVideoId(videoModel.id);

                // ignore: use_build_context_synchronously
                GoRouter.of(context).pop();
              },
              icon: Icon(Icons.delete, color: Colors.red))
        ],
      ),
      body: EditEncryptedVideoBody(videoModel: videoModel),
    );
  }
}
