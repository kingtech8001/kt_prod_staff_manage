import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/hr/repository/hr_repository.dart';

class AttendanceService {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> getTodayAttendance(String employeeId) async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final response = await supabase
        .from('attendance')
        .select()
        .eq('employee_id', employeeId)
        .eq('attendance_date', today)
        .maybeSingle();

    return response;
  }

  Future<Map<String, dynamic>> getAttendance(
    String employeeId, {
    required int month,
    required int year,
    required int page,
    required int limit,
  }) async {
    final from = page * limit;
    final to = from + limit - 1;

    final start = DateTime(year, month, 1).toIso8601String().split('T').first;

    final end = DateTime(year, month + 1, 0).toIso8601String().split('T').first;

    final allRecords = await supabase
        .from('attendance')
        .select()
        .eq('employee_id', employeeId)
        .gte('attendance_date', start)
        .lte('attendance_date', end);

    final pageData = await supabase
        .from('attendance')
        .select()
        .eq('employee_id', employeeId)
        .gte('attendance_date', start)
        .lte('attendance_date', end)
        .order('attendance_date', ascending: false)
        .range(from, to);

    return {
      'data': List<Map<String, dynamic>>.from(pageData),
      'count': allRecords.length,
    };
  }

  Future<List<Map<String, dynamic>>> getWeeklyAttendance(
    String employeeId,
  ) async {
    final now = DateTime.now();

    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day - (now.weekday - 1),
    );

    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final response = await supabase
        .from('attendance')
        .select()
        .eq('employee_id', employeeId)
        .gte('attendance_date', startOfWeek.toIso8601String().split('T').first)
        .lte('attendance_date', endOfWeek.toIso8601String().split('T').first)
        .order('attendance_date', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> punchIn(String employeeId) async {
    ///TODO why today variable,  double click safety, check 9,0 in shift_start variable
    final today = DateTime.now().toIso8601String().split('T').first;

    final existing = await supabase
        .from('attendance')
        .select()
        .eq('employee_id', employeeId)
        .eq('attendance_date', today)
        .maybeSingle();

    if (existing != null) {
      throw Exception('Already punched in today');
    }

    final now = DateTime.now();

    final shiftStart = DateTime(now.year, now.month, now.day, 9, 0);

    final isLate = now.difference(shiftStart).inMinutes > 15;

    await supabase.from('attendance').insert({
      'employee_id': employeeId,
      'attendance_date': today,
      'punch_in': DateTime.now().toUtc().toIso8601String(),
      'status': 'Present',
      'current_state': 'Present',
      'is_late': isLate,
    });

    await _logActivity(
      employeeId: employeeId,
      title: 'Punched In',
      activityType: 'PUNCH_IN',
    );
  }

  Future<void> startBreak(String attendanceId) async {
    await supabase.from('attendance_breaks').insert({
      'attendance_id': attendanceId,
      'break_start': DateTime.now().toUtc().toIso8601String(),
    });

    await supabase
        .from('attendance')
        .update({'current_state': 'On Break'})
        .eq('id', attendanceId);

    final attendance = await supabase
        .from('attendance')
        .select('employee_id')
        .eq('id', attendanceId)
        .single();

    await _logActivity(
      employeeId: attendance['employee_id'],
      title: 'Started Break',
      activityType: 'BREAK_START',
    );
  }

  Future<void> stopBreak(String attendanceId) async {
    final activeBreak = await supabase
        .from('attendance_breaks')
        .select()
        .eq('attendance_id', attendanceId)
        .isFilter('break_end', null)
        .maybeSingle();

    if (activeBreak == null) {
      throw Exception('No active break found');
    }

    final endTime = DateTime.now().toUtc();

    final startTime = DateTime.parse(activeBreak['break_start']).toUtc();

    final duration = endTime.difference(startTime).inMinutes;

    await supabase
        .from('attendance_breaks')
        .update({
          'break_end': endTime.toIso8601String(),
          'duration_minutes': duration,
        })
        .eq('id', activeBreak['id']);

    await supabase
        .from('attendance')
        .update({'current_state': 'Present'})
        .eq('id', attendanceId);

    final attendance = await supabase
        .from('attendance')
        .select('employee_id')
        .eq('id', attendanceId)
        .single();

    await _logActivity(
      employeeId: attendance['employee_id'],
      title: 'Ended Break',
      activityType: 'BREAK_END',
    );
  }

  Future<void> punchOut(String attendanceId) async {
    final attendance = await supabase
        .from('attendance')
        .select()
        .eq('id', attendanceId)
        .single();

    final now = DateTime.now().toUtc();

    final punchIn = DateTime.parse(attendance['punch_in']);

    final breaks = await supabase
        .from('attendance_breaks')
        .select()
        .eq('attendance_id', attendanceId);

    int totalBreakMinutes = 0;

    for (final item in breaks) {
      totalBreakMinutes += (item['duration_minutes'] ?? 0) as int;
    }

    final totalWorkedMinutes = now.difference(punchIn).inMinutes;

    int extraBreakMinutes = 0;

    if (totalBreakMinutes > 60) {
      extraBreakMinutes = totalBreakMinutes - 60;
    }

    final effectiveMinutes = totalWorkedMinutes - extraBreakMinutes;

    final totalHours = effectiveMinutes / 60.0;

    double overtimeHours = 0;

    if (totalHours >= 10) {
      overtimeHours = totalHours - 8;
    }
    print('Saving punch out: ${now.toIso8601String()}');

    await supabase
        .from('attendance')
        .update({
          'punch_out': now.toIso8601String(),
          'total_hours': totalHours,
          'overtime_hours': overtimeHours,
          'status': 'Present',
          'current_state': 'Completed',
        })
        .eq('id', attendanceId);
    await _logActivity(
      employeeId: attendance['employee_id'],
      title: 'Punched Out',
      activityType: 'PUNCH_OUT',
    );

    final saved = await supabase
        .from('attendance')
        .select('punch_out')
        .eq('id', attendanceId)
        .single();

    print('Saved punch out: ${saved['punch_out']}');
  }

  Future<Map<String, dynamic>?> getActiveBreak(String attendanceId) async {
    return await supabase
        .from('attendance_breaks')
        .select()
        .eq('attendance_id', attendanceId)
        .isFilter('break_end', null)
        .maybeSingle();
  }

  Future<void> _logActivity({
    required String employeeId,
    required String title,
    required String activityType,
  }) async {
    await supabase.from('employee_activity_logs').insert({
      'employee_id': employeeId,
      'title': title,
      'activity_type': activityType,
      'activity_source': 'employee',
      'activity_time': DateTime.now().toUtc().toIso8601String(),
    });
  }
}
