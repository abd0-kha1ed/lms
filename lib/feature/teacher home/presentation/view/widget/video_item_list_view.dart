// ignore_for_file: use_build_context_synchronously

import 'package:Ahmed_Hamed_lecture/core/services/auth_services.dart';
import 'package:Ahmed_Hamed_lecture/core/utils/app_router.dart';
import 'package:Ahmed_Hamed_lecture/feature/secure%20video/data/model/video_model.dart';
import 'package:Ahmed_Hamed_lecture/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:Ahmed_Hamed_lecture/feature/user%20as%20teacher/presentation/view/widget/video_container.dart';
import 'package:Ahmed_Hamed_lecture/generated/locale_keys.g.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:easy_localization/easy_localization.dart';


class VideoItemListView extends StatefulWidget {
  const VideoItemListView({super.key, this.videos});
  final List<VideoModel>? videos;

  @override
  State<VideoItemListView> createState() => _VideoItemListViewState();
}

class _VideoItemListViewState extends State<VideoItemListView> {
  String? getThumbnailUrl(String videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    if (videoId != null) {
      return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
    } else {
      return null;
    }
  }

  final List<Map<String, String>> items = [
    {
      'id': '1st Prep',
      'label': LocaleKeys.seven.tr(),
    },
    {'id': '2nd Prep', 'label': LocaleKeys.eight.tr()},
    {'id': '3rd Prep', 'label': LocaleKeys.nine.tr()},
    {'id': '1st Secondary', 'label': LocaleKeys.ten.tr()},
    {'id': '2nd Secondary', 'label': LocaleKeys.eleven.tr()},
    {'id': '3rd Secondary', 'label': LocaleKeys.twelve.tr()},
  ];

// Function to map Firebase grade to localized label
  String getLocalizedGrade(String grade) {
    final item = items.firstWhere(
      (element) => element['id'] == grade,
      orElse: () => {'label': 'Unknown Grade'}, // Fallback for unmatched keys
    );
    return item['label'] as String;
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
                  return Center(child: Text(LocaleKeys.noAvailableVideos.tr()));
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
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Stack(children: [
                                      CachedNetworkImage(
                                        imageUrl: thumbnailUrl,
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) =>
                                            const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            const Center(
                                                child: Icon(Icons.broken_image,
                                                    size: 50,
                                                    color: Colors.grey)),
                                      ),
                                      Positioned(
                                        bottom: 8.0,
                                        right: 8.0,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 4.0),
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Text(
                                            approvedVideos[index].videoDuration,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                    ]),
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
                                      text: getLocalizedGrade(
                                          approvedVideos[index].grade),
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
                                    color: Colors.blueGrey,
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
                return Center(child: Text(LocaleKeys.refresh.tr()));
              }
            },
          );
        }
      },
    );
  }
}
