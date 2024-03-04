class ActuatorsImageData {
  final String src;
  final bool preload;
  final bool resetActuators;
  final int rotateFactor;

  ActuatorsImageData({required this.src, required this.preload, this.resetActuators = true, this.rotateFactor = 0});
}
