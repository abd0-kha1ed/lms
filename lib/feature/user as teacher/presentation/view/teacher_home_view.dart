import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/feature/assistant/presentation/view/assistants_view.dart';
import 'package:video_player_app/feature/report/presentation/view/report_view.dart';
import 'package:video_player_app/feature/settings/presentation/view/settings_view.dart';
import 'package:video_player_app/feature/user%20as%20teacher/presentation/view/widget/teacher_home_view_body.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class TeacherHomeView extends StatefulWidget {
  const TeacherHomeView({super.key});

  @override
  State<TeacherHomeView> createState() => _TeacherHomeViewState();
}

class _TeacherHomeViewState extends State<TeacherHomeView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    TeacherHomeViewBody(),
    AssistantsView(),
    ReportView(),
    SettingsView()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 32),
              label: LocaleKeys.home.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group, size: 32),
              label: LocaleKeys.assistants.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article, size: 32),
              label: LocaleKeys.reports.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, size: 32),
              label: LocaleKeys.settings.tr(),
            ),
          ],
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: Colors.grey,
        ));
  }
}
