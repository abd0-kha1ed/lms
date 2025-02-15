// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/widget/custom_text_form_field.dart';
import 'package:video_player_app/feature/auth/data/model/assistant_model.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

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
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _teacherCodeController = TextEditingController();

  Future<void> _registerAssistant() async {
    if (!_formKey.currentState!.validate()) {
      return; // Form not valid
    }

    try {
      // Generate a unique ID for the assistant
      String assistantId =
          FirebaseFirestore.instance.collection('assistants').doc().id;

      // Construct AssistantModel
      final assistant = AssistantModel(
        id: assistantId, // Assign generated ID
        code: _codeController.text.trim(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
        teacherCode: _teacherCodeController.text.trim(),
        lastCheckedInAt: Timestamp.now(),
      );

      // Store the assistant data manually in Firestore
      await FirebaseFirestore.instance
          .collection('assistants')
          .doc(assistantId)
          .set({
        "id": assistantId,
        "role": "assistant",
        ...assistant.toJson(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.assistantAdded.tr())),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(LocaleKeys.addNewAssistant.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextFormField(
                  keyboardType: TextInputType.number,
                  controller: _codeController,
                  hintText: LocaleKeys.code.tr(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.codeRequired.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _nameController,
                  hintText: LocaleKeys.name.tr(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.nameRequired.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _passwordController,
                  hintText: LocaleKeys.password.tr(),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.passwordrequerid.tr();
                    } else if (value.length < 6) {
                      return LocaleKeys.passwordatleast6number;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
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
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _registerAssistant,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      LocaleKeys.add.tr(),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
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
