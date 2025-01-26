import 'package:flutter/material.dart';

import 'package:video_player_app/feature/report/presentation/view/report_view.dart';
import 'package:video_player_app/feature/settings/presentation/view/settings_view.dart';
import 'package:video_player_app/feature/user%20as%20assistant/presentation/view/widgets/user_as_assistant_view_body.dart';

class UserAsAssistantView extends StatefulWidget {
  const UserAsAssistantView({super.key});

  @override
  State<UserAsAssistantView> createState() => _UserAsAssistantViewState();
}

class _UserAsAssistantViewState extends State<UserAsAssistantView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    UserAsAssistantViewBody(),
    ReportView(),
    SettingsView(),
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
