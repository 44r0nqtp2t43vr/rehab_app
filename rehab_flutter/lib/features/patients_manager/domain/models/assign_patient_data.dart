class AssignPatientData {
  final String physicianId;
  final String patientId;
  final List<String> patients;
  final bool isAssign;

  AssignPatientData({
    required this.physicianId,
    required this.patientId,
    required this.patients,
    this.isAssign = true,
  });
}
