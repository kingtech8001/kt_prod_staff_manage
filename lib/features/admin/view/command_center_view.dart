import 'package:flutter/material.dart';

class CommandCenterView extends StatelessWidget {
  const CommandCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          const Text(
            'Executive Command Center',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 8),

          const Text(
            'Global workforce monitoring and administrative oversight',
            style: TextStyle(color: Color(0xFF64748B)),
          ),

          const SizedBox(height: 28),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// LEFT SIDE
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Expanded(
                          child: _StatCard(
                            title: 'Total Employees',
                            value: '124',
                            icon: Icons.people_outline,
                          ),
                        ),

                        SizedBox(width: 16),

                        Expanded(
                          child: _StatCard(
                            title: 'HR Managers',
                            value: '8',
                            icon: Icons.badge_outlined,
                          ),
                        ),

                        SizedBox(width: 16),

                        Expanded(
                          child: _StatCard(
                            title: 'Present Today',
                            value: '118',
                            icon: Icons.check_circle_outline,
                          ),
                        ),

                        SizedBox(width: 16),

                        Expanded(
                          child: _StatCard(
                            title: 'Pending Leaves',
                            value: '5',
                            icon: Icons.event_note_outlined,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    _sectionCard(
                      title: 'Executive Insights',
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('• Workforce attendance remains above 95%'),
                          SizedBox(height: 12),
                          Text('• Leave approvals decreased by 8% this month'),
                          SizedBox(height: 12),
                          Text('• No critical compliance issues detected'),
                          SizedBox(height: 12),
                          Text('• Employee retention remains stable'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WorkforceOverviewCard(),

                        SizedBox(width: 24),

                        ComplianceMonitoringCard(),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              /// RIGHT SIDE
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _sectionCard(
                      title: 'Critical Alerts',
                      width: double.infinity,
                      child: const Column(
                        children: [
                          _AlertTile(text: '5 leave requests require review'),

                          SizedBox(height: 12),

                          _AlertTile(text: '2 inactive employee accounts'),

                          SizedBox(height: 12),

                          _AlertTile(text: 'HR role audit pending'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    _sectionCard(
                      title: 'Recent HR Activity',
                      width: double.infinity,
                      child: Column(
                        children: const [
                          RecentActivityTile(
                            avatar: 'S',
                            name: 'Sarah Jenkins',
                            action: 'Approved Leave',
                            time: '5 min ago',
                          ),

                          SizedBox(height: 18),

                          RecentActivityTile(
                            avatar: 'M',
                            name: 'Michael Chen',
                            action: 'Onboarded New Employee',
                            time: '42 min ago',
                          ),

                          SizedBox(height: 18),

                          RecentActivityTile(
                            avatar: 'A',
                            name: 'Admin',
                            action: 'Updated HR Policy',
                            time: '2 hrs ago',
                          ),

                          SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: null,
                              child: Text('View All Activity'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _sectionCard({
    required String title,
    required Widget child,
    required double width,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 20),

          child,
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        mainAxisAlignment: .start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),

          const SizedBox(height: 16),

          Text(
            value,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(title, style: const TextStyle(color: Color(0xFF64748B))),
        ],
      ),
    );
  }
}

class RecentActivityTile extends StatelessWidget {
  final String avatar;
  final String name;
  final String action;
  final String time;

  const RecentActivityTile({
    super.key,
    required this.avatar,
    required this.name,
    required this.action,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xFFE9EDF5),
          child: Text(
            avatar,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B1633),
            ),
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                action,
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),

        Text(
          time,
          style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
        ),
      ],
    );
  }
}

class _AlertTile extends StatelessWidget {
  final String text;

  const _AlertTile({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange),

          const SizedBox(width: 12),

          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class WorkforceOverviewCard extends StatelessWidget {
  const WorkforceOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Workforce Overview',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),

          SizedBox(height: 24),

          _OverviewRow('Active Employees', '124'),
          SizedBox(height: 18),

          _OverviewRow('HR Managers', '8'),
          SizedBox(height: 18),

          _OverviewRow('Employees Present', '118'),
          SizedBox(height: 18),

          _OverviewRow('Pending Leaves', '5'),
          SizedBox(height: 18),

          _OverviewRow('Inactive Accounts', '2'),
        ],
      ),
    );
  }
}

class _OverviewRow extends StatelessWidget {
  final String title;
  final String value;

  const _OverviewRow(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 15),
          ),
        ),

        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ],
    );
  }
}

class ComplianceMonitoringCard extends StatelessWidget {
  const ComplianceMonitoringCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Compliance Monitoring',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),

          SizedBox(height: 24),

          _ProgressItem(
            title: 'Attendance Compliance',
            value: 0.95,
            percent: '95%',
            color: Color(0xFF10B981),
          ),

          SizedBox(height: 20),

          _ProgressItem(
            title: 'Leave Compliance',
            value: 0.88,
            percent: '88%',
            color: Color(0xFF6366F1),
          ),

          SizedBox(height: 20),

          _ProgressItem(
            title: 'Employee Profiles',
            value: 0.98,
            percent: '98%',
            color: Color(0xFF3B82F6),
          ),

          SizedBox(height: 20),

          _ProgressItem(
            title: 'HR Audits',
            value: 0.72,
            percent: '72%',
            color: Color(0xFFF59E0B),
          ),
        ],
      ),
    );
  }
}

class _ProgressItem extends StatelessWidget {
  final String title;
  final double value;
  final String percent;
  final Color color;

  const _ProgressItem({
    required this.title,
    required this.value,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Color(0xFF64748B)),
              ),
            ),

            Text(percent, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),

        const SizedBox(height: 8),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: const Color(0xFFF1F5F9),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}
