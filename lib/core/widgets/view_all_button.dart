import 'package:flutter/material.dart';

class ViewAllButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool bgColor;

  const ViewAllButton({
    super.key,
    required this.onPressed,
    this.text = 'View All',
    this.bgColor = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: bgColor ? Colors.black : Color(0xFF64748b),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
