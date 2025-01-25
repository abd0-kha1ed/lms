import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/services/auth_services.dart';
import 'package:video_player_app/core/widget/custom_button.dart';
import 'package:video_player_app/core/widget/custom_dropdown.dart';
import 'package:video_player_app/core/widget/custom_text_form_field.dart';
import 'package:video_player_app/feature/auth/data/model/student_model.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _teacherCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _selectedGrade;

  Future<void> _registerStudent() async {
    if (!_formKey.currentState!.validate()) {
      return; // Form not valid
    }
    setState(() {
      _isLoading = true;
    });

    try {
      // Create a StudentModel from the form inputs
      final student = StudentModel(
        id: '', // Will be set by Firebase
        code: _codeController.text.trim(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        grade: _selectedGrade ?? '',
        teacherCode: _teacherCodeController.text.trim(),
        password: _passwordController.text.trim(), // Not stored in the model
        createdAt: Timestamp.now(),
      );

      // Call the AuthService to register the student
      await FirebaseServices().registerStudent(
        student,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Student registered successfully!")),
      );

      // Clear form
      _formKey.currentState!.reset();
      setState(() {
        _selectedGrade = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed: $e")),
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
          LocaleKeys.addNewStudent.tr(),
          style: const TextStyle(fontWeight: FontWeight.w600),
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
                  hintText: LocaleKeys.name.tr(),
                  controller: _nameController,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter the name" : null,
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  hintText: LocaleKeys.code.tr(),
                  controller: _codeController,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter the code" : null,
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  hintText: LocaleKeys.password.tr(),
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter the password" : null,
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.grade.tr(),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: CustomDropdown(
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
                const SizedBox(height: 40),
                _isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        color: kPrimaryColor,
                        onTap: _registerStudent,
                        title: LocaleKeys.add.tr(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
