
import 'package:Ahmed_Hamed_lecture/constant.dart';
import 'package:flutter/material.dart';

class CustomLoginContainer extends StatelessWidget {
  const CustomLoginContainer(
      {super.key, required this.title, required this.icon});
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
              color: kPrimaryColor, borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 25),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}