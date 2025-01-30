import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/utils/app_router.dart';
import 'package:video_player_app/core/widget/custom_button.dart';
import 'package:video_player_app/feature/secure%20code/presentation/view/manger/codes%20cubit/codes_cubit.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class CodeVideoDirectly extends StatefulWidget {
  const CodeVideoDirectly({super.key});

  @override
  State<CodeVideoDirectly> createState() => _CodeVideoDirectlyState();
}

class _CodeVideoDirectlyState extends State<CodeVideoDirectly> {
  TextEditingController codeController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? code;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<CodesCubit>(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: formKey,
          autovalidateMode: autovalidateMode,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(LocaleKeys.code.tr(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                      onPressed: () {
                        GoRouter.of(context).pop();
                      },
                      icon: Icon(Icons.close, color: Colors.red),
                      iconSize: 30)
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  code = value;
                },
                validator: (value) {
                  if (code?.isEmpty ?? true) {
                    return LocaleKeys.enterYourCode.tr();
                  } else {
                    return null;
                  }
                },
                controller: codeController,
                decoration: InputDecoration(
                  hintText: LocaleKeys.enterSecretCode.tr(),
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kPrimaryColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              BlocConsumer<CodesCubit, CodesState>(
                listener: (context, state) async {
                  if (state is CodeInvalid) {
                    alertShowDialog(context, 'Invalid Code',
                        'This code has been used or is incorrect. Please try again.');
                  } else if (state is CodeVerificationError) {
                    alertShowDialog(context, 'Alert', state.message);
                  } else if (state is CodeSessionActive) {
                    final videoUrl = state.videoUrl;
                    //  GoRouter.of(context).pop();
                    GoRouter.of(context).push(
                      AppRouter.kVideoViewWithDirectCode,
                      extra: videoUrl,
                    );
                  } else if (state is CodeSessionExpired) {
                    alertShowDialog(context, 'Session Expired',
                        'Your session has expired. Please try again.');
                  }
                },
                builder: (context, state) {
                  bool isLoading = state is CodeVerificationLoading;

                  return CustomButton(
                      color: isLoading ? Colors.grey : kPrimaryColor,
                      title: isLoading
                          ? 'Loading...'
                          : LocaleKeys.confirmText.tr(),
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          final enteredCode = codeController.text.trim();

                          await context
                              .read<CodesCubit>()
                              .startSession(enteredCode);
                        } else {
                          autovalidateMode = AutovalidateMode.always;
                          setState(() {});
                        }
                      });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<dynamic> alertShowDialog(
    BuildContext context, String title, String content) {
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
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 30,
              ),
              SizedBox(width: 8),
              Text(title),
            ],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              content,
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
