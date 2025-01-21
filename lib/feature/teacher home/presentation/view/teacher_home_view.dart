import 'package:flutter/material.dart';
import 'package:video_player_app/feature/assistant/presentation/view/assistants_view.dart';
import 'package:video_player_app/feature/report/presentation/view/report_view.dart';
import 'package:video_player_app/feature/settings/presentation/view/settings_view.dart';
import 'package:video_player_app/feature/teacher%20home/presentation/view/widget/teacher_home_view_body.dart';

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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Assistants',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
        ));
  }
}
