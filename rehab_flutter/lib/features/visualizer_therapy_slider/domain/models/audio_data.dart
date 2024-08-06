import 'dart:math';

class AudioData {
  final double time;
  final double subBass;
  final int noteOnset;
  final double bass;
  final double lowerMidrange;
  final double midrange;
  final double higherMidrange;
  final double presence;
  final double brilliance;
  final int? lineNumber;

  AudioData({
    required this.time,
    required this.subBass,
    required this.noteOnset,
    required this.bass,
    required this.lowerMidrange,
    required this.midrange,
    required this.higherMidrange,
    required this.presence,
    required this.brilliance,
    this.lineNumber,
  });

  factory AudioData.fromJson(Map<String, dynamic> json) {
    final Random random = Random();

    return AudioData(
      time: json['time'].toDouble(),
      subBass: json['sub_bass'].toDouble(),
      noteOnset: json['note_onset'],
      bass: json['bass'].toDouble(),
      lowerMidrange: json['lower_midrange'].toDouble(),
      midrange: json['midrange'].toDouble(),
      higherMidrange: json['higher_midrange'].toDouble(),
      presence: json['presence'].toDouble(),
      brilliance: json['brilliance'].toDouble(),
      lineNumber: random.nextInt(5),
    );
  }
}
