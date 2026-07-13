import 'package:flutter/material.dart';

class AdminHrActionsCard extends StatelessWidget {
  const AdminHrActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Admin Actions",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 20),

          _button(
            icon: Icons.edit_outlined,
            title: "Edit HR Profile",
            onPressed: () {},
          ),

          const SizedBox(height: 12),

          _button(
            icon: Icons.lock_reset,
            title: "Reset Password",
            onPressed: () {},
          ),

          const SizedBox(height: 12),

          _button(
            icon: Icons.admin_panel_settings_outlined,
            title: "Manage Permissions",
            onPressed: () {},
          ),

          const SizedBox(height: 12),

          _button(
            icon: Icons.person_off_outlined,
            title: "Deactivate HR",
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _button({
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 18),
        label: Text(title),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0B1633),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
