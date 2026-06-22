import 'package:flutter/material.dart';

class CommandCenterView extends StatelessWidget {
  const CommandCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Executive Command Center', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),

          const SizedBox(height: 8),

          const Text('Global workforce monitoring and administrative oversight', style: TextStyle(color: Color(0xFF64748B))),

          const SizedBox(height: 28),

          const Row(
            children: [
              Expanded(
                child: _StatCard(title: 'Total Employees', value: '124', icon: Icons.people_outline),
              ),

              SizedBox(width: 16),

              Expanded(
                child: _StatCard(title: 'HR Managers', value: '8', icon: Icons.badge_outlined),
              ),

              SizedBox(width: 16),

              Expanded(
                child: _StatCard(title: 'Present Today', value: '118', icon: Icons.check_circle_outline),
              ),

              SizedBox(width: 16),

              Expanded(
                child: _StatCard(title: 'Pending Leaves', value: '5', icon: Icons.event_note_outlined),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _sectionCard(
                  title: 'Recent Administrative Activity',
                  child: Column(
                    children: const [
                      _ActivityTile(title: 'New Employee Added', subtitle: 'HR Department'),
                      _ActivityTile(title: 'Leave Request Approved', subtitle: 'Employee Management'),
                      _ActivityTile(title: 'Attendance Updated', subtitle: 'Operations'),
                      _ActivityTile(title: 'Role Permission Changed', subtitle: 'Access Control'),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 24),

              Expanded(
                child: _sectionCard(
                  title: 'Critical Alerts',
                  child: Column(
                    children: const [
                      _AlertTile(text: '5 leave requests require review'),
                      SizedBox(height: 12),
                      _AlertTile(text: '2 inactive employee accounts'),
                      SizedBox(height: 12),
                      _AlertTile(text: 'HR role audit pending'),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          _sectionCard(
            title: 'Executive Insights',
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
        ],
      ),
    );
  }

  static Widget _sectionCard({required String title, required Widget child}) {
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
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),

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

  const _StatCard({required this.title, required this.value, required this.icon});

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
          Icon(icon),

          const SizedBox(height: 16),

          Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),

          const SizedBox(height: 6),

          Text(title, style: const TextStyle(color: Color(0xFF64748B))),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ActivityTile({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(child: Icon(Icons.history)),
      title: Text(title),
      subtitle: Text(subtitle),
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
      decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(12)),
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
