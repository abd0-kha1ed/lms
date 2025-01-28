// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player_app/core/services/auth_services.dart';
import 'package:video_player_app/core/utils/app_router.dart';
import 'package:video_player_app/feature/secure%20video/data/model/video_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:video_player_app/feature/teacher%20home/presentation/view/widget/video_container.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class VideoItemListView extends StatelessWidget {
  const VideoItemListView({super.key, this.videos});
  final List<VideoModel>? videos;

  String? getThumbnailUrl(String videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    if (videoId != null) {
      return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRole = FirebaseServices().getUserRole();
    return FutureBuilder<String?>(
      future: userRole,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final userRole = snapshot.data;

          return BlocBuilder<VideoCubit, VideoState>(
            builder: (context, state) {
              if (state is VideoLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is VideoLoaded) {
                // Filter the videos where isApprove is true
                final approvedVideos = userRole == 'student'
                    ? state.videos
                        .where((video) =>
                            video.isApproved == true &&
                            video.isVideoVisible == true &&
                            video.isViewableOnPlatformIfEncrypted == true)
                        .toList()
                    : state.videos
                        .where((video) => video.isApproved == true)
                        .toList();

                if (approvedVideos.isEmpty) {
                  return const Center(child: Text('No  Videos Available'));
                }

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: approvedVideos.length,
                  itemBuilder: (context, index) {
                    final thumbnailUrl =
                        getThumbnailUrl(approvedVideos[index].videoUrl);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GestureDetector(
                        onTap: () {
                          GoRouter.of(context).push(
                              AppRouter.kYoutubeVideoPlayerView,
                              extra: approvedVideos[index]);
                        },
                        onLongPress: () async {
                          String userId =
                              FirebaseAuth.instance.currentUser?.uid ?? "";

                          if (userId.isNotEmpty) {
                            DocumentSnapshot userDoc = await FirebaseFirestore
                                .instance
                                .collection(
                                    "teachers") // Assuming "teachers" is your collection
                                .doc(userId)
                                .get();

                            if (userDoc.exists &&
                                userDoc.get("role") == "teacher") {
                              if (approvedVideos[index].hasCodes == true) {
                                GoRouter.of(context).push(AppRouter.kCodeView,
                                    extra: approvedVideos[index]);
                              }
                            }
                          } else {}
                        },
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            thumbnailUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: thumbnailUrl,
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        const Center(
                                            child: Icon(Icons.broken_image,
                                                size: 50, color: Colors.grey)),
                                  )
                                : const Center(
                                    child: Icon(Icons.broken_image,
                                        size: 50, color: Colors.grey),
                                  ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  approvedVideos[index].title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                if (userRole == 'teacher')
                                  IconButton(
                                    onPressed: () {
                                      if (approvedVideos[index].hasCodes ==
                                          false) {
                                        GoRouter.of(context).push(
                                            AppRouter.kEditVideoView,
                                            extra: approvedVideos[index]);
                                      } else {
                                        GoRouter.of(context).push(
                                            AppRouter.kEditEncryptedVideo,
                                            extra: approvedVideos[index]);
                                      }
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(LocaleKeys.videoUploadedBy.tr()),
                                Text(
                                  approvedVideos[index]
                                      .uploaderName, // Display the uploader's name here
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                SizedBox(
                                  child: Column(
                                    children: [
                                      Text(
                                        // Format the date to "YYYY-MM-DD hh:mm a" with hours and AM/PM
                                        DateFormat('yyyy-MM-dd').format(
                                            approvedVideos[index]
                                                .createdAt
                                                .toDate()),
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03, // Responsive font size
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            if (userRole == 'teacher' ||
                                userRole == 'assistant')
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  VideoContainer(
                                      text: approvedVideos[index].grade,
                                      color: Colors.red),
                                  VideoContainer(
                                    text:
                                        approvedVideos[index].isVideoVisible ==
                                                true
                                            ? LocaleKeys.visible.tr()
                                            : '',
                                    color: Colors.teal,
                                    icon:
                                        approvedVideos[index].isVideoVisible ==
                                                true
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                  ),
                                  VideoContainer(
                                    text: LocaleKeys.approved.tr(),
                                    color: Colors.green,
                                    icon: Icons.check,
                                  ),
                                  Icon(approvedVideos[index].hasCodes == false
                                      ? Icons.lock_open
                                      : Icons.lock),
                                ],
                              ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (state is VideoError) {
                return Center(child: Text('There was an error ${state.error}'));
              } else {
                return const Center(child: Text('refresh'));
              }
            },
          );
        }
      },
    );
  }
}
