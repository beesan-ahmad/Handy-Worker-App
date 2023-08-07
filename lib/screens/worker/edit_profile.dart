// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:handyworker/models/worker.dart';

// import '../../reusable_widgets/widget/textfield_widget.dart';

// class EditProfilePage extends StatefulWidget {
//   const EditProfilePage({Key? key, required String uid}) : super(key: key);

//   @override
//   _EditProfilePageState createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   @override
//   void initState() {
//     super.initState();
//     final user = FirebaseAuth.instance.currentUser;
//     email = user?.email ?? ' ';
//     name;
//     service;
//     city;
//     phone;
//     photoUrl;
//     description;
//     id;
//     _loadData();
//   }

//   late String email;
//   late String name = "";
//   late String id = "";

//   late String service = "";
//   late String city = "";
//   late String phone = "";
//   late String photoUrl = "";
//   late String description = "";

//   Future<void> _loadData() async {
//     final uEmail = FirebaseAuth.instance.currentUser!.email;
//     final querySnapshot = await FirebaseFirestore.instance
//         .collection('workers')
//         .where('email', isEqualTo: uEmail)
//         .get();
//     if (querySnapshot.docs.isNotEmpty) {
//       var data = querySnapshot.docs[0].data();
//       var firstName = data['firstName'];
//       var lastName = data['lastName'];
//       var serviceValue = data['service'];
//       var cityValue = data['city'];
//       var phoneValue = data['phone'];
//       var photoUrlValue = data['photoUrl'];
//       var descriptionValue = data['description'];
//       var id = data['id'];

//       setState(() {
//         name = '$firstName $lastName';
//         service = '$serviceValue';
//         city = '$cityValue';
//         phone = '$phoneValue';
//         photoUrl = '$photoUrlValue';
//         description = '$descriptionValue';
//         id = '$id';
//       });
//     }
//   }

//   final emailw = FirebaseAuth.instance.currentUser!.email;

//   final workers = FirebaseFirestore.instance.collection('workers');

//   Future<QueryDocumentSnapshot?> getWorkerByEmail(String email) async {
//     final workers = FirebaseFirestore.instance.collection('workers');
//     final querySnapshot = await workers.where('email', isEqualTo: email).get();
//     final documents = querySnapshot.docs;
//     if (documents.isNotEmpty) {
//       return documents.first;
//     } else {
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Profile'),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.symmetric(horizontal: 32),
//         physics: const BouncingScrollPhysics(),
//         children: [

//           // ProfileWidget(
//           //   imagePath:photoUrl,
//           //   // imagePath: 'images/download.png',
//           //   isEdit: true,
//           //   onClicked: () async {},
//           // ),
//           const SizedBox(height: 24),
//           TextFieldWidget(
//             label: 'Full Name',
//             text: name,
//             onChanged: (name) async {
//               print(name);

//               await Worker.update(id, firstName: name);
//               // firstName: _firstTextController.text,
//               // lastName: _lastTextController.text,
//               // email: email,
//               // phone: _phoneTextController.text,
//               // city: _cityTextController.text,
//               // service: _selectedItem,
//               // availability: {},
//               // description: '',
//               // photoUrl: 'images/download.png',
//             },
//           ),
//           const SizedBox(height: 24),
//           TextFieldWidget(
//             label: 'Email',
//             text: email,
//             onChanged: (email) {},
//           ),
//           const SizedBox(height: 24),
//           TextFieldWidget(
//             label: 'About',
//             text: description,
//             maxLines: 5,
//             onChanged: (about) {},
//           ),
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }
// }
