import 'package:get/get.dart';

import '../models/attendance_chart_model.dart';
import '../repository/attendance_analysis_repository.dart';

enum AttendanceChartType { weekly, monthly }

class AttendanceAnalysisController extends GetxController {
  final AttendanceAnalysisRepository repository =
      AttendanceAnalysisRepository();

  final chartType = AttendanceChartType.weekly.obs;

  final isLoading = false.obs;

  final selectedMonth = DateTime.now().obs;

  /// Monday of the currently selected week
  final selectedWeek = _startOfWeek(DateTime.now()).obs;

  final chartData = <AttendanceChartModel>[].obs;

  String employeeId = "";

  Future<void> initialize(String id) async {
    employeeId = id;
    await loadChart();
  }

  Future<void> loadChart() async {
    if (employeeId.isEmpty) return;

    try {
      isLoading.value = true;

      if (chartType.value == AttendanceChartType.weekly) {
        chartData.value = await repository.getWeeklyAttendance(
          employeeId: employeeId,
          weekStart: selectedWeek.value,
        );
        print("${chartType.value}");
      } else {
        chartData.value = await repository.getMonthlyAttendance(
          employeeId: employeeId,
          year: selectedMonth.value.year,
          month: selectedMonth.value.month,
        );
      }

      _fillMissingDays();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setWeekly() async {
    chartType.value = AttendanceChartType.weekly;
    await loadChart();
  }

  Future<void> setMonthly() async {
    chartType.value = AttendanceChartType.monthly;
    await loadChart();
  }

  Future<void> previous() async {
    if (chartType.value == AttendanceChartType.weekly) {
      selectedWeek.value = selectedWeek.value.subtract(const Duration(days: 7));
    } else {
      selectedMonth.value = DateTime(
        selectedMonth.value.year,
        selectedMonth.value.month - 1,
      );
    }

    await loadChart();
  }

  Future<void> next() async {
    if (chartType.value == AttendanceChartType.weekly) {
      final nextWeek = selectedWeek.value.add(const Duration(days: 7));

      final currentWeek = _startOfWeek(DateTime.now());

      if (nextWeek.isAfter(currentWeek)) return;

      selectedWeek.value = nextWeek;
    } else {
      final nextMonth = DateTime(
        selectedMonth.value.year,
        selectedMonth.value.month + 1,
      );

      final currentMonth = DateTime(DateTime.now().year, DateTime.now().month);

      if (nextMonth.isAfter(currentMonth)) return;

      selectedMonth.value = nextMonth;
    }

    await loadChart();
  }

  static DateTime _startOfWeek(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    ).subtract(Duration(days: date.weekday - 1));
  }

  void _fillMissingDays() {
    if (chartType.value == AttendanceChartType.weekly) {
      final List<AttendanceChartModel> filled = [];

      for (int i = 0; i < 7; i++) {
        final day = selectedWeek.value.add(Duration(days: i));

        final existing = chartData.firstWhereOrNull(
          (e) =>
              e.date.year == day.year &&
              e.date.month == day.month &&
              e.date.day == day.day,
        );

        filled.add(
          existing ??
              AttendanceChartModel(date: day, totalHours: 0, overtimeHours: 0),
        );
      }

      chartData.value = filled;
    } else {
      final daysInMonth = DateTime(
        selectedMonth.value.year,
        selectedMonth.value.month + 1,
        0,
      ).day;

      final List<AttendanceChartModel> filled = [];

      for (int i = 1; i <= daysInMonth; i++) {
        final day = DateTime(
          selectedMonth.value.year,
          selectedMonth.value.month,
          i,
        );

        final existing = chartData.firstWhereOrNull(
          (e) =>
              e.date.year == day.year &&
              e.date.month == day.month &&
              e.date.day == day.day,
        );

        filled.add(
          existing ??
              AttendanceChartModel(date: day, totalHours: 0, overtimeHours: 0),
        );
      }

      chartData.value = filled;
    }
  }

  Future<void> changeMonth(DateTime month) async {
    selectedMonth.value = month;
    await loadChart();
  }
}
