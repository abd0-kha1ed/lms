
import 'package:flutter/material.dart';

class CodeItem extends StatelessWidget {
  const CodeItem(
      {super.key,
      required this.title,
      required this.color,
      required this.codeIndex});
  final String title;
  final int codeIndex;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        title: Text(title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        trailing: Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: color),
        ),
        leading: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: Colors.teal),
          child: Text(codeIndex.toString(),
              style: TextStyle(color: Colors.white, fontSize: 14)),
        ),
      ),
    );
  }
}
