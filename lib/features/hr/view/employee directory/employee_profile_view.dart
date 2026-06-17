import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../controller/employee_profile_controller.dart';
import '../../controller/hr_controller.dart';
import '../../widgets/employee_directory/edit_employee_dialog.dart';
import '../../widgets/employee_directory/profile/documents_overview_card.dart';
import '../../widgets/employee_directory/profile/employment_information_card.dart';
import '../../widgets/employee_directory/profile/hr_actions_card.dart';
import '../../widgets/employee_directory/profile/profile_attendance_tab.dart';

final hrController = Get.find<HrController>();

class EmployeeProfileView extends StatelessWidget {
  const EmployeeProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final employee = hrController.selectedEmployee.value;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Obx(() {
        final profileController = Get.find<EmployeeProfileController>();
        final employee = hrController.selectedEmployee.value;

        if (employee == null) return const SizedBox.shrink();
        return Column(
          children: [
            EmployeeProfileHeader(employee: employee),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    _profileHeader(employee),
                    const SizedBox(height: 24),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Obx(
                                () => Row(
                                  children: [
                                    Expanded(child: _statCard('Attendance Rate', '${profileController.attendanceRate.value.toStringAsFixed(1)}%')),

                                    const SizedBox(width: 16),

                                    Expanded(child: _statCard('Late Days', profileController.lateDays.value.toString())),

                                    const SizedBox(width: 16),

                                    Expanded(child: _statCard('Overtime', '${profileController.overtimeHours.value.toStringAsFixed(1)} h')),

                                    const SizedBox(width: 16),

                                    Expanded(child: _statCard('Average Hours', '${profileController.averageHours.value.toStringAsFixed(1)} h')),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              _profileTabs(),

                              const SizedBox(height: 24),

                              Obx(() => _tabContent()),
                            ],
                          ),
                        ),

                        const SizedBox(width: 24),

                        Expanded(
                          child: Column(children: [_recentActivityCard(), const SizedBox(height: 20), const HrActionsCard(), SizedBox(height: 20), DocumentsOverviewCard()]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _profileHeader(Map employee) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 55, child: Text(employee['full_name'].toString().split(' ').map((e) => e[0]).take(2).join())),

          const SizedBox(width: 24),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(employee['full_name'], style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),

                    const SizedBox(width: 12),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: employee['is_active'] == true
                          ? BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(20))
                          : BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        employee['is_active'] == true ? 'Active' : 'Inactive',
                        style: employee['is_active'] == true
                            ? const TextStyle(color: Colors.green, fontWeight: FontWeight.w600)
                            : const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  employee['designation']?.toString().isNotEmpty == true ? employee['designation'] : 'No Designation',
                  style: const TextStyle(fontSize: 18, color: Color(0xFF64748B)),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    const Icon(Icons.email_outlined, size: 18),

                    const SizedBox(width: 8),

                    Text(employee['email']?.toString() ?? '-'),

                    const SizedBox(width: 30),

                    const Icon(Icons.phone_outlined, size: 18),

                    const SizedBox(width: 8),

                    Text(employee['phone']?.toString().isNotEmpty == true ? employee['phone'] : 'No number added!'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentActivityCard() {
    final controller = Get.find<EmployeeProfileController>();

    return Obx(
      () => Container(
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
            const Text('Recent Activity', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),

            const SizedBox(height: 20),

            if (controller.activities.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text('No activity found', style: TextStyle(color: Color(0xFF64748B))),
                ),
              ),

            ...controller.activities
                .take(5)
                .map(
                  (activity) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.history, size: 18, color: Color(0xFF475569)),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(activity['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),

                              const SizedBox(height: 4),

                              Text(DateFormatter.formatDateTime(activity['activity_time']?.toString()), style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _profileTabs() {
    final tabs = ['Overview', 'Attendance'];

    return Obx(
      () => Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: tabs.map((tab) {
            final selected = hrController.selectedTab.value == tab;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => hrController.changeTab(tab),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(color: selected ? const Color(0xFF64748B) : Colors.transparent, borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    tab,
                    style: TextStyle(color: selected ? Colors.white : const Color(0xFF475569), fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _statCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF64748B))),

          const SizedBox(height: 12),

          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _tabContent() {
    if (hrController.selectedTab.value == 'Attendance') {
      return const ProfileAttendanceTab();
    }

    return const EmploymentInformationCard();
  }
}

class EmployeeProfileHeader extends StatelessWidget {
  final Map employee;

  const EmployeeProfileHeader({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HrController>();

    return Container(
      height: 70,
      width: .infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              controller.backToDirectory();
            },
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF334155)),
            ),
          ),

          const SizedBox(width: 12),

          Text(
            'Employee Profile / ${employee['full_name'] ?? ''}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFF111827)),
          ),

          const Spacer(),

          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.chat_bubble_outline, size: 18),
            label: const Text('Message'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(130, 44),
              foregroundColor: const Color(0xFF0F172A),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),

          const SizedBox(width: 12),

          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => EditEmployeeDialog(employee: employee),
              );
            },
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Edit Profile'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(150, 44),
              backgroundColor: const Color(0xFF0B1633),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),

          const SizedBox(width: 12),

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz, color: Color(0xFF0F172A)),
          ),
        ],
      ),
    );
  }
}
