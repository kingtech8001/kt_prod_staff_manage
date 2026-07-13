import 'package:flutter/material.dart';
import 'hr_directory/hr_list_card.dart';
import 'hr_directory/hr_quick_actions_card.dart';
import 'hr_directory/hr_stats_row.dart';

class HrManagementView extends StatelessWidget {
  const HrManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage HR Staff',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 20),

          const HrStatsRow(),

          const SizedBox(height: 24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'HR Staff',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const HrListCard(),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              const Expanded(flex: 1, child: HrQuickActionsCard()),
            ],
          ),
        ],
      ),
    );
  }
}
