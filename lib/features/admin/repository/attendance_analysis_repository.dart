import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/attendance_chart_model.dart';

class AttendanceAnalysisRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Returns attendance for a single week.
  Future<List<AttendanceChartModel>> getWeeklyAttendance({
    required String employeeId,
    required DateTime weekStart,
  }) async {
    final weekEnd = weekStart.add(const Duration(days: 7));

    final response = await _supabase
        .from('attendance')
        .select()
        .eq('employee_id', employeeId)
        .gte('attendance_date', weekStart.toIso8601String().split('T').first)
        .lt('attendance_date', weekEnd.toIso8601String().split('T').first)
        .order('attendance_date');

    return response
        .map<AttendanceChartModel>((e) => AttendanceChartModel.fromMap(e))
        .toList();
  }

  /// Returns attendance for an entire month.
  Future<List<AttendanceChartModel>> getMonthlyAttendance({
    required String employeeId,
    required int year,
    required int month,
  }) async {
    final startDate = DateTime(year, month, 1);

    final endDate = month == 12
        ? DateTime(year + 1, 1, 1)
        : DateTime(year, month + 1, 1);

    final response = await _supabase
        .from('attendance')
        .select()
        .eq('employee_id', employeeId)
        .gte('attendance_date', startDate.toIso8601String().split('T').first)
        .lt('attendance_date', endDate.toIso8601String().split('T').first)
        .order('attendance_date');

    return response
        .map<AttendanceChartModel>((e) => AttendanceChartModel.fromMap(e))
        .toList();
  }
}
