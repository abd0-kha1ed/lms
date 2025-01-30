import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player_app/core/utils/app_router.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ApprovedVideo extends StatelessWidget {
  const ApprovedVideo({super.key});

  // Function to fetch the YouTube thumbnail
  String? getThumbnailUrl(String videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    return videoId != null
        ? 'https://img.youtube.com/vi/$videoId/hqdefault.jpg'
        : null;
  }

  // Function to update the `isApproved` field in Firestore

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.approvedVidsList.tr()),
      ),
      body: BlocBuilder<VideoCubit, VideoState>(
        builder: (context, state) {
          if (state is VideoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VideoLoaded) {
            // Filter videos where isApproved is null
            final pendingVideos = state.videos
                .where((video) => video.isApproved == true)
                .toList();

            if (pendingVideos.isEmpty) {
              return Center(child: Text(LocaleKeys.noApprovedVideos.tr()));
            }

            return ListView.builder(
              itemCount: pendingVideos.length,
              itemBuilder: (context, index) {
                final video = pendingVideos[index];
                final thumbnailUrl = getThumbnailUrl(video.videoUrl);

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            GoRouter.of(context).push(
                                AppRouter.kYoutubeVideoPlayerView,
                                extra: pendingVideos[index]);
                          },
                          child: ListTile(
                            leading: thumbnailUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: thumbnailUrl,
                                    fit: BoxFit.cover,
                                    width: 80,
                                    height: 60,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.broken_image),
                                  )
                                : const Icon(Icons.broken_image),
                            title: Text(
                              video.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                '${LocaleKeys.uploadedBy.tr()}${video.uploaderName}'),
                            trailing: Text(DateFormat('MMM dd, yyyy hh:mm a')
                                .format(video.createdAt.toDate())),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is VideoError) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return Center(child: Text(LocaleKeys.refresh.tr()));
          }
        },
      ),
    );
  }
}

// class YoutubePlayerScreen extends StatelessWidget {
//   final String videoUrl;

//   const YoutubePlayerScreen({Key? key, required this.videoUrl})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final videoId = YoutubePlayer.convertUrlToId(videoUrl);
//     final YoutubePlayerController controller = YoutubePlayerController(
//       initialVideoId: videoId ?? '',
//       flags: const YoutubePlayerFlags(
//         autoPlay: true,
//         mute: false,
//       ),
//     );

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Video Player'),
//       ),
//       body: YoutubePlayer(
//         controller: controller,
//         showVideoProgressIndicator: true,
//       ),
//     );
//   }
// }
