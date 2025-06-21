import 'package:Ahmed_Hamed_lecture/core/services/auth_services.dart';
import 'package:Ahmed_Hamed_lecture/feature/secure%20video/presentation/view/manger/secure%20video/video_cubit.dart';
import 'package:Ahmed_Hamed_lecture/feature/secure%20video/presentation/view/widget/add_new_video_body.dart';
import 'package:Ahmed_Hamed_lecture/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewVideo extends StatelessWidget {
  const AddNewVideo({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.createVideo.tr()),
      ),
      body: BlocProvider(
        create: (context) => VideoCubit(FirebaseServices()),
        child: AddNewVideoBody(),
      ),
    );
  }
}
