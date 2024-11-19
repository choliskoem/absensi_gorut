import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {Key? key, required this.color, required this.centerText, this.onTap})
      : super(key: key);

  final Color color;
  final Widget centerText;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
         backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(89))),
      onPressed: onTap,
      child: centerText,
    );
  }
}
