import 'package:flutter/material.dart';

class CompanyAnnouncementsCard extends StatelessWidget {
  const CompanyAnnouncementsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Company Announcements',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
          ),

          const SizedBox(height: 24),

          _announcementItem(
            icon: Icons.campaign_outlined,
            iconColor: Colors.blue,
            title: 'New Remote Work Policy',
            description: 'Updated guidelines for hybrid schedules are now available.',
          ),

          const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Divider(height: 1)),

          _announcementItem(
            icon: Icons.groups_2_outlined,
            iconColor: Color(0xFF0F172A),
            title: 'System Maintenance',
            description: 'Internal portal will be offline this Sunday at 2 AM.',
          ),
        ],
      ),
    );
  }

  Widget _announcementItem({required IconData icon, required Color iconColor, required String title, required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 22),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
              ),

              const SizedBox(height: 8),

              Text(description, style: const TextStyle(fontSize: 15, color: Color(0xFF64748B), height: 1.5)),
            ],
          ),
        ),
      ],
    );
  }
}
