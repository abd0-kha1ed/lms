import 'package:flutter/material.dart';

class VideoContainer extends StatelessWidget {
  const VideoContainer(
      {super.key, required this.text, required this.color, this.icon});
  final String text;
  final Color color;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8), color: color),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 2),
          Text(text, style: TextStyle(color: Colors.white))
        ],
      ),
    );
  }
}
