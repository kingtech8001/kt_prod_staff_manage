import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/controllers/auth_controller.dart';

class HrRepository {
  final _supabase = Supabase.instance.client;
  static const int pendingLeavePageSize = 10;
  static const int employeePageSize = 10;
  final AuthController authController = Get.find<AuthController>();

  Future<List<Map<String, dynamic>>> getEmployees({
    String search = '',
    int page = 0,
    int limit = employeePageSize,
  }) async {
    print("Repository Search = '$search'");
    final start = page * limit;
    final end = start + limit - 1;

    final query = _supabase.from('profiles').select().eq('role', 'Employee');

    final response =
        await (search.trim().isEmpty
                ? query
                : query.or(
                    'full_name.ilike.%$search%,employee_code.ilike.%$search%,designation.ilike.%$search%',
                  ))
            .order('full_name')
            .range(start, end);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> getTodayAttendance(String employeeId) async {
    final today = DateTime.now().toIso8601String().split('T').first;

    return await _supabase
        .from('attendance')
        .select()
        .eq('employee_id', employeeId)
        .eq('attendance_date', today)
        .maybeSingle();
  }

  Future<Map<String, dynamic>?> getActiveBreak(String attendanceId) async {
    return await _supabase
        .from('attendance_breaks')
        .select()
        .eq('attendance_id', attendanceId)
        .isFilter('break_end', null)
        .maybeSingle();
  }

  Future<Map<String, dynamic>?> getEmployeeById(String employeeId) async {
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', employeeId)
        .maybeSingle();

    return response;
  }

  Future<void> updateEmployeeStatus(String employeeId, bool isActive) async {
    await _supabase
        .from('profiles')
        .update({'is_active': isActive})
        .eq('id', employeeId);
  }

  Future<Map<String, dynamic>> getEmployeeAttendance(
    String employeeId, {
    int? month,
    int? year,
    int page = 0,
    int limit = 10,
  }) async {
    final now = DateTime.now();

    final selectedMonth = month ?? now.month;
    final selectedYear = year ?? now.year;

    final startDate = DateTime(selectedYear, selectedMonth, 1);

    final endDate = selectedMonth == 12
        ? DateTime(selectedYear + 1, 1, 1)
        : DateTime(selectedYear, selectedMonth + 1, 1);

    final from = page * limit;
    final to = from + limit - 1;

    final data = await _supabase
        .from('attendance')
        .select()
        .eq('employee_id', employeeId)
        .gte('attendance_date', startDate.toIso8601String().split('T').first)
        .lt('attendance_date', endDate.toIso8601String().split('T').first)
        .order('attendance_date', ascending: false)
        .range(from, to);

    final allRows = await _supabase
        .from('attendance')
        .select('id')
        .eq('employee_id', employeeId)
        .gte('attendance_date', startDate.toIso8601String().split('T').first)
        .lt('attendance_date', endDate.toIso8601String().split('T').first);

    return {
      'data': List<Map<String, dynamic>>.from(data),
      'count': allRows.length,
    };
  }

  Future<List<Map<String, dynamic>>> getAttendanceBreaks(
    String attendanceId,
  ) async {
    final response = await _supabase
        .from('attendance_breaks')
        .select()
        .eq('attendance_id', attendanceId);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getLeaveRequests() async {
    final response = await _supabase
        .from('leave_requests')
        .select()
        .order('applied_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getPendingLeaveRequests({
    int page = 0,
    int limit = pendingLeavePageSize,
  }) async {
    final start = page * limit;
    final end = start + limit - 1;

    final response = await _supabase
        .from('leave_requests')
        .select('''
        *,
        profiles!leave_requests_employee_id_fkey(
          full_name
        )
      ''')
        .eq('status', 'Pending')
        .order('applied_at', ascending: false)
        .range(start, end);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> approveLeave(String leaveId, String approverId) async {
    await _supabase
        .from('leave_requests')
        .update({
          'status': 'approved',
          'approved_by': approverId,
          'approved_at': DateTime.now().toIso8601String(),
        })
        .eq('id', leaveId);
  }

  Future<void> rejectLeave(String leaveId, String approverId) async {
    await _supabase
        .from('leave_requests')
        .update({
          'status': 'rejected',
          'approved_by': approverId,
          'approved_at': DateTime.now().toIso8601String(),
        })
        .eq('id', leaveId);
  }

  Future<List<Map<String, dynamic>>> getEmployeeActivities(
    String employeeId, {
    required int page,
    required int limit,
  }) async {
    final from = page * limit;
    final to = from + limit - 1;

    final response = await _supabase
        .from('employee_activity_logs')
        .select()
        .eq('employee_id', employeeId)
        .order('created_at', ascending: false)
        .range(from, to);

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

  Future<void> markAttendanceStatus({
    required String employeeId,
    required DateTime date,
    required String status,
    TimeOfDay? punchIn,
    TimeOfDay? punchOut,
  }) async {
    final dateString = date.toIso8601String().split('T').first;

    final existing = await _supabase
        .from('attendance')
        .select()
        .eq('employee_id', employeeId)
        .eq('attendance_date', dateString)
        .maybeSingle();

    Map<String, dynamic> attendanceData = {};

    if (status == 'Present') {
      final inDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        punchIn!.hour,
        punchIn.minute,
      );

      final outDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        punchOut!.hour,
        punchOut.minute,
      );

      final totalHours = outDateTime.difference(inDateTime).inMinutes / 60.0;

      final overtime = totalHours > 8 ? totalHours - 8 : 0;

      attendanceData = {
        'status': 'Present',
        'current_state': 'Completed',
        'punch_in': inDateTime.toUtc().toIso8601String(),
        'punch_out': outDateTime.toUtc().toIso8601String(),
        'total_hours': totalHours,
        'overtime_hours': overtime,
        'is_late':
            inDateTime.hour > 9 ||
            (inDateTime.hour == 9 && inDateTime.minute > 15),
      };
    } else {
      attendanceData = {
        'status': status,
        'current_state': 'Completed',
        'punch_in': null,
        'punch_out': null,
        'total_hours': 0,
        'overtime_hours': 0,
        'is_late': false,
      };
    }

    if (existing != null) {
      await _supabase
          .from('attendance')
          .update(attendanceData)
          .eq('id', existing['id']);
    } else {
      await _supabase.from('attendance').insert({
        'employee_id': employeeId,
        'attendance_date': dateString,
        ...attendanceData,
      });
    }

    final actor = authController.currentUser.value;

    await logActivity(
      employeeId: employeeId,
      title: 'Marked $status',
      activityType: 'ATTENDANCE_UPDATE',
      activitySource: actor?.role.toLowerCase() ?? 'system',
      actorId: actor?.id,
      actorName: actor?.fullName,
    );
  }

  Future<void> markAbsent(String employeeId) async {
    await _supabase.from('attendance').insert({
      'employee_id': employeeId,
      'attendance_date': DateTime.now().toIso8601String().split('T')[0],
      'status': 'Absent',
      'current_state': 'Absent',
    });

    final actor = authController.currentUser.value;

    await logActivity(
      employeeId: employeeId,
      title: 'Marked Absent',
      activityType: 'ATTENDANCE_UPDATE',
      activitySource: actor?.role.toLowerCase() ?? 'system',
      actorId: actor?.id,
      actorName: actor?.fullName,
    );
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

  Future<List<Map<String, dynamic>>> getLiveActivities({
    int page = 0,
    int limit = 5,
  }) async {
    final start = page * limit;
    final end = start + limit - 1;

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
        .range(start, end);

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
    await _supabase
        .from('profiles')
        .update({
          'full_name': fullName,
          'email': email,
          'phone': phone,
          'designation': designation,
          'is_active': isActive,
        })
        .eq('id', employeeId);

    final actor = authController.currentUser.value;

    await logActivity(
      employeeId: employeeId,
      title: 'Employee profile updated',
      activityType: 'PROFILE_UPDATED',
      activitySource: actor?.role.toLowerCase() ?? 'system',
      actorId: actor?.id,
      actorName: actor?.fullName,
    );
  }

  Future<Map<String, int>> getDashboardStats() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final employees = await _supabase
        .from('profiles')
        .select('id')
        .eq('role', 'Employee')
        .eq('is_active', true);

    final attendance = await _supabase
        .from('attendance')
        .select('status, is_late')
        .eq('attendance_date', today);

    final totalEmployees = employees.length;

    final presentToday = attendance
        .where((e) => (e['status'] ?? '').toString().toLowerCase() == 'present')
        .length;

    final lateToday = attendance.where((e) => e['is_late'] == true).length;

    final onLeaveToday = attendance
        .where((e) => (e['status'] ?? '').toString().toLowerCase() == 'leave')
        .length;

    return {
      'totalEmployees': totalEmployees,
      'presentToday': presentToday,
      'lateToday': lateToday,
      'onLeaveToday': onLeaveToday,
    };
  }

  Future<List<Map<String, dynamic>>> searchEmployees(String search) async {
    if (search.trim().isEmpty) return [];

    final response = await _supabase
        .from('profiles')
        .select()
        .eq('role', 'Employee')
        .or(
          'full_name.ilike.%$search%,employee_code.ilike.%$search%,designation.ilike.%$search%',
        )
        .limit(8);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> logActivity({
    required String employeeId,
    required String title,
    required String activityType,
    required String activitySource,
    String? actorId,
    String? actorName,
  }) async {
    await _supabase.from('employee_activity_logs').insert({
      'employee_id': employeeId,
      'title': title,
      'activity_type': activityType,
      'activity_source': activitySource,
      'actor_id': actorId,
      'actor_name': actorName,
      'activity_time': DateTime.now().toUtc().toIso8601String(),
    });
  }

  Future<void> createUser({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String designation,
    required String role,
  }) async {
    final response = await _supabase.functions.invoke(
      "create_new_user",
      body: {
        "full_name": fullName,
        "email": email,
        "password": password,
        "phone": phone,
        "designation": designation,
        "role": role,
      },
    );

    if (response.data["success"] != true) {
      throw Exception(response.data["message"]);
    }
  }
}
