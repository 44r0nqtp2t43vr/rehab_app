import 'package:intl/intl.dart';

String secToMinSec(double duration) {
  int minutes = duration ~/ 60;
  int remainingSeconds = (duration % 60).floor();

  return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
}

String getMonth(int monthNum) {
  switch (monthNum) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';
    default:
      return 'January';
  }
}

String getDayOfWeek(int weekday) {
  switch (weekday) {
    case 1:
      return 'Mon';
    case 2:
      return 'Tue';
    case 3:
      return 'Wed';
    case 4:
      return 'Thu';
    case 5:
      return 'Fri';
    case 6:
      return 'Sat';
    case 7:
      return 'Sun';
    default:
      return '';
  }
}

String formatDateMMDDYYYY(DateTime date) {
  final DateFormat formatter = DateFormat('MMddyyyy');
  return formatter.format(date);
}

DateTime parseMMDDYYYY(String dateString) {
  // final DateFormat formatter = DateFormat('MMddyyyy');
  // return formatter.parseStrict(dateString, true);
  final monthString = "${dateString[0]}${dateString[1]}";
  final dayString = "${dateString[2]}${dateString[3]}";
  final yearString = "${dateString[4]}${dateString[5]}${dateString[6]}${dateString[7]}";
  return DateTime(int.parse(yearString), int.parse(monthString), int.parse(dayString));
}

String formatDateMMDD(DateTime date) {
  final DateFormat formatter = DateFormat('MM/dd');
  return formatter.format(date);
}

String formatDateMMDDYYYYY(DateTime date) {
  final DateFormat formatter = DateFormat('MM/dd/yyyy');
  return formatter.format(date);
}

String formatDateToDayMonth(DateTime date) {
  final DateFormat formatter = DateFormat('E, MMM d');
  return formatter.format(date);
}
