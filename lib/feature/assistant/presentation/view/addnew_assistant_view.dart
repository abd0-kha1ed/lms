import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/services/auth_services.dart';
import 'package:video_player_app/core/widget/custom_text_form_field.dart';
import 'package:video_player_app/feature/auth/data/model/assistant_model.dart';

class AddNewAssistantView extends StatefulWidget {
  const AddNewAssistantView({super.key});

  @override
  _AddNewAssistantViewState createState() => _AddNewAssistantViewState();
}

class _AddNewAssistantViewState extends State<AddNewAssistantView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _teacherCodeController = TextEditingController();

  final AuthService _authService = AuthService();

  Future<void> _registerAssistant() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Construct AssistantModel
        final assistant = AssistantModel(
          id: '', // Will be set by Firebase
          code: _codeController.text.trim(),
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(), // Not stored in the model
          teacherCode: _teacherCodeController.text.trim(),
          lastCheckedInAt: Timestamp.now(),
        );

        // Register Assistant
        await _authService.registerAssistant(
          assistant,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Assistant registered successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Assistant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextFormField(
                  controller: _codeController,
                  hintText: 'Code',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Code is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _nameController,
                  hintText: 'Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _phoneController,
                  hintText: 'Phone Number',
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
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _emailController,
                  hintText: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _teacherCodeController,
                  hintText: 'Teacher Code',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Teacher Code is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _registerAssistant,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Add'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
