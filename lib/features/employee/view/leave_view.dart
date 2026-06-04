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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    'Leave Requests',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.black),

                    onPressed: () {
                      _showApplyLeaveDialog(context);
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Apply Leave', style: TextStyle(color: Colors.white)),
                  ),
                ],
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

  void _showApplyLeaveDialog(BuildContext context) {
    DateTime? startDate;
    DateTime? endDate;

    reasonController.clear();

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),

            child: Container(
              width: 550,
              padding: const EdgeInsets.all(28),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,

                        decoration: BoxDecoration(
                          color: const Color(0xFF0B1633),
                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: const Icon(Icons.event_note_outlined, color: Colors.white),
                      ),

                      const SizedBox(width: 16),

                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            'Apply Leave',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),

                          SizedBox(height: 4),

                          Text(
                            'Submit a leave request',
                            style: TextStyle(color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  Obx(
                    () => DropdownButtonFormField<String>(
                      value: selectedLeaveType.value,

                      borderRadius: BorderRadius.circular(16),

                      dropdownColor: Colors.white,

                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF0B1633)),

                      decoration: InputDecoration(
                        labelText: 'Leave Type',

                        filled: true,
                        fillColor: Colors.white,

                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),

                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          borderSide: BorderSide(color: Color(0xFF0B1633), width: 2),
                        ),
                      ),

                      items: leaveTypes
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e, style: const TextStyle(fontWeight: FontWeight.w500)),
                            ),
                          )
                          .toList(),

                      onChanged: (value) {
                        selectedLeaveType.value = value!;
                      },
                    ),
                  ),

                  const SizedBox(height: 18),

                  InkWell(
                    borderRadius: BorderRadius.circular(14),

                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,

                        firstDate: DateTime.now(),

                        lastDate: DateTime(2030),

                        initialDate: DateTime.now(),

                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(primary: Color(0xFF0B1633)),

                              dialogTheme: DialogThemeData(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),

                            child: child!,
                          );
                        },
                      );

                      if (picked != null) {
                        setState(() {
                          startDate = picked;
                        });
                      }
                    },

                    child: Container(
                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month),

                          const SizedBox(width: 12),

                          Text(
                            startDate == null
                                ? 'Select Start Date'
                                : DateFormat('dd MMM yyyy').format(startDate!),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  InkWell(
                    borderRadius: BorderRadius.circular(14),

                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: startDate ?? DateTime.now(),
                        lastDate: DateTime(2030),
                        initialDate: startDate ?? DateTime.now(),

                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(primary: Color(0xFF0B1633)),

                              dialogTheme: DialogThemeData(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),

                            child: child!,
                          );
                        },
                      );

                      if (picked != null) {
                        setState(() {
                          endDate = picked;
                        });
                      }
                    },

                    child: Container(
                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month),

                          const SizedBox(width: 12),

                          Text(
                            endDate == null
                                ? 'Select End Date'
                                : DateFormat('dd MMM yyyy').format(endDate!),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextField(
                    controller: reasonController,

                    maxLines: 4,

                    decoration: InputDecoration(
                      labelText: 'Reason',
                      hintText: 'Enter reason for leave',

                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),

                  const SizedBox(height: 28),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,

                    children: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },

                        child: const Text('Cancel'),
                      ),

                      const SizedBox(width: 12),

                      SizedBox(
                        height: 48,

                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0B1633),
                            foregroundColor: Colors.white,

                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),

                          onPressed: () async {
                            if (startDate == null ||
                                endDate == null ||
                                reasonController.text.trim().isEmpty) {
                              Get.snackbar('Error', 'Please fill all fields');
                              return;
                            }

                            try {
                              await controller.applyLeave(
                                leaveType: selectedLeaveType.value,
                                startDate: startDate!,
                                endDate: endDate!,
                                reason: reasonController.text.trim(),
                              );

                              Navigator.pop(context);

                              Get.snackbar('Success', 'Leave request submitted');
                            } catch (e) {
                              Get.snackbar('Error', e.toString());
                            }
                          },

                          child: const Text('Submit Request'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
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
