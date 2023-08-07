
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final User? worker = FirebaseAuth.instance.currentUser;
final email = worker?.email;

class Worker {
  final String id;
  final String uid;
  final String firstName;
  final String lastName;
  final String service;
  final String city;
  final String phone;
  final String email;
  final String photoUrl;
  final String description;
  final Map<String, String> availability;
  final List<String> mediaUrls;
  final double rating;
  final int numReviews;

  Worker({
    required this.id,
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.service,
    required this.city,
    required this.phone,
    required this.email,
    required this.photoUrl,
    required this.description,
    required this.availability,
    required this.mediaUrls,
    this.numReviews = 0,
    this.rating = 0.0,
    
  });
  factory Worker.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Worker(
      id: doc.id,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      service: data['service'] ?? '',
      city: data['city'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      description: data['description'] ?? '',
      availability: Map<String, String>.from(data['availability'] ?? {}),
      mediaUrls:
          data['mediaUrls'] != null ? List<String>.from(data['mediaUrls']) : [],
      uid: data['uid'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      numReviews: data['numReviews'] ?? 0,
    );
  }

  // static Future<Worker?> getWorkerByEmail(String email) async {
  //   final querySnapshot = await FirebaseFirestore.instance
  //       .collection('workers')
  //       .where('email', isEqualTo: email)
  //       .limit(1)
  //       .get();

  //   if (querySnapshot.docs.isEmpty) {
  //     return null;
  //   }

  //   final doc = querySnapshot.docs.first;
  //   return Worker.fromSnapshot(doc);
  // }
  // read one worker
// static Future<Worker?> getWorkerByEmail(String email) async {
//   final workerRef = FirebaseFirestore.instance.collection('workers').doc(email);

//   final workerSnapshot = await workerRef.get();

//   if (!workerSnapshot.exists) {
//     return null;
//   }

//   return Worker.fromSnapshot(workerSnapshot);
// }

// static Future<Worker?> getWorkerByEmail(String email) async {
//   final workersRef = FirebaseFirestore.instance.collection('workers');
//   final querySnapshot = await workersRef.where('email', isEqualTo: email).get();

//   if (querySnapshot.docs.isEmpty) {
//     return null;
//   }

//   final workerSnapshot = querySnapshot.docs.first;
//   return Worker.fromSnapshot(workerSnapshot);
// }

  // read workers
  // static Future<List<Worker>> getWorkers() async {
  //   final workersRef = FirebaseFirestore.instance.collection('workers');
  //   final workersSnapshots = await workersRef.get();

  //   final workers = <Worker>[];
  //   for (final workerSnapshot in workersSnapshots.docs) {
  //     final worker = Worker.fromSnapshot(workerSnapshot);
  //     workers.add(worker);
  //   }

  //   return workers;
  // }

  // update method
  // static Future<void> update(
  //   String id, {
  //   String? firstName,
  //   String? lastName,
  //   String? service,
  //   String? city,
  //   String? phone,
  //   String? email,
  //   String? photoUrl,
  //   String? description,
  //   Map<String, String>? availability,
  // }) async {
  //   try {
  //     // Get the document reference for the worker document
  //     final docRef = FirebaseFirestore.instance.collection('workers').doc(id);

  //     // Create a map of the updated data
  //     final updateData = {
  //       if (firstName != null) 'firstName': firstName,
  //       if (lastName != null) 'lastName': lastName,
  //       if (service != null) 'service': service,
  //       if (city != null) 'city': city,
  //       if (phone != null) 'phone': phone,
  //       if (email != null) 'email': email,
  //       if (photoUrl != null) 'photoUrl': photoUrl,
  //       if (description != null) 'description': description,
  //       if (availability != null) 'availability': availability,
  //     };

  //     // Update the document in Cloud Firestore
  //     await docRef.update(updateData);
  //   } catch (e) {
  //     print('Error updating worker document: $e');
  //     rethrow;
  //   }
  // }

  //add worker
  static Future<void> postWorker({
    required String firstName,
    required String lastName,
    required String service,
    required String city,
    required String phone,
    required String email,
    required String photoUrl,
    required String description,
    required Map<String, String> availability,
  }) async {
    final workerRef = FirebaseFirestore.instance.collection('workers');
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final User? user = FirebaseAuth.instance.currentUser;

    await workerRef.add({
      'firstName': firstName,
      'lastName': lastName,
      'service': service,
      'city': city,
      'phone': phone,
      'email': email,
      'photoUrl': photoUrl,
      'description': description,
      'availability': availability,
      'uid': user!.uid,
    });
  }

// static Future<Map<String, dynamic>> getWorkerByUid(String uid) async {
//   final workerRef = FirebaseFirestore.instance.collection('workers');
//   final workerSnapshot = await workerRef.where('uid', isEqualTo: uid).get();
//   if (workerSnapshot.docs.isEmpty) {
//     return {}; // return an empty map if the worker is not found
//   } else {
//     final workerData = workerSnapshot.docs.first.data();
//     workerData['id'] = workerSnapshot.docs.first.id; // add the worker document id to the map
//     return workerData; // return the worker data as a map
//   }
// }
}
