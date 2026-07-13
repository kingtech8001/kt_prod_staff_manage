import 'package:flutter/material.dart';

import '../../widgets/operation center/hr_management_card.dart';
import '../../widgets/operation center/live_activity_card.dart';
import '../../widgets/operation center/attention_card.dart';
import '../../widgets/operation center/hr_stat_card.dart';
import '../../widgets/operation center/pending_leave_card.dart';

class OperationsCenterView extends StatelessWidget {
  const OperationsCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F7FA),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Operations Center',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: HrStatCard(
                    title: 'Employees Present',
                    value: '124',
                    subtitle: "Today's attendance",
                    icon: Icons.people,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: HrStatCard(
                    title: 'Late Arrivals',
                    value: '8',
                    subtitle: 'Today',
                    icon: Icons.access_time,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: HrStatCard(
                    title: 'On Leave',
                    value: '5',
                    subtitle: 'Approved',
                    icon: Icons.event_busy,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: HrStatCard(
                    title: 'Attendance',
                    value: '92%',
                    subtitle: 'attendance status',
                    icon: Icons.people,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LEFT SIDE
                Expanded(
                  flex: 7,
                  child: Column(
                    children: [
                      Container(
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
                              'Immediate Attention Required',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 24),

                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 220,
                                    child: AttentionCard(
                                      title: 'Missing Punch Out',
                                      description:
                                          '3 employees forgot to punch out yesterday.',
                                      actionText: 'Review',
                                      icon: Icons.logout,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 16),

                                Expanded(
                                  child: SizedBox(
                                    height: 220,
                                    child: AttentionCard(
                                      title: 'Excessive Overtime',
                                      description:
                                          '2 employees exceeded overtime limits.',
                                      actionText: 'Investigate',
                                      icon: Icons.schedule,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 16),

                                Expanded(
                                  child: SizedBox(
                                    height: 220,
                                    child: AttentionCard(
                                      title: 'Attendance Violation',
                                      description:
                                          'Repeated late arrivals detected.',
                                      actionText: 'View',
                                      icon: Icons.warning_amber,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 16),

                                Expanded(
                                  child: SizedBox(
                                    height: 220,
                                    child: AttentionCard(
                                      title: 'Consecutive Absences',
                                      description:
                                          'Employees absent for multiple days.',
                                      actionText: 'Review',
                                      icon: Icons.person_off,
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      SizedBox(height: 420, child: LiveActivityCard()),
                    ],
                  ),
                ),

                const SizedBox(width: 24),

                // RIGHT SIDE
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      const SizedBox(height: 350, child: PendingLeaveCard()),

                      const SizedBox(height: 24),

                      const SizedBox(height: 400, child: HrManagementCard()),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
