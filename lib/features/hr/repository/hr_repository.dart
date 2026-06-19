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
    final response = await _supabase
        .from('employee_activity_logs')
        .select('''
        *,
        profiles!employee_activity_logs_employee_id_fkey(
          full_name,
          profile_image
        )
      ''')
        .order('activity_time', ascending: false)
        .limit(15);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> markAttendanceStatus({required String employeeId, required DateTime date, required String status}) async {
    final dateString = date.toIso8601String().split('T').first;

    final existing = await _supabase.from('attendance').select().eq('employee_id', employeeId).eq('attendance_date', dateString).maybeSingle();

    if (existing != null) {
      await _supabase.from('attendance').update({'status': status, 'current_state': status}).eq('id', existing['id']);
    } else {
      await _supabase.from('attendance').insert({'employee_id': employeeId, 'attendance_date': dateString, 'status': status, 'current_state': status});
    }

    await _supabase.from('employee_activity_logs').insert({
      'employee_id': employeeId,
      'title': 'Marked $status',
      'activity_type': 'ATTENDANCE_UPDATE',
      'activity_source': 'hr',
      'activity_time': DateTime.now().toIso8601String(),
    });
  }

  Future<void> markAbsent(String employeeId) async {
    await _supabase.from('attendance').insert({
      'employee_id': employeeId,
      'attendance_date': DateTime.now().toIso8601String().split('T')[0],
      'status': 'Absent',
      'current_state': 'Absent',
    });

    await _supabase.from('employee_activity_logs').insert({
      'employee_id': employeeId,
      'title': 'Marked Absent',
      'activity_type': 'ATTENDANCE_UPDATE',
      'activity_source': 'hr',
      'activity_time': DateTime.now().toIso8601String(),
    });
  }

  Future<void> approveLatestLeave(String employeeId, String approverId) async {
    final leave = await _supabase
        .from('leave_requests')
        .select()
        .eq('employee_id', employeeId)
        .eq('status', 'pending')
        .order('applied_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (leave == null) return;

    await approveLeave(leave['id'], approverId);
  }

  Future<void> rejectLatestLeave(String employeeId, String approverId) async {
    final leave = await _supabase
        .from('leave_requests')
        .select()
        .eq('employee_id', employeeId)
        .eq('status', 'pending')
        .order('applied_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (leave == null) return;

    await rejectLeave(leave['id'], approverId);
  }

  Future<void> createEmployee({required String firstName, required String lastName, required String email, required String phone, required String designation}) async {
    final fullName = '$firstName $lastName';

    final employeeCode = 'EMP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    final authUser = await _supabase.auth.signUp(email: email, password: 'Temp@123456');

    final userId = authUser.user?.id;

    if (userId == null) {
      throw Exception('Failed to create employee account');
    }

    await _supabase.from('profiles').insert({
      'id': userId,
      'employee_code': employeeCode,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'designation': designation,
      'role': 'employee',
      'is_active': true,
    });

    await _supabase.from('employee_activity_logs').insert({
      'employee_id': userId,
      'title': 'Employee profile created',
      'activity_type': 'PROFILE_CREATED',
      'activity_source': 'hr',
      'activity_time': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getLiveActivities() async {
    final response = await _supabase
        .from('employee_activity_logs')
        .select('''
        *,
        profiles!employee_activity_logs_employee_id_fkey(
          full_name
        )
      ''')
        .eq('activity_source', 'employee')
        .order('activity_time', ascending: false)
        .limit(15);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> updateEmployee({
    required String employeeId,
    required String fullName,
    required String email,
    required String phone,
    required String designation,
    required bool isActive,
  }) async {
    await _supabase.from('profiles').update({'full_name': fullName, 'email': email, 'phone': phone, 'designation': designation, 'is_active': isActive}).eq('id', employeeId);

    await _supabase.from('employee_activity_logs').insert({
      'employee_id': employeeId,
      'title': 'Employee profile updated by HR',
      'activity_source': 'hr',
      'activity_time': DateTime.now().toIso8601String(),
    });

    final result = await _supabase
        .from('profiles')
        .update({'full_name': fullName, 'email': email, 'phone': phone, 'designation': designation, 'is_active': isActive})
        .eq('id', employeeId)
        .select();
  }

  Future<Map<String, int>> getDashboardStats() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final employees = await _supabase.from('profiles').select('id').eq('is_active', true);

    final attendance = await _supabase.from('attendance').select('status, is_late').eq('attendance_date', today);

    final totalEmployees = employees.length;

    final presentToday = attendance.where((e) => (e['status'] ?? '').toString().toLowerCase() == 'present').length;

    final lateToday = attendance.where((e) => e['is_late'] == true).length;

    final onLeaveToday = attendance.where((e) => (e['status'] ?? '').toString().toLowerCase() == 'leave').length;

    return {'totalEmployees': totalEmployees, 'presentToday': presentToday, 'lateToday': lateToday, 'onLeaveToday': onLeaveToday};
  }
}
