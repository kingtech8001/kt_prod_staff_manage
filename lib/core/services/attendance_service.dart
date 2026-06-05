import 'package:supabase_flutter/supabase_flutter.dart';

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

  Future<List<Map<String, dynamic>>> getAttendance(String employeeId) async {
    final response = await supabase
        .from('attendance')
        .select()
        .eq('employee_id', employeeId)
        .order('attendance_date', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> punchIn(String employeeId) async {
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
    print('LOCAL => $now');
    print('UTC => ${now.toUtc()}');

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
  }

  Future<void> startBreak(String attendanceId) async {
    await supabase.from('attendance_breaks').insert({
      'attendance_id': attendanceId,
      'break_start': DateTime.now().toUtc().toIso8601String(),
    });

    await supabase.from('attendance').update({'current_state': 'On Break'}).eq('id', attendanceId);
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
        .update({'break_end': endTime.toIso8601String(), 'duration_minutes': duration})
        .eq('id', activeBreak['id']);

    await supabase.from('attendance').update({'current_state': 'Present'}).eq('id', attendanceId);
  }

  Future<void> punchOut(String attendanceId) async {
    final attendance = await supabase.from('attendance').select().eq('id', attendanceId).single();

    final now = DateTime.now();
    print('LOCAL => $now');
    print('UTC => ${now.toUtc()}');

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
  }

  Future<Map<String, dynamic>?> getActiveBreak(String attendanceId) async {
    return await supabase
        .from('attendance_breaks')
        .select()
        .eq('attendance_id', attendanceId)
        .isFilter('break_end', null)
        .maybeSingle();
  }
}
