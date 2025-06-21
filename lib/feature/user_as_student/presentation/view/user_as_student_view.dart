import 'package:Ahmed_Hamed_lecture/constant.dart';
import 'package:Ahmed_Hamed_lecture/feature/settings/presentation/view/settings_view.dart';
import 'package:Ahmed_Hamed_lecture/feature/user_as_student/presentation/view/widgets/user_as_student_view_body.dart';
import 'package:Ahmed_Hamed_lecture/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


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
              icon: Icon(Icons.home, size: 32),
              label: LocaleKeys.home.tr(),
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
