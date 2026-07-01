import 'package:flutter/material.dart';

class ViewAllButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const ViewAllButton({
    super.key,
    required this.onPressed,
    this.text = 'View All',
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
