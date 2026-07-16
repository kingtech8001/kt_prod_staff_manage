import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../features/admin/models/attendance_chart_model.dart';

class AttendanceBarChart extends StatefulWidget {
  final List<AttendanceChartModel> data;

  const AttendanceBarChart({super.key, required this.data});

  @override
  State<AttendanceBarChart> createState() => _AttendanceBarChartState();
}

class _AttendanceBarChartState extends State<AttendanceBarChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const SizedBox();
    }

    final maxHours = widget.data
        .map((e) => e.totalHours)
        .fold<double>(0, (a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          minY: 0,
          maxY: (maxHours + 2).ceilToDouble(),

          gridData: FlGridData(
            show: true,
            horizontalInterval: 2,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(color: const Color(0xFFE5E7EB), strokeWidth: 1);
            },
          ),

          borderData: FlBorderData(show: false),

          barTouchData: BarTouchData(
            enabled: true,

            touchCallback: (event, response) {
              setState(() {
                touchedIndex = response?.spot?.touchedBarGroupIndex ?? -1;
              });
            },

            touchTooltipData: BarTouchTooltipData(
              tooltipBorderRadius: BorderRadius.circular(14),
              getTooltipColor: (context) => Colors.black,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final item = widget.data[group.x];

                return BarTooltipItem(
                  '${DateFormat('EEE').format(item.date)}\n'
                  'Worked: ${item.totalHours.toStringAsFixed(1)} hrs\n'
                  'OT: ${item.overtimeHours.toStringAsFixed(1)} hrs',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                );
              },
            ),
          ),

          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),

            rightTitles: const AxisTitles(),

            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                interval: 2,
              ),
            ),

            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,

                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= widget.data.length) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      DateFormat('EEE').format(widget.data[value.toInt()].date),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          barGroups: List.generate(widget.data.length, (index) {
            final item = widget.data[index];

            return BarChartGroupData(
              x: index,

              barRods: [
                BarChartRodData(
                  toY: item.totalHours,
                  width: 22,

                  borderRadius: BorderRadius.circular(8),

                  color: const Color(0xFF16A34A),
                ),
              ],
            );
          }),
        ),

        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      ),
    );
  }
}
