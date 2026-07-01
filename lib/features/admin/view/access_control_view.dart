import 'package:flutter/material.dart';
import 'package:staff_managememt_system/core/constants/app_colors.dart';

class AccessControlView extends StatelessWidget {
  const AccessControlView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Access Control',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 8),

          const Text(
            'Manage global configurations and granular role-based access control.',
            style: TextStyle(color: Color(0xFF64748B)),
          ),

          const SizedBox(height: 28),

          const Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Total Roles',
                  value: '8',
                  subtitle: '+1%',
                  icon: Icons.grid_view_rounded,
                  positive: true,
                ),
              ),

              SizedBox(width: 16),

              Expanded(
                child: _StatCard(
                  title: 'Active Users',
                  value: '886',
                  subtitle: '+12%',
                  icon: Icons.person,
                  positive: true,
                ),
              ),

              SizedBox(width: 16),

              Expanded(
                child: _StatCard(
                  title: 'Custom Roles',
                  value: '3',
                  subtitle: '0%',
                  icon: Icons.tune,
                  positive: false,
                ),
              ),

              SizedBox(width: 16),

              Expanded(
                child: _StatCard(
                  title: 'System Roles',
                  value: '5',
                  subtitle: 'Fixed',
                  icon: Icons.settings,
                  positive: false,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: const [
                    AccessRolesCard(),

                    SizedBox(height: 24),

                    RoleAuditCard(),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              const Expanded(flex: 3, child: PermissionPanel()),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final bool positive;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              Icon(icon, color: const Color(0xFF2563EB)),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            value,
            style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            subtitle,
            style: TextStyle(
              color: positive ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class AccessRolesCard extends StatelessWidget {
  const AccessRolesCard({super.key});

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
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Access Roles',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
              ),

              TextButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.black),
                ),
                onPressed: () {},
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'New Role',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const RoleTile(
            title: 'Administrator',
            description: 'Full system access and global configuration',
            users: '4 Users',
            icon: Icons.admin_panel_settings_outlined,
            selected: true,
          ),

          const SizedBox(height: 12),

          const RoleTile(
            title: 'HR Manager',
            description: 'Employee records and workforce management',
            users: '12 Users',
            icon: Icons.badge_outlined,
          ),

          const SizedBox(height: 12),

          const RoleTile(
            title: 'Department Head',
            description: 'Team management and leave approvals',
            users: '28 Users',
            icon: Icons.groups_outlined,
          ),

          const SizedBox(height: 12),

          const RoleTile(
            title: 'Standard Employee',
            description: 'Self service and attendance',
            users: '842 Users',
            icon: Icons.person_outline,
          ),
        ],
      ),
    );
  }
}

class RoleTile extends StatelessWidget {
  final String title;
  final String description;
  final String users;
  final IconData icon;
  final bool selected;

  const RoleTile({
    super.key,
    required this.title,
    required this.description,
    required this.users,
    required this.icon,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFF0F172A) : const Color(0xFFE5E7EB),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: const Color(0xFF475569)),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    description,
                    style: const TextStyle(color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  users,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 12),

                if (selected)
                  const Icon(Icons.check_circle, color: Color(0xFF0F172A)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RoleAuditCard extends StatelessWidget {
  const RoleAuditCard({super.key});

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
            'Role Audit Trail',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 20),

          const _AuditItem(
            title: 'Last Permission Change',
            value: '2 hours ago',
            icon: Icons.history,
          ),

          const SizedBox(height: 18),

          const _AuditItem(
            title: 'Changed By',
            value: 'Admin User',
            icon: Icons.person_outline,
          ),

          const SizedBox(height: 18),

          const _AuditItem(
            title: 'Role Created',
            value: 'Jan 12, 2026',
            icon: Icons.calendar_today_outlined,
          ),

          const SizedBox(height: 18),

          const _AuditItem(
            title: 'Last Updated',
            value: 'Today',
            icon: Icons.update,
          ),
        ],
      ),
    );
  }
}

class _AuditItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _AuditItem({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF475569)),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
              ),

              const SizedBox(height: 4),

              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PermissionPanel extends StatelessWidget {
  const PermissionPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Administrator Permissions',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'System Role',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const PermissionSection(
              title: 'User Management',
              children: [
                PermissionTile(
                  title: 'Create Employee Accounts',
                  description: 'Allow creating new employee accounts.',
                ),
                PermissionTile(
                  title: 'Edit Employee Profiles',
                  description: 'Allow editing employee information.',
                ),
                PermissionTile(
                  title: 'Deactivate Employees',
                  description: 'Allow activating/deactivating employees.',
                ),
              ],
            ),

            const SizedBox(height: 24),

            const PermissionSection(
              title: 'Attendance',
              children: [
                PermissionTile(
                  title: 'View Attendance',
                  description: 'Access attendance records.',
                ),
                PermissionTile(
                  title: 'Modify Attendance',
                  description: 'Edit attendance history.',
                ),
                PermissionTile(
                  title: 'Approve Attendance Corrections',
                  description: 'Approve attendance adjustment requests.',
                ),
              ],
            ),

            const SizedBox(height: 24),

            const PermissionSection(
              title: 'Leave Management',
              children: [
                PermissionTile(
                  title: 'Approve Leave',
                  description: 'Approve or reject leave requests.',
                ),
                PermissionTile(
                  title: 'Manage Leave Policies',
                  description: 'Modify leave configurations.',
                ),
              ],
            ),

            const SizedBox(height: 24),

            const PermissionSection(
              title: 'System Administration',
              children: [
                PermissionTile(
                  title: 'Manage Roles',
                  description: 'Create or modify system roles.',
                ),
                PermissionTile(
                  title: 'View Audit Logs',
                  description: 'Access complete audit history.',
                ),
                PermissionTile(
                  title: 'System Settings',
                  description: 'Modify global application settings.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PermissionSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const PermissionSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 18),

          ...children,
        ],
      ),
    );
  }
}

class PermissionTile extends StatefulWidget {
  final String title;
  final String description;

  const PermissionTile({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  State<PermissionTile> createState() => _PermissionTileState();
}

class _PermissionTileState extends State<PermissionTile> {
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  widget.description,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: enabled,
            activeTrackColor: Colors.black,
            onChanged: (value) {
              setState(() {
                enabled = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
