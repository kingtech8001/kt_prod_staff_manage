import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(String? value) {
    if (value == null || value.isEmpty) return '00';

    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(value).toLocal());
    } catch (_) {
      return '00';
    }
  }

  static String formatTime(String? value) {
    if (value == null || value.isEmpty) return '--';

    try {
      return DateFormat('hh:mm a').format(DateTime.parse(value).toLocal());
    } catch (_) {
      return '00';
    }
  }

  static String formatDateTime(String? value) {
    if (value == null || value.isEmpty) return '00';

    try {
      return DateFormat('dd MMM yyyy • hh:mm a').format(DateTime.parse(value).toLocal());
    } catch (_) {
      return '00';
    }
  }

  static String formatMonthDay(String? value) {
    if (value == null || value.isEmpty) return '--';

    try {
      return DateFormat('MMM dd').format(DateTime.parse(value).toLocal());
    } catch (_) {
      return '--';
    }
  }
}
