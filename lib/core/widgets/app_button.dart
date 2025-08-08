import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;
  final double height;
  final double fontSize;
  final FontWeight fontWeight;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.blueAccent,
    this.borderRadius = 14,
    this.height = 55,
    this.fontSize = 18,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 5,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
        ),
      ),
    );
  }
}
