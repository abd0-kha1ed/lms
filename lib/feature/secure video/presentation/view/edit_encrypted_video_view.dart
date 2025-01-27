import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player_app/feature/secure%20video/data/model/video_model.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/widget/edit_encrypted_video_body.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

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
              onPressed: () {
                context.read<VideoCubit>().deleteVideo(videoModel.id);

                GoRouter.of(context).pop();
                context.read<VideoCubit>().fetchVideos();
              },
              icon: Icon(Icons.delete, color: Colors.red))
        ],
      ),
      body: EditEncryptedVideoBody(videoModel: videoModel),
    );
  }
}
