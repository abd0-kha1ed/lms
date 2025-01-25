import 'package:flutter/material.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/services/auth_services.dart';
import 'package:video_player_app/core/widget/custom_text_form_field.dart';

class AddnewAssistantView extends StatefulWidget {
  const AddnewAssistantView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddnewAssistantViewState createState() => _AddnewAssistantViewState();
}

class _AddnewAssistantViewState extends State<AddnewAssistantView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _teacherCodeController = TextEditingController();

  final FirebaseServices _authService = FirebaseServices();

  Future<void> _registerAssistant() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authService.registerAssistant(
          code: _codeController.text,
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
          phone: _phoneController.text,
          teacherCode: _teacherCodeController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Assistant registered successfully')),
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
        title: Text('Add New Assistant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
              SizedBox(height: 16),
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
              SizedBox(height: 16),
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
              SizedBox(height: 16),
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
              SizedBox(height: 16),
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
              SizedBox(height: 16),
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
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _registerAssistant,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text('Add'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
