import 'package:supabase_flutter/supabase_flutter.dart';

class HrRepository {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getEmployees() async {
    final response = await _supabase.from('profiles').select().order('full_name');

    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> getEmployeeById(String employeeId) async {
    final response = await _supabase.from('profiles').select().eq('id', employeeId).maybeSingle();

    return response;
  }

  Future<void> updateEmployeeStatus(String employeeId, bool isActive) async {
    await _supabase.from('profiles').update({'is_active': isActive}).eq('id', employeeId);
  }

  Future<List<Map<String, dynamic>>> getEmployeeAttendance(String employeeId) async {
    final response = await _supabase.from('attendance').select().eq('employee_id', employeeId).order('attendance_date', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getAttendanceBreaks(String attendanceId) async {
    final response = await _supabase.from('attendance_breaks').select().eq('attendance_id', attendanceId);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getLeaveRequests() async {
    final response = await _supabase.from('leave_requests').select().order('applied_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getPendingLeaveRequests() async {
    final response = await _supabase.from('leave_requests').select().eq('status', 'pending').order('applied_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> approveLeave(String leaveId, String approverId) async {
    await _supabase.from('leave_requests').update({'status': 'approved', 'approved_by': approverId, 'approved_at': DateTime.now().toIso8601String()}).eq('id', leaveId);
  }

  Future<void> rejectLeave(String leaveId, String approverId) async {
    await _supabase.from('leave_requests').update({'status': 'rejected', 'approved_by': approverId, 'approved_at': DateTime.now().toIso8601String()}).eq('id', leaveId);
  }

  Future<List<Map<String, dynamic>>> getEmployeeActivities(String employeeId) async {
    final response = await _supabase.from('employee_activity_logs').select().eq('employee_id', employeeId).order('activity_time', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getRecentActivities() async {
    final response = await _supabase.from('employee_activity_logs').select().order('activity_time', ascending: false).limit(20);

    return List<Map<String, dynamic>>.from(response);
  }
}
