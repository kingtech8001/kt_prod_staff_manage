import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/snackbar.dart';
import '../../../../features/auth/controller/leave_controller.dart';

class LeaveRequestButton extends StatelessWidget {
  const LeaveRequestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showApplyLeaveDialog(context),
      icon: const Icon(Icons.add_circle_outline, size: 18),
      label: const Text('Request Leave'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF64748B),
        foregroundColor: Colors.white,
        minimumSize: const Size(170, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  void _showApplyLeaveDialog(BuildContext context) {
    final controller = Get.put(LeaveController());
    final reasonController = TextEditingController();

    final leaveTypes = ['Sick Leave', 'Casual Leave', 'Annual Leave'];

    final selectedLeaveType = 'Sick Leave'.obs;
    DateTime? startDate;
    DateTime? endDate;

    reasonController.clear();

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),

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

                        child: const Icon(
                          Icons.event_note_outlined,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 16),

                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            'Apply Leave',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
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

                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFF0B1633),
                      ),

                      decoration: InputDecoration(
                        labelText: 'Leave Type',

                        filled: true,
                        fillColor: Colors.white,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),

                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          borderSide: BorderSide(
                            color: Color(0xFF0B1633),
                            width: 2,
                          ),
                        ),
                      ),

                      items: leaveTypes
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF0B1633),
                              ),

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
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF0B1633),
                              ),

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

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
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

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),

                          onPressed: () async {
                            if (startDate == null ||
                                endDate == null ||
                                reasonController.text.trim().isEmpty) {
                              CommonSnackbar.warning(
                                'Validation',
                                'Please fill all fields',
                              );
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

                              CommonSnackbar.success(
                                'Success',
                                'Leave request submitted',
                              );
                            } catch (e) {
                              CommonSnackbar.error('Error', e.toString());
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
}
