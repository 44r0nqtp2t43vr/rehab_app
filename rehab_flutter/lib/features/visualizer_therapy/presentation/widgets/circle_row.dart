import 'package:flutter/material.dart';
import 'package:rehab_flutter/features/visualizer_therapy/presentation/widgets/circle_painter.dart';

class CircleRow extends StatelessWidget {
  const CircleRow(
      {super.key,
      required AnimationController? animationController,
      required double circleWidth,
      required double midRange,
      required double rayHeight,
      required double circleHeight,
      required double rayWidth})
      : _animationController = animationController,
        _circleWidth = circleWidth,
        _midRange = midRange,
        _rayHeight = rayHeight,
        _circleHeight = circleHeight,
        _rayWidth = rayWidth;

  final AnimationController? _animationController;
  final double _circleWidth;
  final double _circleHeight;
  final double _midRange;
  final double _rayWidth;
  final double _rayHeight;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: AnimatedBuilder(
              animation: _animationController!,
              builder: (_, child) {
                // Use TweenAnimationBuilder for smooth transitions
                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: _circleWidth),
                  duration: const Duration(
                      milliseconds: 1000), // Adjust this duration as needed
                  builder: (context, circleWidth, child) {
                    return CustomPaint(
                      painter: RayPainter(
                          progress: _animationController.value,
                          circleWidth: _circleWidth,
                          circleHeight: _circleHeight,
                          rayHeight: _rayHeight,
                          rayWidth: _rayWidth,
                          midRange: _midRange),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            width: 100,
            height: 100,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (_, child) {
                // Use TweenAnimationBuilder for smooth transitions
                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: _circleWidth),
                  duration: const Duration(
                      milliseconds: 1000), // Adjust this duration as needed
                  builder: (context, circleWidth, child) {
                    return CustomPaint(
                      painter: RayPainter(
                          progress: _animationController.value,
                          circleWidth: _circleWidth,
                          circleHeight: _circleHeight,
                          rayHeight: _rayHeight,
                          rayWidth: _rayWidth,
                          midRange: _midRange),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            width: 100,
            height: 100,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (_, child) {
                // Use TweenAnimationBuilder for smooth transitions
                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: _circleWidth),
                  duration: const Duration(
                      milliseconds: 2000), // Adjust this duration as needed
                  builder: (context, circleWidth, child) {
                    return CustomPaint(
                      painter: RayPainter(
                          progress: _animationController.value,
                          circleWidth: _circleWidth,
                          rayHeight: _rayHeight,
                          circleHeight: _circleHeight,
                          rayWidth: _rayWidth,
                          midRange: _midRange),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            width: 100,
            height: 100,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (_, child) {
                // Use TweenAnimationBuilder for smooth transitions
                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: _circleWidth),
                  duration: const Duration(
                      milliseconds: 2000), // Adjust this duration as needed
                  builder: (context, circleWidth, child) {
                    return CustomPaint(
                      painter: RayPainter(
                          progress: _animationController.value,
                          circleWidth: _circleWidth,
                          circleHeight: _circleHeight,
                          rayHeight: _rayHeight,
                          rayWidth: _rayWidth,
                          midRange: _midRange),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
