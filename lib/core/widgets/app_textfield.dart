import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final IconData prefixIcon;
  final TextEditingController? controller;
  final String? initialValue;

  const AppTextField({super.key, required this.hint, required this.prefixIcon, this.obscureText = false, this.controller, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(prefixIcon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
