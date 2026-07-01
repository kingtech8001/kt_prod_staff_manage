import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/app_confirmation_dialog.dart';
import '../../../../shared/attendance_controller.dart';
import '../../controller/dashboard_controller.dart';

class ShiftCard extends StatelessWidget {
  ShiftCard({super.key});

  final controller = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Obx(() {
        final attendance = controller.todayAttendance.value;

        final punchIn = formatTime(attendance?['punch_in']?.toString());

        final punchOut = formatTime(attendance?['punch_out']?.toString());

        final status =
            attendance?['current_state']?.toString() ?? 'Awaiting Check-In';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _displayText(attendance)),

                _buildButton(attendance),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: status == 'Present'
                        ? Colors.green
                        : status == 'On Break'
                        ? Colors.orange
                        : status == 'Completed'
                        ? Colors.blue
                        : const Color(0xFFF59E0B),
                    shape: BoxShape.circle,
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  status.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildButton(Map<String, dynamic>? attendance) {
    final state =
        attendance?['current_state']?.toString() ?? 'Awaiting Check-In';

    if (state == 'Awaiting Check-In') {
      return SizedBox(
        width: 180,
        height: 56,
        child: ElevatedButton.icon(
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.black),
          ),
          onPressed: () async {
            await controller.punchIn();
          },
          icon: const Icon(Icons.login, color: Colors.white),
          label: const Text('PUNCH IN', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    if (state == 'Present') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 160,
            height: 56,
            child: OutlinedButton.icon(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.black),
              ),
              onPressed: () async {
                final confirmed = await Get.dialog<bool>(
                  const AppConfirmationDialog(
                    title: 'Start Break',
                    message: 'Do you want to start your break?',
                    confirmText: 'Start Break',
                    confirmColor: Colors.black,
                  ),
                );

                if (confirmed == true) {
                  await controller.startBreak();
                }
              },
              icon: const Icon(Icons.coffee, color: Colors.white),
              label: const Text(
                'Start Break',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

          const SizedBox(width: 12),

          SizedBox(
            width: 160,
            height: 56,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final confirmed = await Get.dialog<bool>(
                  const AppConfirmationDialog(
                    title: 'Punch Out',
                    message:
                        'Are you sure you want to punch out for today?\n\nYou will not be able to punch in again until tomorrow.',
                    confirmText: 'Punch Out',
                    confirmColor: Color(0xFFEF4444),
                  ),
                );

                if (confirmed == true) {
                  await controller.punchOut();
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('Punch Out'),
            ),
          ),
        ],
      );
    }

    if (state == 'On Break') {
      return SizedBox(
        width: 180,
        height: 56,
        child: ElevatedButton.icon(
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.black),
          ),
          onPressed: () async {
            final confirmed = await Get.dialog<bool>(
              const AppConfirmationDialog(
                title: 'End Break',
                message: 'Resume working?',
                confirmText: 'Resume',
                confirmColor: Color(0xFF10B981),
              ),
            );

            if (confirmed == true) {
              await controller.stopBreak();
            }
          },
          icon: const Icon(Icons.play_arrow, color: Colors.white),
          label: const Text(
            'STOP BREAK',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return ElevatedButton.icon(
      style: const ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.black),
      ),
      onPressed: null,
      icon: const Icon(Icons.check, color: Colors.white),
      label: const Text('COMPLETED', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _displayText(Map<String, dynamic>? attendance) {
    final state = attendance?['current_state'];

    final punchIn = formatTime(attendance?['punch_in']?.toString());

    final punchOut = formatTime(attendance?['punch_out']?.toString());

    if (state == 'Present') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LIVE WORK TIMER',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 6),

          Obx(
            () => Text(
              formatDuration(controller.workDuration.value),
              style: const TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0B1633),
              ),
            ),
          ),
        ],
      );
    }

    if (state == 'On Break') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'BREAK TIMER',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 6),

          Obx(
            () => Text(
              formatDuration(controller.breakDuration.value),
              style: const TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0B1633),
              ),
            ),
          ),
        ],
      );
    }

    return Text(
      '$punchIn - $punchOut',
      style: const TextStyle(
        fontSize: 52,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0B1633),
      ),
    );
  }

  String formatTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return '00:00';
    }

    try {
      final dateTime = DateTime.parse(dateTimeString).toLocal();
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return '00:00';
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    return '${twoDigits(duration.inHours)}:'
        '${twoDigits(duration.inMinutes.remainder(60))}:'
        '${twoDigits(duration.inSeconds.remainder(60))}';
  }
}
