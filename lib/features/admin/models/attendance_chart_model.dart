import 'package:intl/intl.dart';

class AttendanceChartModel {
  final DateTime date;
  final double totalHours;
  final double overtimeHours;

  const AttendanceChartModel({
    required this.date,
    required this.totalHours,
    required this.overtimeHours,
  });

  /// Maximum regular working hours displayed in the chart.
  double get regularHours => totalHours > 8 ? 8 : totalHours;

  String get weekLabel => DateFormat('EEE').format(date);

  String get dayLabel => DateFormat('d').format(date);

  String get fullDate => DateFormat('dd MMM yyyy').format(date);

  /// Creates model from Supabase row.
  factory AttendanceChartModel.fromMap(Map<String, dynamic> map) {
    return AttendanceChartModel(
      date: DateTime.parse(map['attendance_date']),
      totalHours: ((map['total_hours'] ?? 0) as num).toDouble(),
      overtimeHours: ((map['overtime_hours'] ?? 0) as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'attendance_date': date.toIso8601String(),
      'total_hours': totalHours,
      'overtime_hours': overtimeHours,
    };
  }
}
