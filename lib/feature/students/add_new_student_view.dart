import 'package:flutter/material.dart';
import 'package:video_player_app/core/services/auth_services.dart';
import 'package:video_player_app/core/widget/custom_text_form_field.dart';

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
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _teacherCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _registerStudent() async {
    if (!_formKey.currentState!.validate()) {
      return; // Form not valid
    }
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseServices().registerStudent(
        code: _codeController.text.trim(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        grade: _gradeController.text.trim(),
        teacherCode: _teacherCodeController.text.trim(),
        password: _passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Student registered successfully!")),
      );

      // Clear form
      _formKey.currentState!.reset();
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
      appBar: AppBar(title: Text("Add New Student")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextFormField(
                  hintText: "Name",
                  controller: _nameController,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter the name" : null,
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                  hintText: "Code",
                  controller: _codeController,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter the code" : null,
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                  hintText: "Phone",
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter the phone" : null,
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                  hintText: "Grade",
                  controller: _gradeController,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter the grade" : null,
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                  hintText: "Teacher Code",
                  controller: _teacherCodeController,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter the teacher code" : null,
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                  hintText: "Password",
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter the password" : null,
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _registerStudent,
                        child: Text("Add Student"),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
