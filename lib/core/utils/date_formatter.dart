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
      return DateFormat(
        'dd MMM yyyy • hh:mm a',
      ).format(DateTime.parse(value).toLocal());
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

  static String formatHours(num? hours) {
    if (hours == null || hours <= 0) return "00:00";

    final totalMinutes = (hours * 60).round();

    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;

    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  static String formatRelativeTime(String? value) {
    if (value == null || value.isEmpty) return '--';

    try {
      final date = DateTime.parse(value).toLocal();
      final difference = DateTime.now().difference(date);

      if (difference.inSeconds < 60) {
        return 'Just now';
      }

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} min ago';
      }

      if (difference.inHours < 24) {
        return '${difference.inHours} hrs ago';
      }

      if (difference.inDays == 1) {
        return 'Yesterday';
      }

      if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      }

      return DateFormat('dd MMM').format(date);
    } catch (_) {
      return '--';
    }
  }
}
