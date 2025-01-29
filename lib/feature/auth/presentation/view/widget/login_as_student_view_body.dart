// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/services/auth_services.dart';
import 'package:video_player_app/core/utils/app_router.dart';
import 'package:video_player_app/core/widget/custom_button.dart';
import 'package:video_player_app/core/widget/custom_text_form_field.dart';
import 'package:video_player_app/feature/auth/presentation/view/widget/code_video_directly.dart';
import 'package:video_player_app/feature/secure%20code/presentation/view/manger/codes%20cubit/codes_cubit.dart';
import 'package:video_player_app/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class LoginAsStudentViewBody extends StatefulWidget {
  const LoginAsStudentViewBody({super.key});

  @override
  State<LoginAsStudentViewBody> createState() => _LoginAsStudentViewBodyState();
}

class _LoginAsStudentViewBodyState extends State<LoginAsStudentViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? code, password;
  bool _isPasswordVisible = false;
  bool _isLoading = false; // Loading state for login button

  final FirebaseServices _authService = FirebaseServices();

  Future<void> login(BuildContext context, String code, String password) async {
    if (!formKey.currentState!.validate()) {
      return; // Form is not valid
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      Map<String, dynamic>? userData =
          await _authService.signInWithCodeAndPassword(code, password, context);

      if (userData != null) {
        String role = userData['role'];
        if (role == 'student') {
          GoRouter.of(context).go(AppRouter.kUserAsStudentView);
        } else {
          // Role not recognized
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(LocaleKeys.noCodeWasFound.tr())),
          );
        }
      }
    } catch (e) {
      // Log and display the error

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.noCodeWasFound.tr())),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: ListView(
          children: [
            const SizedBox(height: 100),
            Icon(FontAwesomeIcons.video, color: kPrimaryColor, size: 120),
            const SizedBox(height: 20),
            Center(
              child: Text(
                LocaleKeys.myLectures
                    .tr(), // Replace with localization key if required
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 35),
            CustomTextFormField(
              keyboardType: TextInputType.number,
              hintText: LocaleKeys.enterYourCode
                  .tr(), // Replace with localization key if required
              onChanged: (value) {
                code = value;
              },
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return "Please enter your code.";
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            CustomTextFormField(
              hintText: LocaleKeys.enterYourPassword
                  .tr(), // Replace with localization key if required
              onChanged: (value) {
                password = value;
              },
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return "Please enter your password.";
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              suffixIcon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: kPrimaryColor,
              ),
              onTapSuffixIcon: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 30),
            _isLoading
                ? Center(child: const CircularProgressIndicator())
                : CustomButton(
                    color: kPrimaryColor,
                    title: LocaleKeys.login
                        .tr(), // Replace with localization key if required
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        await login(context, code!, password!);
                      }
                      context.read<VideoCubit>().fetchVideos();
                    },
                  ),
            const SizedBox(height: 30),
            TextButton(
                onPressed: () {
                  showCodeBottomSheet(context);
                },
                style: ButtonStyle(
                    foregroundColor: WidgetStatePropertyAll(kPrimaryColor)),
                child: Text(LocaleKeys.useVideoCode)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Login as "),
                GestureDetector(
                  onTap: () =>
                      GoRouter.of(context).push(AppRouter.kTeacherLoginView),
                  child: Text(
                    "Teacher",
                    style: TextStyle(
                      fontSize: 16,
                      color: kPrimaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const Text(" or "),
                GestureDetector(
                  onTap: () =>
                      GoRouter.of(context).push(AppRouter.kAssistantLoginView),
                  child: Text(
                    "Assistant",
                    style: TextStyle(
                      fontSize: 16,
                      color: kPrimaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


Future<String> getDeviceId() async {
  final deviceInfo = DeviceInfoPlugin();
  String deviceId = "unknown-device";

  try {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id; // معرف الجهاز للأندرويد
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? "unknown-ios-device"; // معرف الجهاز للـ iOS
    }
  } catch (e) {
    print("🔴 خطأ في جلب معرف الجهاز: $e");
  }

  return deviceId;
}
  Future<dynamic> showCodeBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true, 
    builder: (BuildContext context) {
      return BlocProvider.value(
        value: context.read<CodesCubit>(), // ✅ الاحتفاظ بنفس Cubit
        child: BlocConsumer<CodesCubit, CodesState>(
          listener: (context, state) async {
            final deviceId = await getDeviceId(); // ✅ الحصول على deviceId

            if (state is CodeValid) {
              // ✅ التحقق من الجلسة قبل بدء جلسة جديدة
              context.read<CodesCubit>().checkSession(state.videoUrl, deviceId);
            } else if (state is CodeSessionActive) {
              final videoUrl = state.videoUrl;
              final sessionEndTime = state.sessionEndTime.toDate();

              if (DateTime.now().isBefore(sessionEndTime)) {
                // ✅ السماح بمشاهدة الفيديو
                GoRouter.of(context).pop();
                GoRouter.of(context).go(
                  AppRouter.kVideoViewWithDirectCode,
                  extra: videoUrl,
                );
              } else {
                alertShowDialog(context); // ❌ الجلسة منتهية
              }
            } else if (state is CodeSessionExpired) {
              alertShowDialog(context);
            } else if (state is CodeInvalid) {
              showInvalidCodeDialog(context);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: CodeVideoDirectly(), // ✅ استدعاء واجهة إدخال الكود
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
Future<void> showInvalidCodeDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text('Invalid Code'),
            ],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'This code has been used or is incorrect. Please try again.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Image.network(
              'https://cdn-icons-png.flaticon.com/512/190/190406.png',
              height: 80,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Dismiss'),
          ),
        ],
      );
    },
  );
}

Future<dynamic> alertShowDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text('Session Expired'),
            ],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your session has expired. Please try again.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Image.network(
              'https://cdn-icons-png.flaticon.com/512/190/190406.png',
              height: 80,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Dismiss'),
          ),
        ],
      );
    },
  );
}}
