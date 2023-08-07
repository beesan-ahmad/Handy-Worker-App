
class Worker {
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

  Worker({
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

  });

  factory Worker.fromMap(Map<String, dynamic> map) {
    return Worker(
      uid: map['uid'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      service: map['service'],
      city: map['city'],
      phone: map['phone'],
      email: map['email'],
      photoUrl: map['photoUrl'],
      description: map['description'],
      availability: Map<String, String>.from(map['availability']),
    mediaUrls: map['mediaUrls'] != null ? List<String>.from(map['mediaUrls']) : [],    
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'service': service,
      'city': city,
      'phone': phone,
      'email': email,
      'photoUrl': photoUrl,
      'description': description,
      'availability': availability,
    };
  }

    }





// import 'package:cloud_firestore/cloud_firestore.dart';

// class Worker {
//   final String uid;
//   final String firstName;
//   final String lastName;
//   final String service;
//   final String city;
//   final String phone;
//   final String email;
//   final String photoUrl;
//   final String description;
//   final Map<String, String> availability;
//   final List<String> mediaUrls; 
//   final double rating;
//   final int numReviews;

//   Worker({
//     required this.uid,
//     required this.firstName,
//     required this.lastName,
//     required this.service,
//     required this.city,
//     required this.phone,
//     required this.email,
//     required this.photoUrl,
//     required this.description,
//     required this.availability,
//     required this.mediaUrls,
//     required this.rating,
//     required this.numReviews,

//   });

//   factory Worker.fromMap(Map<String, dynamic> map) {
//     return Worker(
//       uid: map['uid'],
//       firstName: map['firstName'],
//       lastName: map['lastName'],
//       service: map['service'],
//       city: map['city'],
//       phone: map['phone'],
//       email: map['email'],
//       photoUrl: map['photoUrl'],
//       description: map['description'],
//       availability: Map<String, String>.from(map['availability']),
//       mediaUrls: List<String>.from(map['mediaUrls']),
//       rating: map['rating'],
//       numReviews: map['numReviews'],
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'uid': uid,
//       'firstName': firstName,
//       'lastName': lastName,
//       'service': service,
//       'city': city,
//       'phone': phone,
//       'email': email,
//       'photoUrl': photoUrl,
//       'description': description,
//       'availability': availability,
//     };
//   }



//   factory Worker.fromSnapshot(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;

//     return Worker(
//        uid: data['uid'],
//       firstName: data['firstName'],
//       lastName: data['lastName'],
//       service: data['service'],
//       city: data['city'],
//       phone: data['phone'],
//       email: data['email'],
//       photoUrl: data['photoUrl'],
//       description: data['description'],
//       availability: Map<String, String>.from(data['availability']),
//       mediaUrls: List<String>.from(data['mediaUrls']),
//       rating: data['rating'],
//       numReviews: data['numReviews'],
//     );
//   }

//     }