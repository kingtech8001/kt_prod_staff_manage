class AttendanceModel {
  final String id;
  final String employeeId;
  final DateTime attendanceDate;
  final DateTime? punchIn;
  final DateTime? punchOut;
  final double? totalHours;
  final String status;

  AttendanceModel({required this.id, required this.employeeId, required this.attendanceDate, this.punchIn, this.punchOut, this.totalHours, required this.status});

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'],
      employeeId: json['employee_id'],
      attendanceDate: DateTime.parse(json['attendance_date']),
      punchIn: json['punch_in'] != null ? DateTime.parse(json['punch_in']) : null,
      punchOut: json['punch_out'] != null ? DateTime.parse(json['punch_out']) : null,
      totalHours: json['total_hours']?.toDouble(),
      status: json['status'],
    );
  }
}
