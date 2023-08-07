import 'package:cloud_firestore/cloud_firestore.dart';

class Worker {
  final String id;
  final String firstName;
  final String lastName;
  final String phone;

  Worker({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  factory Worker.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Worker(
      id: doc.id,
      firstName: data['first name'] ?? '',
      lastName: data['last name'] ?? '',
      phone: data['location'] ?? '',
    );
  }
}
