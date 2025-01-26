import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/utils/app_router.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:video_player_app/feature/teacher%20home/presentation/view/widget/add_video_button.dart';
import 'package:video_player_app/feature/teacher%20home/presentation/view/widget/video_item_list_view.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class UserAsAssistantViewBody extends StatefulWidget {
  const UserAsAssistantViewBody({super.key});

  @override
  State<UserAsAssistantViewBody> createState() => _TeacherHomeViewBodyState();
}

class _TeacherHomeViewBodyState extends State<UserAsAssistantViewBody> {
  String? userName;
  String? userRole;
  String? userCode;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                LocaleKeys.welcome.tr(),
                style: TextStyle(fontSize: 24, color: kPrimaryColor),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 10),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        userName ?? '',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                IconButton(
                    onPressed: () {
                      context.read<VideoCubit>().fetchVideos();
                    },
                    icon: Icon(Icons.refresh)),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 30),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AddVideoButton(
                  title: LocaleKeys.addNewVideo.tr(),
                  color: Colors.black,
                  onTap: () {
                    GoRouter.of(context).push(AppRouter.kAddNewVideoView);
                  },
                ),
                AddVideoButton(
                  title: LocaleKeys.addNewEncryptedVideo.tr(),
                  color: Colors.teal,
                  onTap: () {
                    GoRouter.of(context).push(AppRouter.kAddEncryptedVideoView);
                  },
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 20),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 45,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text(LocaleKeys.allGrades.tr()),
                        selected:
                            context.watch<VideoCubit>().selectedGrade.isEmpty,
                        onSelected: (selected) {
                          context.read<VideoCubit>().setGrade("");
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text("3rd Secondary"),
                        selected: context.watch<VideoCubit>().selectedGrade ==
                            "3rd Secondary",
                        onSelected: (selected) {
                          context.read<VideoCubit>().setGrade("3rd Secondary");
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text("2nd Secondary"),
                        selected: context.watch<VideoCubit>().selectedGrade ==
                            "2nd Secondary",
                        onSelected: (selected) {
                          context.read<VideoCubit>().setGrade("2nd Secondary");
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text("1st Secondary"),
                        selected: context.watch<VideoCubit>().selectedGrade ==
                            "1st Secondary",
                        onSelected: (selected) {
                          context.read<VideoCubit>().setGrade("1st Secondary");
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text("3rd Prep"),
                        selected: context.watch<VideoCubit>().selectedGrade ==
                            "3rd Prep",
                        onSelected: (selected) {
                          context.read<VideoCubit>().setGrade("3rd Prep");
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text("2nd Prep"),
                        selected: context.watch<VideoCubit>().selectedGrade ==
                            "2nd Prep",
                        onSelected: (selected) {
                          context.read<VideoCubit>().setGrade("2nd Prep");
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text("1st Prep"),
                        selected: context.watch<VideoCubit>().selectedGrade ==
                            "1st Prep",
                        onSelected: (selected) {
                          context.read<VideoCubit>().setGrade("1st Prep");
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 10),
        ),
        SliverToBoxAdapter(
          child: VideoItemListView(),
        )
      ],
    );
  }

  Future<void> fetchUserData() async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final List<String> collections = ['students', 'assistants', 'teachers'];
        for (String collection in collections) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection(collection)
              .doc(currentUser.uid)
              .get();
          if (userDoc.exists) {
            final data = userDoc.data() as Map<String, dynamic>;
            setState(() {
              userName = data['name'] ?? 'Unknown Name';
              isLoading = false;
            });
            return;
          }
        }
        // If the user is not found in any collection
        setState(() {
          userName = 'User Not Found';
          isLoading = false;
        });
      }
    } catch (e) {
      // print("Error fetching user data: $e");
      setState(() {
        userName = 'Error';
        isLoading = false;
      });
    }
  }
}
