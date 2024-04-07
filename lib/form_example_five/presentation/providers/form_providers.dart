import 'package:flutter_riverpod/flutter_riverpod.dart';

class Patient {
  final String name;
  final String facility;
  final int clinicianId;

  Patient(this.name, this.facility, this.clinicianId);
}

class Service {
  final String name;

  Service(this.name);
}

final List<Patient> _patients = [
  Patient('Patient A', 'Facility A', 1),
  Patient('Patient B', 'Facility A', 1),
  Patient('Patient C', 'Facility B', 2),
  Patient('Patient D', 'Facility B', 2),
  Patient('Patient E', 'Facility C', 3),
  Patient('Patient F', 'Facility C', 3),
  Patient('Patient G', 'Facility D', 4),
  Patient('Patient H', 'Facility D', 4),
];

final List<Service> _services = [
  Service('Service A'),
  Service('Service B'),
  Service('Service C'),
  Service('Service D'),
];

const int currentUserId = 1;

final facilityProvider =
    Provider.autoDispose.family<List<String>, bool>((_, showAllPatients) {
  return _patients
      .where(
          (patient) => showAllPatients || patient.clinicianId == currentUserId)
      .map((patient) => patient.facility)
      .toSet()
      .toList();
});

final patientProvider =
    Provider.autoDispose.family<List<Patient>, (bool, String?)>((_, data) {
  final (showAllPatients, facility) = data;

  if (facility == null) {
    return [];
  }

  return _patients
      .where(
          (patient) => showAllPatients || patient.clinicianId == currentUserId)
      .where((patient) => patient.facility == facility)
      .toList();
});
final serviceProvider = Provider.autoDispose<List<Service>>((_) {
  return _services;
});
