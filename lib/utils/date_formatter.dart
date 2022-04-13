import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter();

  String getVerboseDateTimeRepresentation(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime justNow = now.subtract(const Duration(minutes: 1));
    DateTime localDateTime = dateTime.toLocal();

    if (!localDateTime.difference(justNow).isNegative) {
      return 'Прямо сейчас';
    }

    String roughTimeString = DateFormat('jm').format(dateTime);

    if (localDateTime.day == now.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return roughTimeString;
    }

    DateTime yesterday = now.subtract(const Duration(days: 1));

    if (localDateTime.day == yesterday.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return 'Вчера';
    }

    if (now.difference(localDateTime).inDays < 4) {
      String weekday = DateFormat('jm').format(localDateTime);

      return '$weekday, $roughTimeString';
    }

    return '${DateFormat('jm').format(dateTime)}, $roughTimeString';
  }
}
