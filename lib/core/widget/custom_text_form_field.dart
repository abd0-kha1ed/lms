import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      required this.hintText,
      this.onChanged,
      this.onTapSuffixIcon,
      this.suffixIcon,
       this.obscureText=false,
      this.validator});
  final String hintText;
  final void Function(String)? onChanged;
  final void Function()? onTapSuffixIcon;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
          suffixIcon: suffixIcon != null
              ? GestureDetector(
                  onTap: onTapSuffixIcon,
                  child: suffixIcon,
                )
              : null,
          border: buildBorder(Colors.black),
          enabledBorder: buildBorder(Colors.black),
          focusedBorder: buildBorder(Colors.blue),
          errorBorder: buildBorder(Colors.red),
          hintText: hintText),
    );
  }

  OutlineInputBorder buildBorder(Color borderColor) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: borderColor));
}
