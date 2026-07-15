import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardService {
  final supabase = Supabase.instance.client;
  static const int announcementPageSize = 5;
  static const int activityPageSize = 10;

  Future<List<Map<String, dynamic>>> getAnnouncements({
    int page = 0,
    int limit = announcementPageSize,
  }) async {
    /// todo how does the value is increasing
    final start = page * limit;
    final end = start + limit - 1;

    final response = await supabase
        .from('company_announcements')
        .select()
        .eq('is_active', true)
        .order('created_at', ascending: false)
        .range(start, end);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getUpcomingHolidays() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final response = await supabase
        .from('company_holidays')
        .select()
        .gte('holiday_date', today)
        .order('holiday_date', ascending: true)
        .limit(3);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getRecentActivities(
    String employeeId, {
    int page = 0,
    int limit = activityPageSize,
  }) async {
    final start = page * limit;
    final end = start + limit - 1;

    final response = await supabase
        .from('employee_activity_logs')
        .select()
        .eq('employee_id', employeeId)
        .order('activity_time', ascending: false)
        .range(start, end);

    return List<Map<String, dynamic>>.from(response);
  }
}
