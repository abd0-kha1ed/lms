import 'package:Ahmed_Hamed_lecture/constant.dart';
import 'package:Ahmed_Hamed_lecture/core/utils/app_router.dart';
import 'package:Ahmed_Hamed_lecture/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:Ahmed_Hamed_lecture/feature/teacher%20home/presentation/view/widget/video_item_list_view.dart';
import 'package:Ahmed_Hamed_lecture/feature/user%20as%20teacher/presentation/view/widget/add_video_button.dart';
import 'package:Ahmed_Hamed_lecture/feature/user%20as%20teacher/presentation/view/widget/grade_filter.dart';
import 'package:Ahmed_Hamed_lecture/feature/user%20as%20teacher/presentation/view/widget/type_video_filter.dart';
import 'package:Ahmed_Hamed_lecture/generated/locale_keys.g.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


class TeacherHomeViewBody extends StatefulWidget {
  const TeacherHomeViewBody({super.key});

  @override
  State<TeacherHomeViewBody> createState() => _TeacherHomeViewBodyState();
}

class _TeacherHomeViewBodyState extends State<TeacherHomeViewBody> {
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
                    icon: Icon(Icons.refresh, size: 30, color: Colors.black)),
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
                  color: Colors.blueGrey,
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
            child: GradeFilter(),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 10),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 45,
            child: TypeVideoFilter(),
          ),
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
