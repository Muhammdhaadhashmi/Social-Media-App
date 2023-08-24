import 'package:flutter/material.dart';

class CommonTextfieldConst extends StatelessWidget {
  String hintText;
  bool padding;
  final bool? obscureText;
  final TextEditingController? controller;
  final Icon? prefixIcon;
  final ValueChanged<String>? onChanged;
  CommonTextfieldConst({
    required this.hintText,
    required this.padding,
    super.key, this.controller, required this.obscureText, this.prefixIcon, this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: padding ? 12 : 0 ),
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        obscureText: obscureText??false,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          fillColor: const Color(0xFF1c2a33),
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFF495967),
              width: 0.0,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.white24,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          focusColor: const Color(0xFF495967),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFF495967),
              width: 0.0,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
