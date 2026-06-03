import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceService {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> getTodayAttendance(String employeeId) async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final response = await supabase.from('attendance').select().eq('employee_id', employeeId).eq('attendance_date', today).maybeSingle();

    return response;
  }

  Future<List<Map<String, dynamic>>> getAttendance(String employeeId) async {
    final response = await supabase.from('attendance').select().eq('employee_id', employeeId).order('attendance_date', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
