import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:video_player_app/feature/settings/presentation/view/settings_view.dart';
import 'package:video_player_app/feature/user_as_student/presentation/view/widgets/user_as_student_view_body.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class UserAsStudentView extends StatefulWidget {
  const UserAsStudentView({super.key});

  @override
  State<UserAsStudentView> createState() => _TeacherHomeViewState();
}

class _TeacherHomeViewState extends State<UserAsStudentView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [UserAsStudentViewBody(), SettingsView()];

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
              icon: Icon(Icons.home),
              label: LocaleKeys.home.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: LocaleKeys.settings.tr(),
            ),
          ],
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
        ));
  }
}
