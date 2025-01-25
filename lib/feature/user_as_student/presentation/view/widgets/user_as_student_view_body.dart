import 'package:flutter/material.dart';

class UserAsStudentViewBody extends StatelessWidget {
  const UserAsStudentViewBody({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Student ',
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
