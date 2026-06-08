import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controller/leave_controller.dart';
import 'package:intl/intl.dart';

import '../widgets/leave_requests/leave_sidebar.dart';

class LeaveView extends StatelessWidget {
  LeaveView({super.key});

  final controller = Get.put(LeaveController());
  final reasonController = TextEditingController();

  final leaveTypes = ['Sick Leave', 'Casual Leave', 'Annual Leave'];

  final selectedLeaveType = 'Sick Leave'.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      body: Padding(
        padding: const EdgeInsets.all(32),

        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final leaves = controller.leaveList;

          final pending = leaves.where((e) => e['status'] == 'Pending').length;

          final approved = leaves.where((e) => e['status'] == 'Approved').length;

          final rejected = leaves.where((e) => e['status'] == 'Rejected').length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                'Leave Requests',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(child: _buildStatCard('Pending', pending.toString(), Colors.orange)),

                  const SizedBox(width: 16),

                  Expanded(child: _buildStatCard('Approved', approved.toString(), Colors.green)),

                  const SizedBox(width: 16),

                  Expanded(child: _buildStatCard('Rejected', rejected.toString(), Colors.red)),

                  const SizedBox(width: 16),

                  Expanded(child: _buildStatCard('Total', leaves.length.toString(), Colors.blue)),
                ],
              ),

              const SizedBox(height: 24),

              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SingleChildScrollView(
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Leave Type')),
                              DataColumn(label: Text('Start Date')),
                              DataColumn(label: Text('End Date')),
                              DataColumn(label: Text('Days')),
                              DataColumn(label: Text('Status')),
                            ],
                            rows: leaves.map((leave) {
                              final startDate = DateTime.parse(leave['start_date']);
                              final endDate = DateTime.parse(leave['end_date']);
                              final days = endDate.difference(startDate).inDays + 1;

                              return DataRow(
                                cells: [
                                  DataCell(Text(leave['leave_type'] ?? '')),
                                  DataCell(Text(DateFormat('dd MMM yyyy').format(startDate))),
                                  DataCell(Text(DateFormat('dd MMM yyyy').format(endDate))),
                                  DataCell(Text('$days Day${days > 1 ? 's' : ''}')),
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _statusColor(leave['status']).withOpacity(.12),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        leave['status'] ?? '',
                                        style: TextStyle(
                                          color: _statusColor(leave['status']),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 24),

                    const Expanded(flex: 1, child: LeaveSidebar()),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      height: 130,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text(title, style: const TextStyle(color: Color(0xFF64748B))),

          const SizedBox(height: 8),

          Text(
            value,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Colors.green;

      case 'rejected':
        return Colors.red;

      case 'pending':
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }
}
