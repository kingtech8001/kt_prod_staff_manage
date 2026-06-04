import 'package:supabase_flutter/supabase_flutter.dart';

class PerformanceService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getReviews(String employeeId) async {
    return await supabase
        .from('performance_reviews')
        .select()
        .eq('employee_id', employeeId)
        .order('review_date', ascending: false);
  }

  Future<List<Map<String, dynamic>>> getAchievements(String employeeId) async {
    return await supabase
        .from('employee_achievements')
        .select()
        .eq('employee_id', employeeId)
        .order('awarded_at', ascending: false);
  }

  Future<List<Map<String, dynamic>>> getAttendance(String employeeId) async {
    final response = await supabase.from('attendance').select().eq('employee_id', employeeId);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getLeaves(String employeeId) async {
    final response = await supabase.from('leave_requests').select().eq('employee_id', employeeId);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> getPerformanceMetrics(String employeeId) async {
    return await supabase
        .from('performance_metrics')
        .select()
        .eq('employee_id', employeeId)
        .maybeSingle();
  }
}
