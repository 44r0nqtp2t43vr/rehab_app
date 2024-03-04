import 'dart:ui';

class AniPatternProvider {
  Offset verticalPattern(double imageSize, double animationValue) {
    double adjustedX = 0;
    double adjustedY = 0;
    final List<double> xPoints = [
      imageSize / 4,
      imageSize / 2,
      imageSize / 4 * 3,
    ];
    if (animationValue >= 0.00 && animationValue <= 0.30) {
      adjustedX = xPoints[0];
      adjustedY = imageSize * (animationValue / 0.30);
    } else if (animationValue > 0.30 && animationValue < 0.35) {
      adjustedX = xPoints[0] + xPoints[0] * ((animationValue - 0.30) / 0.05);
      adjustedY = imageSize;
    } else if (animationValue >= 0.35 && animationValue <= 0.65) {
      adjustedX = xPoints[1];
      adjustedY = imageSize * ((0.65 - animationValue) / 0.30);
    } else if (animationValue > 0.65 && animationValue < 0.70) {
      adjustedX = xPoints[1] + xPoints[0] * ((animationValue - 0.65) / 0.05);
      adjustedY = 0;
    } else if (animationValue >= 0.70 && animationValue <= 1.0) {
      adjustedX = xPoints[2];
      adjustedY = imageSize * ((animationValue - 0.70) / 0.30);
    }
    // final adjustedX = imageSize / 2;
    // final adjustedY = imageSize * animationValue;
    return Offset(adjustedX, adjustedY);
  }

  Offset horizontalPattern(double imageSize, double animationValue) {
    double adjustedX = 0;
    double adjustedY = 0;
    final List<double> yPoints = [
      imageSize / 4,
      imageSize / 2,
      imageSize / 4 * 3,
    ];
    if (animationValue >= 0.00 && animationValue <= 0.30) {
      adjustedX = imageSize - imageSize * (animationValue / 0.30);
      adjustedY = yPoints[0];
    } else if (animationValue > 0.30 && animationValue < 0.35) {
      adjustedX = 0;
      adjustedY = yPoints[0] + yPoints[0] * ((animationValue - 0.30) / 0.05);
    } else if (animationValue >= 0.35 && animationValue <= 0.65) {
      adjustedX = imageSize * ((animationValue - 0.35) / 0.30);
      adjustedY = yPoints[1];
    } else if (animationValue > 0.65 && animationValue < 0.70) {
      adjustedX = imageSize;
      adjustedY = yPoints[1] + yPoints[0] * ((animationValue - 0.65) / 0.05);
    } else if (animationValue >= 0.70 && animationValue <= 1.0) {
      adjustedX = imageSize - imageSize * ((animationValue - 0.70) / 0.30);
      adjustedY = yPoints[2];
    }
    return Offset(adjustedX, adjustedY);
  }
}
