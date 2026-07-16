import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/attendance_bar_chart.dart';
import '../../../shared/month_year_picker_dialog.dart';
import '../controller/attendance_analysis_controller.dart';

class AttendanceAnalysisView extends StatelessWidget {
  const AttendanceAnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AttendanceAnalysisController>();

    return Obx(() {
      return Container(
        height: 650,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          children: [
            _header(controller),

            const Divider(height: 1),

            Expanded(
              child: controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : controller.chartData.every(
                      (e) => e.totalHours == 0 && e.overtimeHours == 0,
                    )
                  ? _emptyState(controller)
                  : AttendanceBarChart(data: controller.chartData),
            ),
          ],
        ),
      );
    });
  }

  Widget _header(AttendanceAnalysisController controller) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "Attendance Analysis",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ),

          Obx(() {
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  _modeButton(controller, AttendanceChartType.weekly, "Weekly"),
                  _modeButton(
                    controller,
                    AttendanceChartType.monthly,
                    "Monthly",
                  ),
                ],
              ),
            );
          }),

          const SizedBox(width: 24),

          IconButton(
            onPressed: controller.previous,
            icon: const Icon(Icons.chevron_left_rounded),
          ),

          Obx(() {
            final isMonthly =
                controller.chartType.value == AttendanceChartType.monthly;

            final label = isMonthly
                ? DateFormat("MMMM yyyy").format(controller.selectedMonth.value)
                : "${DateFormat('dd MMM').format(controller.selectedWeek.value)} - "
                      "${DateFormat('dd MMM').format(controller.selectedWeek.value.add(const Duration(days: 6)))}";

            return InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () async {
                if (isMonthly) {
                  final selected = await showDialog<DateTime>(
                    context: Get.context!,
                    builder: (_) => MonthYearPickerDialog(
                      initialDate: controller.selectedMonth.value,
                    ),
                  );

                  if (selected != null) {
                    controller.changeMonth(selected);
                  }
                } else {
                  final picked = await showDatePicker(
                    context: Get.context!,
                    initialDate: controller.selectedWeek.value,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),

                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFF0B1633),
                            onPrimary: Colors.white,
                            surface: Colors.white,
                            onSurface: Color(0xFF111827),
                          ),

                          dialogTheme: DialogThemeData(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),

                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF0B1633),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (picked != null) {
                    controller.changeWeek(picked);
                  }
                }
              },
              child: SizedBox(
                width: 180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),

                    if (isMonthly) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                    ],
                  ],
                ),
              ),
            );
          }),

          IconButton(
            onPressed: controller.next,
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }

  Widget _modeButton(
    AttendanceAnalysisController controller,
    AttendanceChartType type,
    String title,
  ) {
    final selected = controller.chartType.value == type;

    return GestureDetector(
      onTap: () {
        if (type == AttendanceChartType.weekly) {
          controller.setWeekly();
        } else {
          controller.setMonthly();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _emptyState(AttendanceAnalysisController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart_rounded, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 18),
          Text(
            "No attendance data",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            controller.chartType.value == AttendanceChartType.weekly
                ? "No records found for this week."
                : "No records found for this month.",
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
