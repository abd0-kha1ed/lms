import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/widget/custom_button.dart';
import 'package:video_player_app/core/widget/custom_dropdown.dart';
import 'package:video_player_app/feature/teacher%20home/presentation/view/widget/customize_textfield.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class AddEncryptedVideoBody extends StatefulWidget {
  const AddEncryptedVideoBody({super.key});

  @override
  State<AddEncryptedVideoBody> createState() => _AddEncryptedVideoBodyState();
}

class _AddEncryptedVideoBodyState extends State<AddEncryptedVideoBody> {
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? videoUrl, title, description, grade;
  String videoDuration = "00:00:00";
  int generatedCodesCount = 0;
  String? selectedExperienceLevel;
  bool isVideoVisible = true;
  bool isVideoExpirable = false;
  bool isVideoAvailableForPlatform = true;
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
      builder: (BuildContext context) {
        return Container(
          height: 300,
          padding: EdgeInsets.all(16),
          child: Column(
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
                      setState(() {
                        generatedCodesCount =
                            int.tryParse(codeController.text) ?? 0;
                      });
                      Navigator.pop(context);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.teal),
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
        );
      },
    );
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
                text: LocaleKeys.videoLink.tr(),
                color: kPrimaryColor,
                onChanged: (value) {
                  videoUrl = value;
                },
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Enter video URL';
                  } else {
                    return null;
                  }
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
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: CustomDropdown(
                        onChanged: (value) {
                          setState(() {
                            selectedExperienceLevel = value;
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
                      child: Text(
                        "$generatedCodesCount",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(LocaleKeys.canBeExpired.tr()),
                  Switch(
                    value: isVideoExpirable,
                    onChanged: (bool value) {
                      setState(() {
                        isVideoExpirable = value;
                      });
                      if (value) {
                        showExpiryDatePicker(context);
                      }
                    },
                  ),
                ],
              ),
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
              CustomButton(
                title: LocaleKeys.add.tr(),
                color: Colors.deepPurple,
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                  } else {
                    autovalidateMode = AutovalidateMode.always;
                    setState(() {});
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
