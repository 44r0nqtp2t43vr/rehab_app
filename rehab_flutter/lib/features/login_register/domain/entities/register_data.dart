class RegisterData {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String gender;
  final String phoneNumber;
  final String city;
  final List<String> conditions;

  RegisterData({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.gender,
    required this.phoneNumber,
    required this.city,
    required this.conditions,
  });
}
