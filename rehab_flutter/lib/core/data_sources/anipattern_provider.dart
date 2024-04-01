import 'dart:ui';

class AniPatternProvider {
  static Offset verticalPattern(double imageSize, double animationValue) {
    const double padding = 30;
    double adjustedX = 0;
    double adjustedY = 0;

    final List<double> xPoints = [
      (imageSize / 4),
      imageSize / 2,
      (imageSize / 4 * 3),
    ];
    if (animationValue >= 0.00 && animationValue <= 0.30) {
      adjustedX = xPoints[0] + padding;
      adjustedY = (imageSize - padding * 2) * (animationValue / 0.30) + padding;
    } else if (animationValue > 0.30 && animationValue < 0.35) {
      adjustedX = (xPoints[0] + padding) + ((xPoints[0] - padding) * ((animationValue - 0.30) / 0.05));
      adjustedY = imageSize - padding;
    } else if (animationValue >= 0.35 && animationValue <= 0.65) {
      adjustedX = xPoints[1];
      adjustedY = (imageSize - padding * 2) * ((0.65 - animationValue) / 0.30) + padding;
    } else if (animationValue > 0.65 && animationValue < 0.70) {
      adjustedX = xPoints[1] + (xPoints[0] - padding) * ((animationValue - 0.65) / 0.05);
      adjustedY = padding;
    } else if (animationValue >= 0.70 && animationValue <= 1.0) {
      adjustedX = xPoints[2] - padding;
      adjustedY = (imageSize - padding * 2) * ((animationValue - 0.70) / 0.30) + padding;
    }
    // final adjustedX = imageSize / 2;
    // final adjustedY = imageSize * animationValue;
    return Offset(adjustedX, adjustedY);
  }

  static Offset horizontalPattern(double imageSize, double animationValue) {
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

  static Offset doubleVPattern(double imageSize, double animationValue) {
    const double padding = 24;
    double xUnit = imageSize / 4;
    double yUnit = imageSize - (padding * 2);
    double adjustedX = 0;
    double adjustedY = 0;

    final List<double> xPoints = [
      xUnit + padding,
      xUnit * 2,
      xUnit * 3 - padding,
    ];

    final List<double> yPoints = [
      padding,
      imageSize - padding,
    ];

    if (animationValue >= 0.00 && animationValue <= 0.25) {
      adjustedX = xPoints[0];
      adjustedY = yPoints[0] + (yUnit * (animationValue / 0.25));
    } else if (animationValue >= 0.25 && animationValue <= 0.50) {
      adjustedX = xPoints[0] + ((xPoints[1] - xPoints[0]) * ((animationValue - 0.25) / 0.25));
      adjustedY = yPoints[1] - (yUnit * ((animationValue - 0.25) / 0.25));
    } else if (animationValue >= 0.50 && animationValue <= 0.75) {
      adjustedX = xPoints[1] + ((xPoints[2] - xPoints[1]) * ((animationValue - 0.50) / 0.25));
      adjustedY = yPoints[0] + (yUnit * ((animationValue - 0.50) / 0.25));
    } else if (animationValue >= 0.75 && animationValue <= 1.0) {
      adjustedX = xPoints[2];
      adjustedY = yPoints[1] - (yUnit * ((animationValue - 0.75) / 0.25));
    }

    return Offset(adjustedX, adjustedY);
  }
}
