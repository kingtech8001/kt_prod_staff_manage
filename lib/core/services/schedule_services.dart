import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getUpcomingSchedule(
    String employeeId,
  ) async {
    final response = await supabase
        .from('employee_schedule')
        .select()
        .eq('employee_id', employeeId)
        .gte('start_time', DateTime.now().toIso8601String())
        .order('start_time')
        .limit(5);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> getScheduleSettings(String employeeId) async {
    final response = await supabase
        .from('profiles')
        .select('expected_work_hours, break_allowance_hours')
        .eq('id', employeeId)
        .maybeSingle();

    return response;
  }
}
