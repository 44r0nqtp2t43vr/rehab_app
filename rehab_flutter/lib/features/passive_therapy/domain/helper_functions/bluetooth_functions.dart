import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/injection_container.dart';

String sendPattern(List<int> first, List<int> second, List<int> third,
    List<int> fourth, List<int> fifth, String lastSentPattern) {
  String firstLeft = first[0].toString().padLeft(3, '0');
  String firstRight = first[1].toString().padLeft(3, '0');
  String secondLeft = second[0].toString().padLeft(3, '0');
  String secondRight = second[1].toString().padLeft(3, '0');
  String thirdLeft = third[0].toString().padLeft(3, '0');
  String thirdRight = third[1].toString().padLeft(3, '0');
  String fourthLeft = fourth[0].toString().padLeft(3, '0');
  String fourthRight = fourth[1].toString().padLeft(3, '0');
  String fifthLeft = fifth[0].toString().padLeft(3, '0');
  String fifthRight = fifth[1].toString().padLeft(3, '0');
  String data =
      "<$firstLeft$firstRight$secondLeft$secondRight$thirdLeft$thirdRight$fourthLeft$fourthRight$fifthLeft$fifthRight>";

  // Check if the data to be sent is different from the last sent pattern
  if (data != lastSentPattern) {
    sl<BluetoothBloc>().add(WriteDataEvent(data));
    debugPrint("Pattern sent: $data");
    return data; // Update the last sent pattern
  } else {
    debugPrint("Pattern not sent, identical to last pattern.");
    return data;
  }
}

void printSums(List<List<int>> sums) {
  for (int i = 0; i < sums.length; i++) {
    print("Finger ${i + 1}: sum1: ${sums[i][0]}, sum2: ${sums[i][1]}");
  }
}

List<int> calculateSums(List<List<int>> fingerPatterns, int currentFrame,
    List<int> values, List<int> sumOneIndices) {
  int sumOne = 0;
  int sumTwo = 0;
  for (int index = 0; index < fingerPatterns[currentFrame].length; index++) {
    if (fingerPatterns[currentFrame][index] == 1) {
      if (sumOneIndices.contains(index)) {
        sumOne += values[index];
      } else {
        sumTwo += values[index];
      }
    }
  }
  return [sumOne, sumTwo];
}
