import 'package:flutter/material.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/feature/auth/data/model/student_model.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown(
      {super.key,
      required this.items,
      this.onChanged,
      this.validator,
      this.studentModel});
  final List<String> items;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final StudentModel? studentModel;

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedExperienceLevel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
            validator: widget.validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: kPrimaryColor,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
            ),
            value: selectedExperienceLevel,
            hint: Text(
                widget.studentModel != null
                    ? widget.studentModel!.grade
                    : 'Choose grade', // Default text when no model,
                style: TextStyle(color: Colors.white)),
            items: widget.items
                .map(
                  (level) => DropdownMenuItem<String>(
                    value: level,
                    child: Text(level),
                  ),
                )
                .toList(),
            onChanged: widget.onChanged),
      ],
    );
  }
}
