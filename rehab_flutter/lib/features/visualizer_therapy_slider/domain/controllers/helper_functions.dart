bool getBassBoolValue(double value) {
  if (value < 0.175) {
    return false;
  } else {
    return true;
  }
}

bool getSubBassBoolValue(double value) {
  if (value < 0.009) {
    return false;
  } else {
    return true;
  }
}

bool getLowerMidrangeBoolValue(double value) {
  if (value < 0.2) {
    return false;
  } else {
    return true;
  }
}

bool getMidrangeBoolValue(double value) {
  if (value < 0.2) {
    return false;
  } else {
    return true;
  }
}

bool getUpperMidrangeBoolValue(double value) {
  if (value < 0.2) {
    return false;
  } else {
    return true;
  }
}

bool getPresenceBoolValue(double value) {
  if (value < 0.08) {
    return false;
  } else {
    return true;
  }
}

bool getBrillianceBoolValue(double value) {
  if (value < 0.09) {
    return false;
  } else {
    return true;
  }
}

// bool isZero(double value) {
//   if (value == 0) {
//     return false;
//   } else {
//     return true;
//   }
// }
