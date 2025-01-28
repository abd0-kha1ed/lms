import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/services/auth_services.dart';
import 'package:video_player_app/core/utils/function/custom_snack_bar.dart';
import 'package:video_player_app/core/widget/custom_button.dart';
import 'package:video_player_app/feature/secure%20video/data/model/video_model.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/widget/code_generator.dart';
import 'package:video_player_app/feature/teacher%20home/presentation/view/widget/customize_textfield.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class EditEncryptedVideoBody extends StatefulWidget {
  const EditEncryptedVideoBody({super.key, required this.videoModel});
  final VideoModel videoModel;

  @override
  State<EditEncryptedVideoBody> createState() => _EditEncryptedVideoBodyState();
}

class _EditEncryptedVideoBodyState extends State<EditEncryptedVideoBody> {
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final TextEditingController urlController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  int? generatedCodesCount;
  bool? isVideoAvailableForPlatform;

  String? videoUrl, title, description;
  String? videoDuration;
  String? selectedGrade;
  bool? isVideoVisible;
  bool? isVideoExpirable;
  DateTime? expiryDate;

  @override
  void initState() {
    urlController.text = widget.videoModel.videoUrl;
    titleController.text = widget.videoModel.title;
    descController.text = widget.videoModel.description!;
    super.initState();
  }

  void saveToDatabase(String grade) {}

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
                LocaleKeys.enterthevideoduration.tr(),
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
                        children: List.generate(24,
                            (index) => Text('$index ${LocaleKeys.hours.tr()}')),
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
                        children: List.generate(
                            60,
                            (index) =>
                                Text('$index ${LocaleKeys.minutes.tr()}')),
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
                        children: List.generate(
                            60,
                            (index) =>
                                Text('$index ${LocaleKeys.seconds.tr()}')),
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
                  LocaleKeys.setDuration.tr(),
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
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom, // Adjusts for keyboard
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Ensures it only takes necessary space
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.generateCodes.tr(),
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
                            labelText: LocaleKeys.entercodescount.tr(),
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
                          LocaleKeys.set.tr(),
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "${LocaleKeys.currentCount.tr()}: $generatedCodesCount",
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
                controller: urlController,
                text: LocaleKeys.videoLink.tr(),
                color: kPrimaryColor,
                onChanged: (value) {
                  videoUrl = value;
                },
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return LocaleKeys.enterVideoUrl.tr();
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 10),
              CustomizeTextfield(
                text: LocaleKeys.videoTitle.tr(),
                controller: titleController,
                color: kPrimaryColor,
                onChanged: (value) {
                  title = value;
                },
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return LocaleKeys.enterVideoTitle.tr();
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 10),
              CustomizeTextfield(
                text: LocaleKeys.videoDescription.tr(),
                controller: descController,
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
                    child: DropdownButtonFormField<String>(
                      validator: (level) {
                        return level == null
                            ? LocaleKeys.chooseGrade.tr()
                            : null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: kPrimaryColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      value: selectedGrade ?? widget.videoModel.grade,
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
                        videoDuration ?? widget.videoModel.videoDuration,
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
                  Text(LocaleKeys.generatedCodesCount.tr()),
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
                            "${generatedCodesCount ?? widget.videoModel.codes!.length}",
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
                  Text(LocaleKeys.visibility.tr()),
                  Switch(
                    activeTrackColor: kPrimaryColor,
                    value: isVideoVisible ?? widget.videoModel.isVideoVisible,
                    onChanged: (bool value) {
                      setState(() {
                        isVideoVisible = value;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(LocaleKeys.availableOnPlatform.tr()),
                  Switch(
                    activeTrackColor: kPrimaryColor,
                    value: isVideoAvailableForPlatform ??
                        widget.videoModel.isViewableOnPlatformIfEncrypted,
                    onChanged: (bool value) {
                      setState(() {
                        isVideoAvailableForPlatform = value;
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
              //       value:
              //           isVideoExpirable ?? widget.videoModel.isVideoExpirable,
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
              if (isVideoExpirable ??
                  widget.videoModel.isVideoExpirable && expiryDate != null)
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
                  if (state is VideoUpdatedSuccessfully) {
                    customSnackBar(context, LocaleKeys.videoUpdated.tr());
                  }
                },
                builder: (context, state) {
                  if (state is VideoLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return CustomButton(
                    title: LocaleKeys.update.tr(),
                    color: kPrimaryColor,
                    onTap: () async {
                      if (videoDuration == '00:00:00') {
                        customSnackBar(context, 'Enter the video duration');
                      } else if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        List<String> codes = CodeGenerator.generateCodes(
                            generatedCodesCount ??
                                widget.videoModel.codes!.length);

                        final updatedVideo = VideoModel(
                            createdAt: widget.videoModel.createdAt,
                            id: widget.videoModel.id,
                            uploaderName: widget.videoModel.uploaderName,
                            title: titleController.text.trim(),
                            description: descController.text.trim(),
                            videoUrl: urlController.text.trim(),
                            grade: selectedGrade ?? widget.videoModel.grade,
                            videoDuration: videoDuration ??
                                widget.videoModel.videoDuration,
                            isVideoVisible: isVideoVisible ??
                                widget.videoModel.isVideoVisible,
                            isVideoExpirable: isVideoExpirable ??
                                widget.videoModel.isVideoExpirable,
                            expiryDate:
                                expiryDate ?? widget.videoModel.expiryDate,
                            hasCodes: widget.videoModel.hasCodes,
                            isViewableOnPlatformIfEncrypted:
                                isVideoAvailableForPlatform ??
                                    widget.videoModel
                                        .isViewableOnPlatformIfEncrypted,
                            codes: codes,
                            approvedAt: widget.videoModel.approvedAt,
                            isApproved: widget.videoModel.isApproved);

                        context
                            .read<VideoCubit>()
                            .editVideoDetails(updatedVideo);
                        await FirebaseServices().addCodesToFirestore(
                            widget.videoModel.id,
                            codes,
                            widget.videoModel.videoUrl);
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
