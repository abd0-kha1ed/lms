import 'package:flutter/material.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoViewWithDirectCode extends StatefulWidget {
  const VideoViewWithDirectCode({super.key, required this.videoUrl});
  final String videoUrl;

  @override
  // ignore: library_private_types_in_public_api
  _VideoViewWithDirectCodeState createState() =>
      _VideoViewWithDirectCodeState();
}

class _VideoViewWithDirectCodeState extends State<VideoViewWithDirectCode> {
  late YoutubePlayerController _controller;
  final int skipDuration = 10; // Progress or delay time in seconds
  String? overlayText; // Text that appears while clicking
  bool showOverlay = false; // Text display status
  final _noScreenshot = NoScreenshot.instance;

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
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl)!,
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
    _controller.dispose();
    super.dispose();
    enableScreenshot();
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
              ],
            ),
          ),
        );
      },
    );
  }
}
