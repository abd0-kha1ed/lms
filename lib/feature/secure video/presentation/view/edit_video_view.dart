import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player_app/feature/secure%20video/data/model/video_model.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/widget/edit_video_body.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class EditVideoView extends StatelessWidget {
  const EditVideoView({super.key, required this.videoModel});
  final VideoModel videoModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.editVideo.tr()),
        actions: [
          IconButton(
              onPressed: () {
                context.read<VideoCubit>().deleteVideo(videoModel.id);
                context.read<VideoCubit>().fetchVideos();
                GoRouter.of(context).pop();
              },
              icon: Icon(Icons.delete, color: Colors.red))
        ],
      ),
      body: EditVideoBody(videoModel: videoModel),
    );
  }
}
