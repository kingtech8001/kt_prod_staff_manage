import 'package:flutter/material.dart';

class ActivityFormatter {
  static String title(Map<String, dynamic> activity) {
    switch (activity['activity_type']) {
      case 'PUNCH_IN':
        return 'Punched In';

      case 'PUNCH_OUT':
        return 'Punched Out';

      case 'BREAK_START':
        return 'Started Break';

      case 'BREAK_END':
        return 'Ended Break';

      case 'PROFILE_UPDATED':
        return 'Profile Updated';

      case 'PROFILE_CREATED':
        return 'Employee Created';

      case 'ATTENDANCE_UPDATE':
        return activity['title'] ?? 'Attendance Updated';

      default:
        return activity['title'] ?? 'Activity';
    }
  }

  static String description(
    Map<String, dynamic> activity,
    String employeeName,
  ) {
    switch (activity['activity_type']) {
      case 'PUNCH_IN':
        return "$employeeName punched in for today's shift.";

      case 'PUNCH_OUT':
        return '$employeeName punched out for the day.';

      case 'BREAK_START':
        return '$employeeName started a break.';

      case 'BREAK_END':
        return '$employeeName ended the break and resumed work.';

      case 'PROFILE_UPDATED':
        return '${activity['actor_name']} updated this employee profile.';

      case 'PROFILE_CREATED':
        return '${activity['actor_name']} created this employee profile.';

      case 'ATTENDANCE_UPDATE':
        return '${activity['actor_name']} ${activity['title']?.toString().toLowerCase()}.';

      default:
        return activity['title'] ?? '';
    }
  }
}

class ActivityIcon {
  static IconData icon(String type) {
    switch (type) {
      case 'PUNCH_IN':
        return Icons.login;

      case 'PUNCH_OUT':
        return Icons.logout;

      case 'BREAK_START':
        return Icons.free_breakfast;

      case 'BREAK_END':
        return Icons.play_arrow_rounded;

      case 'PROFILE_UPDATED':
        return Icons.edit;

      case 'PROFILE_CREATED':
        return Icons.person_add;

      case 'ATTENDANCE_UPDATE':
        return Icons.fact_check;

      default:
        return Icons.history;
    }
  }

  static Color color(String type) {
    switch (type) {
      case 'PUNCH_IN':
        return Colors.green;

      case 'PUNCH_OUT':
        return Colors.red;

      case 'BREAK_START':
        return Colors.orange;

      case 'BREAK_END':
        return Colors.blue;

      case 'PROFILE_UPDATED':
        return Colors.indigo;

      case 'PROFILE_CREATED':
        return Colors.purple;

      case 'ATTENDANCE_UPDATE':
        return Colors.teal;

      default:
        return Colors.grey;
    }
  }
}
