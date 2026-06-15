import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class DocumentsOverviewCard extends StatelessWidget {
  const DocumentsOverviewCard({super.key});

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
          const Text('Documents Overview', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),

          const SizedBox(height: 20),

          _documentTile(Icons.description_outlined, 'Employment Contract'),

          _documentTile(Icons.assignment_outlined, 'Offer Letter'),

          _documentTile(Icons.policy_outlined, 'Policy Acknowledgements'),

          _documentTile(Icons.workspace_premium_outlined, 'Certificates'),
        ],
      ),
    );
  }

  Widget _documentTile(IconData icon, String title) {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.primary),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.white),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
