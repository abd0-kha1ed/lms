// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/widget/custom_button.dart';
import 'package:video_player_app/core/widget/custom_text_form_field.dart';
import 'package:video_player_app/feature/auth/data/model/student_model.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
      // Generate a unique ID for the student
      String studentId =
          FirebaseFirestore.instance.collection('students').doc().id;

      // Create a StudentModel from the form inputs
      final student = StudentModel(
        id: studentId, // Assign the generated ID
        code: _codeController.text.trim(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        grade: _selectedGrade ?? '',
        teacherCode: _teacherCodeController.text.trim(),
        password: _passwordController.text.trim(),
        isPaid: true,
        createdAt: Timestamp.now(),
      );

      // Manually store the student data in Firestore (without changing auth session)
      await FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .set({
        "id": studentId,
        "role": "student",
        ...student.toJson(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.studentAdded.tr())),
      );

      // Clear form
      _formKey.currentState!.reset();
      setState(() {
        _selectedGrade = null;
        _nameController.clear();
        _codeController.clear();
        _phoneController.clear();
        _teacherCodeController.clear();
        _passwordController.clear();
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

  void saveToDatabase(String grade) {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  enabled: !_isLoading,
                  validator: (value) =>
                      value!.isEmpty ? LocaleKeys.pleaseEnterName.tr() : null,
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  enabled: !_isLoading,
                  keyboardType: TextInputType.number,
                  hintText: LocaleKeys.code.tr(),
                  controller: _codeController,
                  validator: (value) =>
                      value!.isEmpty ? LocaleKeys.pleaseEnterCode.tr() : null,
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  enabled: !_isLoading,
                  hintText: LocaleKeys.password.tr(),
                  controller: _passwordController,
                  obscureText: false,
                  validator: (value) => value!.isEmpty
                      ? LocaleKeys.pleaseEnterYourPassword.tr()
                      : null,
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  enabled: !_isLoading,
                  controller: _phoneController,
                  hintText: LocaleKeys.phone.tr(),
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.phoneRequired.tr();
                    } else if (value.length != 11) {
                      return LocaleKeys.Phonenumbermustbeexactly11digits.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(LocaleKeys.grade.tr(), style: TextStyle(fontSize: 18)),
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
                        value:
                            _selectedGrade, // This will store the English value
                        hint: Text(
                          LocaleKeys.chooseGrade.tr(),
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
                                enabled: !_isLoading,
                                value: item['id'], // Store English value
                                child: Text(
                                    item['label']!), // Display localized value
                              ),
                            )
                            .toList(),
                        onChanged: (level) {
                          setState(() {
                            _selectedGrade = level; // Save English value
                          });

                          // Save to the database
                          saveToDatabase(_selectedGrade!);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                _isLoading
                    ? const CircularProgressIndicator(color: kPrimaryColor)
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
