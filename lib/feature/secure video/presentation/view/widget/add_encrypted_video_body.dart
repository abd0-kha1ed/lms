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
import 'package:video_player_app/core/widget/custom_dropdown.dart';
import 'package:video_player_app/feature/secure%20video/data/model/video_model.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/widget/code_generator.dart';
import 'package:video_player_app/feature/teacher%20home/presentation/view/widget/customize_textfield.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class AddEncryptedVideoBody extends StatefulWidget {
  const AddEncryptedVideoBody({super.key});

  @override
  State<AddEncryptedVideoBody> createState() => _AddEncryptedVideoBodyState();
}

class _AddEncryptedVideoBodyState extends State<AddEncryptedVideoBody> {
    final TextEditingController _urlController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? videoUrl, title, description, grade, uploaderName, uploaderRole;

  String videoDuration = "00:00:00";
  int generatedCodesCount = 50;
  String? selectedGrade;
  bool isVideoVisible = false;
  bool isVideoAvailableForPlatform = false;
  bool isVideoExpirable = false;

  bool hasCode = true;
  DateTime? expiryDate;

  void showExpiryDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
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
                child: const Text(
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

  void showGeneratedCodesBottomSheet(BuildContext context) {
    TextEditingController codeController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows dynamic height adjustment
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Prevents excessive height
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Generated Codes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: codeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Enter codes count",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          int newCount = int.tryParse(codeController.text) ?? 0;
                          setState(() {
                            generatedCodesCount = newCount;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                        child: Text(
                          "Set",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Current Count: $generatedCodesCount",
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
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

final RegExp _urlRegex = RegExp(
    r'^(https?:\/\/)?(www\.)?(youtube\.com|youtu\.?be|vimeo\.com)\/.+$',
    caseSensitive: false,
  );
  @override
  void initState() {
    super.initState();
    // Fetch the role once when the widget is initialized
    fetchUploaderDetails();
    isVideoVisible = false; // Default value
    isVideoAvailableForPlatform = false;
  }

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
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(LocaleKeys.grade.tr()),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.40,
                    child: CustomDropdown(
                        onChanged: (value) {
                          setState(() {
                            selectedGrade = value;
                          });
                        },
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Choose grade';
                          } else {
                            return null;
                          }
                        },
                        items: [
                          LocaleKeys.seven.tr(),
                          LocaleKeys.eight.tr(),
                          LocaleKeys.nine.tr(),
                          LocaleKeys.ten.tr(),
                          LocaleKeys.eleven.tr(),
                          LocaleKeys.twelve.tr(),
                        ]),
                  )
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
                  Text("Generated Codes Count"),
                  GestureDetector(
                    onTap: () {
                      showGeneratedCodesBottomSheet(context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: kPrimaryColor),
                      child: Row(
                        children: [
                          Text(
                            "$generatedCodesCount",
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 5),
                          Icon(Icons.key, color: Colors.white)
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Will the video be available for platform?"),
                  Switch(
                    value: isVideoAvailableForPlatform,
                    onChanged: (bool value) {
                      setState(() {
                        isVideoAvailableForPlatform = value;
                      });
                    },
                  ),
                ],
              ),
              // const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(LocaleKeys.visibility.tr()),
                  Switch(
                      value: isVideoVisible,
                      onChanged: (bool value) {
                        setState(() {
                          isVideoVisible = value;
                          // print("isVideoVisible: $isVideoVisible");
                        });
                      }),
                ],
              ),
              // const SizedBox(height: 10),
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
              if (isVideoExpirable && expiryDate != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(LocaleKeys.expiryDate.tr()),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: kPrimaryColor),
                        child: Text(
                          "${expiryDate?.toLocal().toString().split(' ')[0]} ${expiryDate?.hour}:${expiryDate?.minute}",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
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
                      }
                     else if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        final isTeacher = uploaderRole == 'teacher';
                        // print(
                        //     'Uploader role: $uploaderRole, isTeacher: $isteacher');
                        List<String> codes =
                            CodeGenerator.generateCodes(generatedCodesCount);

                        final video = VideoModel(
                          id: '',
                          createdAt: Timestamp.now(),
                          title: title!,
                          description: description ?? '',
                          videoUrl: videoUrl!,
                          grade: selectedGrade!,
                          uploaderName: uploaderName!,
                          videoDuration: videoDuration,
                          isVideoVisible:
                              isVideoVisible, // Only visible if approved
                          isVideoExpirable: isVideoExpirable,
                          expiryDate: expiryDate,
                          isApproved: isTeacher ? true : null,
                          hasCodes: hasCode,
                          codes: codes,
                          isViewableOnPlatformIfEncrypted:
                              isVideoAvailableForPlatform,
                          // Store approval status
                        );
                        context.read<VideoCubit>().addEncryptedVideo(video);
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
