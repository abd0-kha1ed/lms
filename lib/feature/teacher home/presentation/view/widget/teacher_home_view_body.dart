import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/utils/app_router.dart';
import 'package:video_player_app/feature/teacher%20home/presentation/view/widget/add_video_button.dart';
import 'package:video_player_app/feature/teacher%20home/presentation/view/widget/grade_list_view.dart';
import 'package:video_player_app/feature/teacher%20home/presentation/view/widget/video_item_list_view.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class TeacherHomeViewBody extends StatelessWidget {
  const TeacherHomeViewBody({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                LocaleKeys.welcome.tr(),
                style: TextStyle(fontSize: 24, color: kPrimaryColor),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 10),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: (){}, icon: Icon(Icons.refresh)),
                Text(
                  'Abdo Khaled',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 30),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AddVideoButton(
                  title: LocaleKeys.addNewVideo.tr(),
                  color: Colors.black,
                  onTap: () {
                    GoRouter.of(context).push(AppRouter.kAddNewVideoView);
                  },
                ),
                AddVideoButton(
                  title: LocaleKeys.addNewEncryptedVideo.tr(),
                  color: Colors.teal,
                  onTap: () {
                    GoRouter.of(context).push(AppRouter.kAddEncryptedVideoView);
                  },
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 20),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
              height: 30,
              child: Padding(
                padding: const EdgeInsets.only(left: 18),
                child: HorizontalButtonList(
                  items: [
                    LocaleKeys.allGrades.tr(),
                    LocaleKeys.twelve.tr(),
                    LocaleKeys.eleven.tr(),
                    LocaleKeys.ten.tr(),
                    LocaleKeys.nine.tr(),
                    LocaleKeys.eight.tr(),
                    LocaleKeys.seven.tr(),
                  ],
                ),
              )),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 10),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
              height: 30,
              child: Padding(
                padding: const EdgeInsets.only(left: 18),
                child: HorizontalButtonList(
                  items: [
                    LocaleKeys.both.tr(),
                    LocaleKeys.encrypted.tr(),
                    LocaleKeys.open.tr(),
                  ],
                ),
              )),
        ),
        SliverToBoxAdapter(
          child: VideoItemListView(),
        )
      ],
    );
  }
}
