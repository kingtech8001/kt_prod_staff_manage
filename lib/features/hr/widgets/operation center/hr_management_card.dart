import 'package:flutter/material.dart';

import 'dialogs/attendance_rules_dialog.dart';
import 'dialogs/company_announcement_dialog.dart';
import 'dialogs/holiday_management_dialog.dart';

class HrManagementCard extends StatelessWidget {
  const HrManagementCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            "HR Management",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 24),

          Expanded(
            child: Column(
              children: [
                _ManagementTile(
                  icon: Icons.calendar_month_rounded,
                  title: "Holiday Management",
                  subtitle: "Manage company holidays",
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => const HolidayManagementDialog(),
                    );
                  },
                ),

                const SizedBox(height: 12),

                _ManagementTile(
                  icon: Icons.rule_folder_outlined,
                  title: "Attendance Rules",
                  subtitle: "Configure attendance settings",
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => const AttendanceRulesDialog(),
                    );
                  },
                ),

                const SizedBox(height: 12),

                _ManagementTile(
                  icon: Icons.campaign_outlined,
                  title: "Company Announcements",
                  subtitle: "Publish announcements",
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => const CompanyAnnouncementDialog(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ManagementTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ManagementTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: const Color(0xFF2563EB)),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }
}
