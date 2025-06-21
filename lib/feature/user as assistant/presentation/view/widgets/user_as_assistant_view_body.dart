import 'package:Ahmed_Hamed_lecture/constant.dart';
import 'package:Ahmed_Hamed_lecture/core/utils/app_router.dart';
import 'package:Ahmed_Hamed_lecture/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:Ahmed_Hamed_lecture/feature/teacher%20home/presentation/view/widget/video_item_list_view.dart';
import 'package:Ahmed_Hamed_lecture/feature/user%20as%20teacher/presentation/view/widget/add_video_button.dart';
import 'package:Ahmed_Hamed_lecture/generated/locale_keys.g.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


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
                style: TextStyle(fontSize: 26, color: kPrimaryColor),
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
                    ? CircularProgressIndicator(color: kPrimaryColor)
                    : Text(
                        userName ?? '',
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                IconButton(
                    onPressed: () {
                      context.read<VideoCubit>().fetchVideos();
                    },
                    icon: Icon(Icons.refresh, size: 32)),
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
                    // All Grades
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text(
                          LocaleKeys.allGrades.tr(),
                          style: TextStyle(
                            color: context
                                    .watch<VideoCubit>()
                                    .selectedGrade
                                    .isEmpty
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        selected:
                            context.watch<VideoCubit>().selectedGrade.isEmpty,
                        onSelected: (selected) {
                          context.read<VideoCubit>().setGrade("");
                        },
                        selectedColor: Colors.teal,
                        backgroundColor: Colors.transparent,
                        checkmarkColor: Colors.white,
                      ),
                    ),
                    // 3rd Secondary
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text(
                          LocaleKeys.twelve.tr(),
                          style: TextStyle(
                            color: context.watch<VideoCubit>().selectedGrade ==
                                    "3rd Secondary"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        selected: context.watch<VideoCubit>().selectedGrade ==
                            "3rd Secondary",
                        onSelected: (selected) {
                          context.read<VideoCubit>().setGrade("3rd Secondary");
                        },
                        selectedColor: Colors.teal,
                        backgroundColor: Colors.transparent,
                        checkmarkColor: Colors.white,
                      ),
                    ),
                    // 2nd Secondary
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text(
                          LocaleKeys.eleven.tr(),
                          style: TextStyle(
                            color: context.watch<VideoCubit>().selectedGrade ==
                                    "2nd Secondary"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        selected: context.watch<VideoCubit>().selectedGrade ==
                            "2nd Secondary",
                        onSelected: (selected) {
                          context.read<VideoCubit>().setGrade("2nd Secondary");
                        },
                        selectedColor: Colors.teal,
                        backgroundColor: Colors.transparent,
                        checkmarkColor: Colors.white,
                      ),
                    ),
                    // 1st Secondary
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text(
                          LocaleKeys.ten.tr(),
                          style: TextStyle(
                            color: context.watch<VideoCubit>().selectedGrade ==
                                    "1st Secondary"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        selected: context.watch<VideoCubit>().selectedGrade ==
                            "1st Secondary",
                        onSelected: (selected) {
                          context.read<VideoCubit>().setGrade("1st Secondary");
                        },
                        selectedColor: Colors.teal,
                        backgroundColor: Colors.transparent,
                        checkmarkColor: Colors.white,
                      ),
                    ),
                    // 3rd Prep
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text(
                          LocaleKeys.nine.tr(),
                          style: TextStyle(
                            color: context.watch<VideoCubit>().selectedGrade ==
                                    "3rd Prep"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        selected: context.watch<VideoCubit>().selectedGrade ==
                            "3rd Prep",
                        onSelected: (selected) {
                          context.read<VideoCubit>().setGrade("3rd Prep");
                        },
                        selectedColor: Colors.teal,
                        backgroundColor: Colors.transparent,
                        checkmarkColor: Colors.white,
                      ),
                    ),
                    // 2nd Prep
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text(
                          LocaleKeys.eight.tr(),
                          style: TextStyle(
                            color: context.watch<VideoCubit>().selectedGrade ==
                                    "2nd Prep"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        selected: context.watch<VideoCubit>().selectedGrade ==
                            "2nd Prep",
                        onSelected: (selected) {
                          context.read<VideoCubit>().setGrade("2nd Prep");
                        },
                        selectedColor: Colors.teal,
                        backgroundColor: Colors.transparent,
                        checkmarkColor: Colors.white,
                      ),
                    ),
                    // 1st Prep
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FilterChip(
                        label: Text(
                          LocaleKeys.seven.tr(),
                          style: TextStyle(
                            color: context.watch<VideoCubit>().selectedGrade ==
                                    "1st Prep"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        selected: context.watch<VideoCubit>().selectedGrade ==
                            "1st Prep",
                        onSelected: (selected) {
                          context.read<VideoCubit>().setGrade("1st Prep");
                        },
                        selectedColor: Colors.teal,
                        backgroundColor: Colors.transparent,
                        checkmarkColor: Colors.white,
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
          child: SizedBox(
            height: 45,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: Text(
                        LocaleKeys.both.tr(),
                        style: TextStyle(
                          color: context.watch<VideoCubit>().hasCode == null
                              ? Colors.white // White when selected
                              : Colors.black87, // Black when not selected
                        ),
                      ),
                      selected: context.watch<VideoCubit>().hasCode == null,
                      onSelected: (selected) {
                        if (selected) {
                          context
                              .read<VideoCubit>()
                              .setFilteredEncrypted(null); // Show all videos
                        }
                      },
                      selectedColor:
                          Colors.teal, // Background color when selected
                      backgroundColor: Colors
                          .transparent, // Background color when not selected
                      checkmarkColor: Colors.white,
                    ),
                    SizedBox(width: 8),
                    ChoiceChip(
                      label: Text(
                        LocaleKeys.open.tr(),
                        style: TextStyle(
                          color: context.watch<VideoCubit>().hasCode == false
                              ? Colors.white // White when selected
                              : Colors.black87, // Black when not selected
                        ),
                      ),
                      selected: context.watch<VideoCubit>().hasCode == false,
                      onSelected: (selected) {
                        if (selected) {
                          context
                              .read<VideoCubit>()
                              .setFilteredEncrypted(false); // Show open videos
                        }
                      },
                      selectedColor:
                          Colors.teal, // Background color when selected
                      backgroundColor: Colors
                          .transparent, // Background color when not selected
                      checkmarkColor: Colors.white,
                    ),
                    SizedBox(width: 8),
                    ChoiceChip(
                      label: Text(
                        LocaleKeys.encrypted.tr(),
                        style: TextStyle(
                          color: context.watch<VideoCubit>().hasCode == true
                              ? Colors.white // White when selected
                              : Colors.black87, // Black when not selected
                        ),
                      ),
                      selected: context.watch<VideoCubit>().hasCode == true,
                      onSelected: (selected) {
                        if (selected) {
                          context.read<VideoCubit>().setFilteredEncrypted(
                              true); // Show encrypted videos
                        }
                      },
                      selectedColor:
                          Colors.teal, // Background color when selected
                      backgroundColor: Colors
                          .transparent, // Background color when not selected
                      checkmarkColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: const SizedBox(height: 1)),
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
