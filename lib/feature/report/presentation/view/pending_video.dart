// ignore_for_file: use_build_context_synchronously

import 'package:Ahmed_Hamed_lecture/core/services/auth_services.dart';
import 'package:Ahmed_Hamed_lecture/core/utils/app_router.dart';
import 'package:Ahmed_Hamed_lecture/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:Ahmed_Hamed_lecture/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PendingVideo extends StatefulWidget {
  const PendingVideo({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PendingVideoState createState() => _PendingVideoState();
}

class _PendingVideoState extends State<PendingVideo> {
  bool _isLoading = false;
  String? userRole;

  @override
  void initState() {
    super.initState();
    fetchUserRole();
  }

  Future<void> fetchUserRole() async {
    userRole = (await FirebaseServices().getUserRole())!;
    setState(() {}); // Update UI after fetching user role
  }

  String? getThumbnailUrl(String videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    return videoId != null
        ? 'https://img.youtube.com/vi/$videoId/hqdefault.jpg'
        : null;
  }

  Future<void> updateVideoApproval(String videoId, bool isApproved) async {
    setState(() {
      _isLoading = true; // Show the loading indicator
    });

    try {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoId)
          .update({'isApproved': isApproved});

      // Reload the videos by triggering the Bloc's fetch method
      context.read<VideoCubit>().fetchVideos();
    } catch (e) {
      // print('Error updating video $videoId: $e');
    } finally {
      setState(() {
        _isLoading = false; // Hide the loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.pendingVidsList.tr()),
      ),
      body: Stack(
        children: [
          BlocBuilder<VideoCubit, VideoState>(
            builder: (context, state) {
              if (state is VideoLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is VideoLoaded) {
                final pendingVideos = state.videos
                    .where((video) => video.isApproved == null)
                    .toList();

                if (pendingVideos.isEmpty) {
                  return Center(child: Text(LocaleKeys.noPendingVids.tr()));
                }

                return ListView.builder(
                  itemCount: pendingVideos.length,
                  itemBuilder: (context, index) {
                    final video = pendingVideos[index];
                    final thumbnailUrl = getThumbnailUrl(video.videoUrl);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                    '${LocaleKeys.uploadedBy.tr()} ${video.uploaderName}'),
                                trailing: Text(
                                    DateFormat('MMM dd, yyyy hh:mm a')
                                        .format(video.createdAt.toDate())),
                              ),
                            ),
                            // Show buttons only for teachers
                            if (userRole == 'teacher')
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        updateVideoApproval(video.id, true),
                                    icon: const Icon(Icons.check,
                                        color: Colors.white),
                                    label: Text(
                                      LocaleKeys.accept.tr(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        updateVideoApproval(video.id, false),
                                    icon: const Icon(Icons.close,
                                        color: Colors.white),
                                    label: Text(
                                      LocaleKeys.reject.tr(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
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
                return const Center(child: Text('Refresh to Load Videos'));
              }
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
