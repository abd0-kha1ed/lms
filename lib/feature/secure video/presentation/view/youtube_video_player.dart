import 'package:flutter/material.dart';
import 'package:video_player_app/feature/secure%20video/data/model/video_model.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/widget/describtion_section.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeVideoPlayer extends StatefulWidget {
  const YouTubeVideoPlayer({super.key, required this.videoModel});
  final VideoModel videoModel;

  @override
  // ignore: library_private_types_in_public_api
  _YouTubeVideoPlayerState createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends State<YouTubeVideoPlayer> {
  late YoutubePlayerController _controller;
  final int skipDuration = 10; // Progress or delay time in seconds
  String? overlayText; // Text that appears while clicking
  bool showOverlay = false; // Text display status

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoModel.videoUrl)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showSkipOverlay(String text) {
    setState(() {
      overlayText = text;
      showOverlay = true;
    });
// Hide text after 1 second.
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        showOverlay = false;
      });
    });
  }

  void skipForward() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition + Duration(seconds: skipDuration);
    _controller.seekTo(newPosition);
    showSkipOverlay('+${skipDuration}s'); // Show progress
  }

  void skipBackward() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition - Duration(seconds: skipDuration);
    _controller
        .seekTo(newPosition > Duration.zero ? newPosition : Duration.zero);
    showSkipOverlay('-${skipDuration}s'); // Show delay
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            GestureDetector(
              onDoubleTapDown: (details) {
                final screenWidth = MediaQuery.of(context).size.width;
                final tapPosition = details.localPosition.dx;

                if (tapPosition < screenWidth / 2) {
                  // If the left part of the screen is clicked -> Delay
                  skipBackward();
                } else {
                  // If the left part of the screen is clicked -> Progress
                  skipForward();
                }
              },
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                onReady: () {
                  // print('Player is ready.');
                },
                onEnded: (data) {
                  // print('Video has ended.');
                },
              ),
            ),
          ]),
          if (showOverlay)
            Positioned(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  overlayText ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          DescriptionSection(videoModel: widget.videoModel)
        ],
      ),
    );
  }
}
