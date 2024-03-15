String secToMinSec(double duration) {
  int minutes = duration ~/ 60;
  int remainingSeconds = (duration % 60).floor();

  return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
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
