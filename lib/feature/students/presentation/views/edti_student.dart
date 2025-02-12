// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/services/auth_services.dart';
import 'package:video_player_app/core/widget/custom_button.dart';
import 'package:video_player_app/core/widget/custom_dropdown.dart';
import 'package:video_player_app/core/widget/custom_text_form_field.dart';
import 'package:video_player_app/feature/auth/data/model/student_model.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class EditStudent extends StatefulWidget {
  const EditStudent({super.key, required this.studentModel});
  final StudentModel studentModel;

  @override
  _EditStudentState createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _teacherCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _selectedGrade;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.studentModel.name;
    _codeController.text = widget.studentModel.code;
    _phoneController.text = widget.studentModel.phone;
    _teacherCodeController.text = widget.studentModel.teacherCode;
    _passwordController.text = widget.studentModel.password;

    // Ensure stored grade is always in English
    _selectedGrade = widget.studentModel.grade;
  }

  /// **Convert localized grade to English before storing in Firebase**
  String getEnglishGrade(String localizedGrade) {
    Map<String, String> gradeMap = {
      LocaleKeys.seven.tr(): '1st Prep',
      LocaleKeys.eight.tr(): '2nd Prep',
      LocaleKeys.nine.tr(): '3rd Prep',
      LocaleKeys.ten.tr(): '1st Secondary',
      LocaleKeys.eleven.tr(): '2nd Secondary',
      LocaleKeys.twelve.tr(): '3rd Secondary',
    };
    return gradeMap[localizedGrade] ?? localizedGrade;
  }

  /// **Convert stored English grade to localized display**
  String getLocalizedGrade(String englishGrade) {
    Map<String, String> gradeMap = {
      '1st Prep': LocaleKeys.seven.tr(),
      '2nd Prep': LocaleKeys.eight.tr(),
      '3rd Prep': LocaleKeys.nine.tr(),
      '1st Secondary': LocaleKeys.ten.tr(),
      '2nd Secondary': LocaleKeys.eleven.tr(),
      '3rd Secondary': LocaleKeys.twelve.tr(),
    };
    return gradeMap[englishGrade] ?? englishGrade;
  }

  Future<void> _updateStudent() async {
    if (!_formKey.currentState!.validate()) {
      return; // Form not valid
    }
    setState(() {
      _isLoading = true;
    });

    try {
      // Convert the selected grade to its English equivalent before storing
      String gradeToSave =
          getEnglishGrade(_selectedGrade ?? widget.studentModel.grade);

      // Create updated StudentModel
      StudentModel updatedStudent = StudentModel(
        id: widget.studentModel.id, // Keep existing ID
        code: _codeController.text.trim(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        grade: gradeToSave, // 🔥 Ensure stored grade is always in English
        teacherCode: _teacherCodeController.text.trim(),
        password: _passwordController.text.trim(),
        isPaid: true,
        createdAt: widget.studentModel.createdAt, // Keep original creation date
      );

      // Update Firebase
      await FirebaseServices().updateStudentDetails(updatedStudent);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Student updated successfully!")),
      );

      GoRouter.of(context).pop(); // Navigate back
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Update failed: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          LocaleKeys.update.tr(),
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextFormField(
                  enabled: false,
                  hintText: widget.studentModel.code,
                  controller: _codeController,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter the code" : null,
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                  hintText: LocaleKeys.name.tr(),
                  controller: _nameController,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter the name" : null,
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                  hintText: LocaleKeys.password.tr(),
                  controller: _passwordController,
                  obscureText: false,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter the password" : null,
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                  controller: _phoneController,
                  hintText: LocaleKeys.phone.tr(),
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    } else if (value.length != 11) {
                      return 'Phone number must be exactly 11 digits';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.grade.tr(),
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: CustomDropdown(
                        studentModel: widget.studentModel,
                        onChanged: (value) {
                          setState(() {
                            _selectedGrade = getEnglishGrade(
                                value!); // 🔥 Always convert to English before storing
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
                          getLocalizedGrade("1st Prep"),
                          getLocalizedGrade("2nd Prep"),
                          getLocalizedGrade("3rd Prep"),
                          getLocalizedGrade("1st Secondary"),
                          getLocalizedGrade("2nd Secondary"),
                          getLocalizedGrade("3rd Secondary"),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                _isLoading
                    ? CircularProgressIndicator()
                    : CustomButton(
                        color: kPrimaryColor,
                        onTap: _updateStudent,
                        title: LocaleKeys.update.tr(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
