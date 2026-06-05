import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getAnnouncements() async {
    final response = await supabase
        .from('company_announcements')
        .select()
        .eq('is_active', true)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getUpcomingHolidays() async {
    final response = await supabase
        .from('company_holidays')
        .select()
        .gte('holiday_date', DateTime.now().toIso8601String())
        .order('holiday_date');

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getRecentActivities(String employeeId) async {
    final response = await supabase
        .from('employee_activity_logs')
        .select()
        .eq('employee_id', employeeId)
        .order('activity_time', ascending: false)
        .limit(10);

    return List<Map<String, dynamic>>.from(response);
  }
}
