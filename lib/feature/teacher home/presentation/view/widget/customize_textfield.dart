import 'package:flutter/material.dart';

class CustomizeTextfield extends StatelessWidget {
  const CustomizeTextfield(
      {super.key,
      this.onChanged,
      this.validator,
      required this.text,
      required this.color,
      this.maxLines = 1});
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String text;
  final Color color;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: text,
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: color,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
