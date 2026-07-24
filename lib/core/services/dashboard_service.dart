import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardService {
  final supabase = Supabase.instance.client;
  static const int announcementPageSize = 5;
  static const int activityPageSize = 10;

  Future<Map<String, dynamic>?> getCompanySettings() async {
    final response = await supabase.from('company_settings').select().single();

    return response;
  }

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

  Future<List<Map<String, dynamic>>> getUpcomingHolidays({
    int page = 0,
    int limit = 10,
  }) async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final start = page * limit;
    final end = start + limit - 1;

    final response = await supabase
        .from('company_holidays')
        .select()
        .gte('holiday_date', today)
        .order('holiday_date', ascending: true)
        .range(start, end);

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

  Future<List<Map<String, dynamic>>> getRecentEmployeeActivities({
    required String role,
    int page = 0,
    int limit = 8,
  }) async {
    final start = page * limit;
    final end = start + limit - 1;

    final response = await supabase
        .from('employee_activity_logs')
        .select('''
      title,
      activity_time,
      activity_type,
      employee:profiles!employee_activity_logs_employee_id_fkey!inner(
        full_name,
        profile_image,
        role
      )
    ''')
        .eq('employee.role', role)
        .order('activity_time', ascending: false)
        .range(start, end);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<int> getEmployeeCount() async {
    final response = await supabase
        .from('profiles')
        .select()
        .eq('role', 'Employee');

    return response.length;
  }

  Future<int> getHrCount() async {
    final response = await supabase.from('profiles').select().eq('role', 'HR');

    return response.length;
  }

  Future<int> getPresentTodayCount() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final response = await supabase
        .from('attendance')
        .select()
        .eq('attendance_date', today)
        .eq('status', 'Present');

    return response.length;
  }

  Future<int> getPendingLeaveCount() async {
    final response = await supabase
        .from('leave_requests')
        .select()
        .eq('status', 'Pending');

    return response.length;
  }
}
