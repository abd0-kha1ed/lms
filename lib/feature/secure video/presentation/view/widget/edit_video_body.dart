import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/utils/function/custom_snack_bar.dart';
import 'package:video_player_app/core/widget/custom_button.dart';
import 'package:video_player_app/feature/secure%20video/data/model/video_model.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:video_player_app/feature/teacher%20home/presentation/view/widget/customize_textfield.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class EditVideoBody extends StatefulWidget {
  const EditVideoBody({super.key, required this.videoModel});
  final VideoModel videoModel;

  @override
  State<EditVideoBody> createState() => _EditVideoBodyState();
}

class _EditVideoBodyState extends State<EditVideoBody> {
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final TextEditingController urlController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

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
                    return 'Enter video URL';
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
                    return 'Enter video title';
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
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: DropdownButtonFormField<String>(
                      validator: (level) {
                        return level == null ? 'Choose grade' : null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: kPrimaryColor,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                      ),
                      value: widget.videoModel.grade,
                      hint: const Text('Choose grade',
                          style: TextStyle(color: Colors.white)),
                      items: [
                        LocaleKeys.seven.tr(),
                        LocaleKeys.eight.tr(),
                        LocaleKeys.nine.tr(),
                        LocaleKeys.ten.tr(),
                        LocaleKeys.eleven.tr(),
                        LocaleKeys.twelve.tr(),
                      ]
                          .map(
                            (level) => DropdownMenuItem<String>(
                              value: level,
                              child: Text(level),
                            ),
                          )
                          .toList(),
                      onChanged: (level) {
                        setState(() {
                          selectedGrade = level;
                        });
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
                  Text(LocaleKeys.visibility.tr()),
                  Switch(
                    value: isVideoVisible ?? widget.videoModel.isVideoVisible,
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
                    value:
                        isVideoExpirable ?? widget.videoModel.isVideoExpirable,
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
                    customSnackBar(context, 'Video was updated successfully');
                  }
                },
                builder: (context, state) {
                  if (state is VideoLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return CustomButton(
                    title: LocaleKeys.update.tr(),
                    color: Colors.deepPurple,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        final updatedVideo = VideoModel(
                          createdAt: widget.videoModel.createdAt,
                          id: widget.videoModel.id,
                          title: titleController.text.trim(),
                          description: descController.text.trim(),
                          videoUrl: urlController.text.trim(),
                          grade: selectedGrade ?? widget.videoModel.grade,
                          videoDuration:
                              videoDuration ?? widget.videoModel.videoDuration,
                          isVideoVisible: isVideoVisible ??
                              widget.videoModel.isVideoVisible,
                          isVideoExpirable: isVideoExpirable ??
                              widget.videoModel.isVideoExpirable,
                          expiryDate:
                              expiryDate ?? widget.videoModel.expiryDate,
                        );

                        context
                            .read<VideoCubit>()
                            .editVideoDetails(updatedVideo);
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
