// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
    // Pre-fill the form fields with the existing student data
    _nameController.text = widget.studentModel.name;
    _codeController.text = widget.studentModel.code;
    _phoneController.text = widget.studentModel.phone;
    _teacherCodeController.text = widget.studentModel.teacherCode;
    _passwordController.text = widget.studentModel.password;
    _selectedGrade = widget.studentModel.grade;
  }

  Future<void> _updateStudent() async {
    if (!_formKey.currentState!.validate()) {
      return; // Form not valid
    }
    setState(() {
      _isLoading = true;
    });

    try {
      // Create an updated StudentModel
      StudentModel updatedStudent = StudentModel(
        id: widget.studentModel.id, // Use the existing student ID
        code: _codeController.text.trim(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        grade: _selectedGrade ?? widget.studentModel.grade,
        teacherCode: _teacherCodeController.text.trim(),
        password: _passwordController.text.trim(),
        createdAt:
            widget.studentModel.createdAt, // Keep the original creation date
      );

      // Call the update function
      await FirebaseServices().updateStudentDetails(updatedStudent);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Student updated successfully!")),
      );

      Navigator.pop(context); // Go back to the previous screen
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
                  hintText: widget.studentModel.name,
                  controller: _nameController,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter the name" : null,
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                  hintText: widget.studentModel.password,
                  controller: _passwordController,
                  obscureText: false,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter the password" : null,
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                  controller: _phoneController,
                  hintText: widget.studentModel.phone,
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
                            _selectedGrade = value;
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
