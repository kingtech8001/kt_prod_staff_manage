import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/dashboard_controller.dart';

class ShiftCard extends StatelessWidget {
  ShiftCard({super.key});

  final controller = Get.put(DashboardController());

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

        final status = attendance?['status']?.toString() ?? 'AWAITING CHECK-IN';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '$punchIn - $punchOut',
                    style: const TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0B1633),
                    ),
                  ),
                ),

                SizedBox(
                  width: 180,
                  height: 56,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black)),
                    onPressed: () {},
                    icon: const Icon(Icons.login, size: 18, color: Colors.white),
                    label: const Text(
                      'PUNCH IN',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Color(0xFFF59E0B), shape: BoxShape.circle),
                ),

                const SizedBox(width: 8),

                Text(
                  status.toUpperCase(),
                  style: const TextStyle(fontSize: 13, color: Color(0xFF374151)),
                ),
              ],
            ),
          ],
        );
      }),
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
}
