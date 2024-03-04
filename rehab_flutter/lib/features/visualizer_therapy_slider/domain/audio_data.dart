class AudioData {
  final double time;
  final double subBass;
  final double bass;
  final double lowerMidrange;
  final double midrange;
  final double higherMidrange;
  final double presence;
  final double brilliance;
  final int count;

  AudioData({
    required this.time,
    required this.subBass,
    required this.bass,
    required this.lowerMidrange,
    required this.midrange,
    required this.higherMidrange,
    required this.presence,
    required this.brilliance,
    required this.count,
  });

  factory AudioData.fromJson(Map<String, dynamic> json) {
    return AudioData(
      time: json['time'] as double,
      subBass: json['sub_bass'] as double,
      bass: json['bass'] as double,
      lowerMidrange: json['lower_midrange'] as double,
      midrange: json['midrange'] as double,
      higherMidrange: json['higher_midrange'] as double,
      presence: json['presence'] as double,
      brilliance: json['brilliance'] as double,
      count: json['count'] as int,
    );
  }
}
