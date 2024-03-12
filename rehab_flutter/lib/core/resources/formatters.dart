String secToMinSec(double duration) {
  int minutes = duration ~/ 60;
  int remainingSeconds = (duration % 60).floor();

  return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
}
