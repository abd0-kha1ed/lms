import 'package:flutter/material.dart';
import 'package:video_player_app/feature/secure%20code/presentation/view/widget/code_view_body.dart';
import 'package:video_player_app/feature/secure%20video/data/model/video_model.dart';

class CodeView extends StatelessWidget {
  const CodeView({super.key, required this.videoModel});
  final VideoModel videoModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of codes'),
      ),
      body: CodeViewBody(videoModel: videoModel),
    );
  }
}
