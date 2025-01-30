import 'package:flutter/material.dart';
import 'package:no_screenshot/no_screenshot.dart';
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
  final _noScreenshot = NoScreenshot.instance;
  late YoutubePlayerController _controller;
  final int skipDuration = 10; // Progress or delay time in seconds
  String? overlayText; // Text that appears while clicking
  bool showOverlay = false; // Text display status

  void disableScreenshot() async {
    bool result = await _noScreenshot.screenshotOff();
    debugPrint('Screenshot Off: $result');
  }

  void enableScreenshot() async {
    bool result = await _noScreenshot.screenshotOn();
    debugPrint('Enable Screenshot: $result');
  }

  void toggleScreenshot() async {
    bool result = await _noScreenshot.toggleScreenshot();
    debugPrint('Toggle Screenshot: $result');
  }

  @override
  void initState() {
    super.initState();
    disableScreenshot();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoModel.videoUrl)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        forceHD: true,
        enableCaption: true,
        controlsVisibleAtStart: true,
      ),
    );
  }

  @override
  void dispose() {
    enableScreenshot();
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
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        onReady: () {
          // Video player is ready
        },
        onEnded: (data) {
          // Video has ended
        },
      ),
      builder: (context, player) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 0,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onDoubleTapDown: (details) {
                          final screenWidth = MediaQuery.of(context).size.width;
                          final tapPosition = details.localPosition.dx;

                          if (tapPosition < screenWidth / 2) {
                            skipBackward();
                          } else {
                            skipForward();
                          }
                        },
                        child: player,
                      ),
                      if (showOverlay)
                        Positioned(
                          bottom: 16.0,
                          left: 16.0,
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
                    ],
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: DescriptionSection(videoModel: widget.videoModel),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
}
