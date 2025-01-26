import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:video_player_app/feature/teacher%20home/presentation/view/widget/video_item_list_view.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class UserAsStudentViewBody extends StatefulWidget {
  const UserAsStudentViewBody({super.key});

  @override
  State<UserAsStudentViewBody> createState() => _UserAsStudentViewBodyState();
}

class _UserAsStudentViewBodyState extends State<UserAsStudentViewBody> {
  String? userName;
  String? grade;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  LocaleKeys.welcome.tr(),
                  style: TextStyle(fontSize: 22, color: kPrimaryColor),
                ),
                Spacer(),
                IconButton(
                    onPressed: () {
                      context.read<VideoCubit>().fetchVideos();
                    },
                    icon: Icon(Icons.refresh)),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        userName ?? '',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                Spacer(),
                Container(
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              grade ?? '',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                    ))),
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          BlocBuilder<VideoCubit, VideoState>(
            builder: (context, state) {
              if (state is VideoLoading) {
                return Center();
              } else if (state is VideoLoaded) {
                return VideoItemListView(videos: state.videos);
              } else if (state is VideoError) {
                return Center(
                  child: Text(
                    state.error,
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else {
                return Center(child: Text("No Videos Available"));
              }
            },
          ),
        ],
      )),
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
              grade = data['grade'] ?? 'Unknown Grade';
              isLoading = false;
            });

            // Pass the grade to the VideoCubit for filtering
            context.read<VideoCubit>().setGrade(grade!);
            return;
          }
        }
        // If the user is not found in any collection
        setState(() {
          userName = 'User Not Found';
          grade = 'User Not Found';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        userName = 'Error';
        grade = 'Error';
        isLoading = false;
      });
    }
  }
}
