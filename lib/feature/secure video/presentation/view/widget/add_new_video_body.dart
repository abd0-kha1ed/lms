import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/services/auth_services.dart';
import 'package:video_player_app/core/utils/function/custom_snack_bar.dart';
import 'package:video_player_app/core/widget/custom_button.dart';
import 'package:video_player_app/feature/secure%20video/data/model/video_model.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:video_player_app/feature/teacher%20home/presentation/view/widget/customize_textfield.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class AddNewVideoBody extends StatefulWidget {
  const AddNewVideoBody({super.key});

  @override
  State<AddNewVideoBody> createState() => _AddNewVideoBodyState();
}

class _AddNewVideoBodyState extends State<AddNewVideoBody> {
  final TextEditingController _urlController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? videoUrl, title, description, uploaderName;
  String videoDuration = "00:00:00";
  String? selectedGrade;
  String? uploaderRole;
  bool isVideoVisible = true;
  bool isVideoExpirable = false;
  DateTime? expiryDate;
  bool? isApproved;

  @override
  void initState() {
    super.initState();
    // Fetch the role once when the widget is initialized
    fetchUploaderDetails();
  }

  Future<void> fetchUploaderDetails() async {
    try {
      // Determine the uploader's role (teacher or assistant)
      final role = await FirebaseServices()
          .getUserRole(); // Assuming this returns 'teacher' or 'assistant'
      String? uploaderName;

      // Fetch uploader name based on their role
      if (role == 'teacher') {
        final teacherSnapshot = await FirebaseFirestore.instance
            .collection('teachers')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get();
        uploaderName = teacherSnapshot['name'];
      } else if (role == 'assistant') {
        final assistantSnapshot = await FirebaseFirestore.instance
            .collection('assistants')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get();
        uploaderName = assistantSnapshot['name'];
      }

      setState(() {
        uploaderRole = role;
        this.uploaderName = uploaderName ?? "Unknown";
      });
    } catch (e) {
      // print("Error fetching uploader details: $e");
      setState(() {
        uploaderRole = "Unknown";
        uploaderName = "Unknown";
      });
    }
  }

  void saveToDatabase(String grade) {
    // Example database save logic
    print('Saving grade to database: $grade');
    // Add your actual database logic here
  }

  void showDurationPicker(BuildContext context) {
    int selectedHour = 0;
    int selectedMinute = 0;
    int selectedSecond = 0;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Text(
                "Select Video Duration",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                            initialItem: selectedHour),
                        itemExtent: 40,
                        onSelectedItemChanged: (value) {
                          selectedHour = value;
                        },
                        children:
                            List.generate(24, (index) => Text('$index hours')),
                      ),
                    ),
                    Flexible(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                            initialItem: selectedMinute),
                        itemExtent: 40,
                        onSelectedItemChanged: (value) {
                          selectedMinute = value;
                        },
                        children:
                            List.generate(60, (index) => Text('$index min.')),
                      ),
                    ),
                    Flexible(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                            initialItem: selectedSecond),
                        itemExtent: 40,
                        onSelectedItemChanged: (value) {
                          selectedSecond = value;
                        },
                        children:
                            List.generate(60, (index) => Text('$index sec.')),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    videoDuration =
                        "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}:${selectedSecond.toString().padLeft(2, '0')}";
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: Text(
                  "Set Duration",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void showExpiryDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "Select Expiry Date",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      expiryDate = newDate;
                    });
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: Text(
                  "Confirm",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  final RegExp _urlRegex = RegExp(
    r'^(https?:\/\/)?(www\.)?(youtube\.com|youtu\.?be|vimeo\.com)\/.+$',
    caseSensitive: false,
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomizeTextfield(
                controller: _urlController,
                text: LocaleKeys.videoLink.tr(),
                color: kPrimaryColor,
                onChanged: (value) {
                  videoUrl = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the url';
                  }
                  if (!_urlRegex.hasMatch(value)) {
                    return 'Enter valid url';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CustomizeTextfield(
                text: LocaleKeys.videoTitle.tr(),
                color: kPrimaryColor,
                onChanged: (value) {
                  title = value;
                },
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Enter video title';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 10),
              CustomizeTextfield(
                text: LocaleKeys.videoDescription.tr(),
                color: kPrimaryColor,
                maxLines: 6,
                onChanged: (value) {
                  description = value;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(LocaleKeys.grade.tr()),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.40,
                    child: DropdownButtonFormField<String>(
                      validator: (level) {
                        return level == null ? 'Choose grade' : null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: kPrimaryColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      value: selectedGrade, // This will store the English value
                      hint: const Text(
                        'Choose grade',
                        style: TextStyle(color: Colors.white),
                      ),
                      items: [
                        {'id': '1st Prep', 'label': LocaleKeys.seven.tr()},
                        {'id': '2nd Prep', 'label': LocaleKeys.eight.tr()},
                        {'id': '3rd Prep', 'label': LocaleKeys.nine.tr()},
                        {'id': '1st Secondary', 'label': LocaleKeys.ten.tr()},
                        {
                          'id': '2nd Secondary',
                          'label': LocaleKeys.eleven.tr()
                        },
                        {
                          'id': '3rd Secondary',
                          'label': LocaleKeys.twelve.tr()
                        },
                      ]
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item['id'], // Store English value
                              child: Text(
                                  item['label']!), // Display localized value
                            ),
                          )
                          .toList(),
                      onChanged: (level) {
                        setState(() {
                          selectedGrade = level; // Save English value
                        });

                        // Save to the database
                        saveToDatabase(selectedGrade!);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(LocaleKeys.videoDuration.tr()),
                  GestureDetector(
                    onTap: () {
                      showDurationPicker(context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: kPrimaryColor),
                      child: Text(
                        videoDuration,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(LocaleKeys.visibility.tr()),
                  Switch(
                    value: isVideoVisible,
                    onChanged: (bool value) {
                      setState(() {
                        isVideoVisible = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(LocaleKeys.canBeExpired.tr()),
              //     Switch(
              //       value: isVideoExpirable,
              //       onChanged: (bool value) {
              //         setState(() {
              //           isVideoExpirable = value;
              //         });
              //         if (value) {
              //           showExpiryDatePicker(context);
              //         }
              //       },
              //     ),
              //   ],
              // ),
              // if (isVideoExpirable && expiryDate != null)
              //   Padding(
              //     padding: const EdgeInsets.symmetric(vertical: 15),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text(LocaleKeys.expiryDate.tr()),
              //         Container(
              //           padding:
              //               EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              //           decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(8),
              //               color: kPrimaryColor),
              //           child: Text(
              //             "${expiryDate?.toLocal().toString().split(' ')[0]} ${expiryDate?.hour}:${expiryDate?.minute}",
              //             style: TextStyle(
              //                 color: Colors.white, fontWeight: FontWeight.bold),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              const SizedBox(height: 15),
              BlocConsumer<VideoCubit, VideoState>(
                listener: (context, state) {
                  if (state is VideoAddedSuccessfully) {
                    customSnackBar(context, 'Video was added successfully');
                  }
                },
                builder: (context, state) {
                  if (state is VideoLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return CustomButton(
                    title: LocaleKeys.add.tr(),
                    color: Colors.deepPurple,
                    onTap: () {
                      if (videoDuration == '00:00:00') {
                        customSnackBar(context, 'Enter the video duration');
                      } else if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        final isTeacher = uploaderRole == 'teacher';

                        final video = VideoModel(
                            id: '',
                            createdAt: Timestamp.now(),
                            title: title!,
                            description: description ?? '',
                            videoUrl: videoUrl!,
                            grade: selectedGrade!,
                            uploaderName: uploaderName!,
                            videoDuration: videoDuration,
                            isVideoVisible: isVideoVisible,
                            isVideoExpirable: isVideoExpirable,
                            expiryDate: expiryDate,
                            hasCodes: false,
                            isViewableOnPlatformIfEncrypted: false,
                            isApproved:
                                isTeacher ? true : null // Store approval status
                            );

                        context.read<VideoCubit>().addVideo(video);
                      } else {
                        autovalidateMode = AutovalidateMode.always;
                        setState(() {});
                      }
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
