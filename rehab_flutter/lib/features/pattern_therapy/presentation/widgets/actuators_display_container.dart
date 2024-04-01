import 'package:flutter/material.dart';
import 'package:rehab_flutter/features/pattern_therapy/presentation/widgets/actuator_display_grid.dart';

class ActuatorsDisplayContainer extends StatelessWidget {
  final double height;
  final double gridSize;
  final bool isLeftHand;
  final List<bool> circleStates;

  const ActuatorsDisplayContainer({
    super.key,
    required this.height,
    required this.gridSize,
    required this.isLeftHand,
    required this.circleStates,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: const Color(0xff223E64),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ActuatorDisplayGrid(
                      size: gridSize,
                      patternData: circleStates,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isLeftHand ? "Pinky" : "Thumb",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ActuatorDisplayGrid(
                      size: gridSize,
                      patternData: circleStates,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isLeftHand ? "Ring" : "Index",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ActuatorDisplayGrid(
                      size: gridSize,
                      patternData: circleStates,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Middle",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ActuatorDisplayGrid(
                      size: gridSize,
                      patternData: circleStates,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isLeftHand ? "Index" : "Ring",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ActuatorDisplayGrid(
                      size: gridSize,
                      patternData: circleStates,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isLeftHand ? "Thumb" : "Pinky",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
