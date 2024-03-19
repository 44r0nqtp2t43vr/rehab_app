class AppUser {
  final String userId;
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String phoneNumber;
  final String city;
  final DateTime birthDate;
  final List<String> conditions;

  AppUser({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.phoneNumber,
    required this.city,
    required this.birthDate,
    required this.conditions,
  });
}
