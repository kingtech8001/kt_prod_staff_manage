import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LeaveService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getLeaves(String employeeId) async {
    final response = await supabase
        .from('leave_requests')
        .select()
        .eq('employee_id', employeeId)
        .order('applied_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> applyLeave({
    required String employeeId,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    await supabase.from('leave_requests').insert({
      'employee_id': employeeId,
      'leave_type': leaveType,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'reason': reason,
      'status': 'Pending',
    });
  }

  Future<Map<String, dynamic>?> getLeaveBalance(String employeeId) async {
    final response = await supabase
        .from('leave_balances')
        .select()
        .eq('employee_id', employeeId)
        .maybeSingle();

    return response;
  }

  Future<List<Map<String, dynamic>>> getRecentLeaveActivities(
    String employeeId,
  ) async {
    final response = await supabase
        .from('leave_requests')
        .select()
        .eq('employee_id', employeeId)
        .order('applied_at', ascending: false)
        .limit(2);

    return response.map<Map<String, dynamic>>((leave) {
      final status = leave['status'] as String;

      return {
        'title': status == 'Pending'
            ? 'Leave Request Submitted'
            : 'Leave Request $status',
        'status': status,
        'time': DateFormat(
          'dd MMM yyyy',
        ).format(DateTime.parse(leave['applied_at'])),
      };
    }).toList();
  }
}
