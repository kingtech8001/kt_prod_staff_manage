import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/employee_profile_controller.dart';
import '../../controller/hr_controller.dart';
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
                      decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20)),
                      child: const Text(
                        'Active',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  '${employee['designation'] ?? 'No Designation'} • ${employee['department'] ?? 'No Department'}',
                  style: const TextStyle(fontSize: 18, color: Color(0xFF64748B)),
                ),

                const SizedBox(height: 16),

                const Row(
                  children: [
                    Icon(Icons.email_outlined, size: 18),

                    SizedBox(width: 8),

                    Text('employee@proworkforce.com'),

                    SizedBox(width: 30),

                    Icon(Icons.phone_outlined, size: 18),

                    SizedBox(width: 8),

                    Text('+91 9876543210'),
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

            ...controller.activities.take(5).map((activity) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Text('• ${activity['title']}'))),
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
            onPressed: () {},
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
