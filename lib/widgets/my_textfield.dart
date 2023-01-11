import 'package:absensi/common/my_color.dart';
import 'package:absensi/common/my_typhography.dart';
import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  const MyTextfield(
      {Key? key,
      required this.prefixIcon,
      required this.hintText,
      this.suffixIcon,
      this.obsecureText,
      required this.controller})
      : super(key: key);

  final TextEditingController controller;
  final Widget prefixIcon;
  final String hintText;
  final Widget? suffixIcon;
  final bool? obsecureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obsecureText ?? false,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: MyTyphography.texfield,
        fillColor: Colors.white,
        filled: true,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MyColor.orange1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MyColor.orange1),
        ),
      ),
    );
  }
}
