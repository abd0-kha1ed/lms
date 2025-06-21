import 'package:Ahmed_Hamed_lecture/constant.dart';
import 'package:Ahmed_Hamed_lecture/feature/report/presentation/view/report_view.dart';
import 'package:Ahmed_Hamed_lecture/feature/settings/presentation/view/settings_view.dart';
import 'package:Ahmed_Hamed_lecture/feature/user%20as%20assistant/presentation/view/widgets/user_as_assistant_view_body.dart';
import 'package:flutter/material.dart';

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
              icon: Icon(Icons.home, size: 32),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article, size: 32),
              label: 'Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, size: 32),
              label: 'Settings',
            ),
          ],
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: Colors.grey,
        ));
  }
}
