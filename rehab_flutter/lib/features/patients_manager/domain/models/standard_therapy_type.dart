class StandardTherapyType {
  final String title;
  final String value;

  const StandardTherapyType({required this.title, required this.value});

  static StandardTherapyType empty() {
    return const StandardTherapyType(title: "", value: "");
  }
}
