class TestingItem {
  final String test;
  final int itemNumber;
  final String itemName;
  final String itemType;
  final double itemAccuracy;

  TestingItem({required this.test, required this.itemNumber, required this.itemName, required this.itemType, required this.itemAccuracy});

  Map<String, dynamic> toMap() {
    return {
      'test': test,
      'itemNumber': itemNumber,
      'itemName': itemName,
      'itemType': itemType,
      'itemAccuracy': itemAccuracy,
    };
  }
}
