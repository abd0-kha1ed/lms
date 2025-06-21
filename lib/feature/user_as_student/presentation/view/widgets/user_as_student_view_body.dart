import 'package:Ahmed_Hamed_lecture/constant.dart';
import 'package:Ahmed_Hamed_lecture/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:Ahmed_Hamed_lecture/feature/teacher%20home/presentation/view/widget/video_item_list_view.dart';
import 'package:Ahmed_Hamed_lecture/generated/locale_keys.g.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class UserAsStudentViewBody extends StatefulWidget {
  const UserAsStudentViewBody({super.key});

  @override
  State<UserAsStudentViewBody> createState() => _UserAsStudentViewBodyState();
}

class _UserAsStudentViewBodyState extends State<UserAsStudentViewBody> {
  String? userName;
  String? grade;
  bool isLoading = true;
  bool isPaid = false; // To track if the user has paid

  final List<Map<String, String>> items = [
    {'id': '1st Prep', 'label': LocaleKeys.seven.tr()},
    {'id': '2nd Prep', 'label': LocaleKeys.eight.tr()},
    {'id': '3rd Prep', 'label': LocaleKeys.nine.tr()},
    {'id': '1st Secondary', 'label': LocaleKeys.ten.tr()},
    {'id': '2nd Secondary', 'label': LocaleKeys.eleven.tr()},
    {'id': '3rd Secondary', 'label': LocaleKeys.twelve.tr()},
  ];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Function to map Firebase grade to localized label
  String getLocalizedGrade(String grade) {
    final item = items.firstWhere(
      (element) => element['id'] == grade,
      orElse: () => {'label': 'Unknown Grade'},
    );
    return item['label'] as String;
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
                    style: TextStyle(fontSize: 26, color: kPrimaryColor),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      context.read<VideoCubit>().fetchVideos();
                    },
                    icon: Icon(Icons.refresh, size: 32),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  if (isLoading)
                    CircularProgressIndicator(color: kPrimaryColor)
                  else
                    Flexible(
                      // Ensures text wraps and does not overflow
                      child: FittedBox(
                        fit: BoxFit
                            .scaleDown, // Ensures text shrinks when needed
                        child: Text(
                          userName ?? '',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow
                              .ellipsis, // Adds "..." if name is too long
                          maxLines: 1, // Prevents multi-line wrapping
                        ),
                      ),
                    ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: isLoading
                            ? CircularProgressIndicator(color: kPrimaryColor)
                            : Text(
                                getLocalizedGrade(grade!),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            if (isPaid)
              BlocBuilder<VideoCubit, VideoState>(
                builder: (context, state) {
                  if (state is VideoLoading) {
                    return Center(child: CircularProgressIndicator());
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
                    return Center(
                        child: Text(LocaleKeys.notAvailableVideo.tr()));
                  }
                },
              )
            else
              Center(
                child: Text(
                  LocaleKeys.videosareavailableonlyforpaidusers.tr(),
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
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
              isPaid = data['ispaid'] ?? false; // Check payment status
              isLoading = false;
            });

            // Pass the grade to the VideoCubit for filtering
            // ignore: use_build_context_synchronously
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
        isPaid = false;
        isLoading = false;
      });
    }
  }
}
