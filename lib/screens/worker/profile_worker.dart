import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../NavigationBarItem/home_screen.dart';
import '../login-signup/signin_screen.dart';
import 'myprofile.dart';

class ProfileWorker extends StatefulWidget {
  const ProfileWorker({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfileWorkerState createState() => _ProfileWorkerState();
}

class _ProfileWorkerState extends State<ProfileWorker> {
  late String? email;
  late String photo = "";

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    email = user?.email ?? ' ';
    photo = user?.photoURL ?? ' ';
    print("this is" + photo);
    // _loadData();
  }

  // Future<void> _loadData() async {
  //   final uEmail = FirebaseAuth.instance.currentUser!.email;
  //   final querySnapshot = await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('email', isEqualTo: uEmail)
  //       .get();
  //   if (querySnapshot.docs.isNotEmpty) {
  //     final data = querySnapshot.docs[0].data();
  //     final firstName = data['first name'];
  //     final lastName = data['last name'];
  //     setState(() {
  //       name = '$firstName $lastName';
  //     });
  //   }
  // }

//   final FirebaseFirestore _db = FirebaseFirestore.instance;

// Future<void> removeWorker(String email) async {
//   try {
//     await _db.collection('workers').doc(email).delete();
//     print('Worker with email $email has been removed');
//   } catch (e) {
//     print('Error removing worker: $e');
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(photo),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            // Text(
            //   name,
            //   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            // ),
            Text(
              email!,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Account'),
              onTap: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WorkerProfilePage()));
                setState(() {
                  photo = result;
                });
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person_2),
              title: const Text('return to normal user'),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Are you sure? '),
                      content: const Text(
                          'your account will delete '),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Homesreen()),
                            );
                          },
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('No'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Log out'),
              onTap: () {
                FirebaseAuth.instance.signOut().then((value) {
                  if (kDebugMode) {
                    print("Sign out");
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
