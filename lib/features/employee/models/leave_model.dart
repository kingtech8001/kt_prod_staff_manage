class LeaveModel {
  final String id;
  final String employeeId;
  final String leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String status;
  final DateTime appliedAt;

  LeaveModel({
    required this.id,
    required this.employeeId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    required this.appliedAt,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id: json['id'],
      employeeId: json['employee_id'],
      leaveType: json['leave_type'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      reason: json['reason'],
      status: json['status'],
      appliedAt: DateTime.parse(json['applied_at']),
    );
  }
}
