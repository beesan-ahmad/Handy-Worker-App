import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'edit/workerinfo.dart';

class WorkerProfilePage extends StatefulWidget {
  @override
  _WorkerProfilePageState createState() => _WorkerProfilePageState();
}

int x = Random().nextInt(100000);

class _WorkerProfilePageState extends State<WorkerProfilePage> {
  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    email = user?.email ?? ' ';
    photo = user?.photoURL ?? ' ';
    name;
    service;
    city;
    phone;
    photoUrl;
    description;
    availability;
    mediaUrls;
    uid = user?.uid ?? ' ';
    _loadData();
    print(uid);
  }

  late String? email;
  late String name = "";
  late String photo = "";

  late String service = "";
  late String city = "";
  late String phone = "";
  late String photoUrl = "";
  late String description = "";
  late String uid = "";
  late Map<String, String> availability = {};
  late List<String> mediaUrls = [];

  Future<void> _loadData() async {
    final uEmail = FirebaseAuth.instance.currentUser!.email;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('workers')
        .where('email', isEqualTo: uEmail)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      var data = querySnapshot.docs[0].data();
      var firstName = data['firstName'];
      var lastName = data['lastName'];
      var serviceValue = data['service'];
      var cityValue = data['city'];
      var phoneValue = data['phone'];
      var photoUrlValue = data['photoUrl'];
      var descriptionValue = data['description'];
      var uid = data['uid'];
      var availabilityValue = Map<String, String>.from(data['availability']);
      var mediaUrlsValue = <String>[];
      if (data['mediaUrls'] != null && data['mediaUrls'].isNotEmpty) {
        mediaUrlsValue = List<String>.from(data['mediaUrls']);
      }

      setState(() {
        name = '$firstName $lastName';
        service = '$serviceValue';
        city = '$cityValue';
        phone = '$phoneValue';
        photoUrl = '$photoUrlValue';
        description = '$descriptionValue';
        uid = '$uid';
        availability = availabilityValue;
        mediaUrls = mediaUrlsValue;
      });
    }
  }

// //photo
  void pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );

    String uid = FirebaseAuth.instance.currentUser!.uid;
    print(uid);
    Reference oldRef =
        FirebaseStorage.instance.ref().child("https://profilepics/$uid.jpg");
    oldRef.delete().catchError(
        (error) => print("Error deleting previous profile picture: $error"));

    Reference newRef =
        FirebaseStorage.instance.ref().child("https://profilepics/$uid.jpg");

    await newRef.putFile(File(image!.path));

    newRef.getDownloadURL().then((value) async {
      print(value);
      setState(() {
        photo = value;
        photoUrl = value;
      });
      await FirebaseAuth.instance.currentUser!.updatePhotoURL(photo);
      _updatePhoto(photoUrl);
    });
  }

  Future<void> _updatePhoto(String photo) async {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '';
    final querySnapshot = await FirebaseFirestore.instance
        .collection('workers')
        .where('email', isEqualTo: email)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      var documentSnapshot = querySnapshot.docs[0];
      await documentSnapshot.reference.update({'photoUrl': photo});
    }
  }
  //photo

  void pickUploadPhotos() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );

    String uid = FirebaseAuth.instance.currentUser!.uid;
    print(uid);
    Reference newRef =
        FirebaseStorage.instance.ref().child("https://profilepics/$uid$x.jpg");
    await newRef.putFile(File(image!.path));

    newRef.getDownloadURL().then((value) async {
      print(value);
      setState(() {
        mediaUrls.add(value);
      });
      _updatePhotos(mediaUrls);
    });
  }

  Future<void> _updatePhotos(List<String> listPhoto) async {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '';
    final querySnapshot = await FirebaseFirestore.instance
        .collection('workers')
        .where('email', isEqualTo: email)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      var documentSnapshot = querySnapshot.docs[0];
      await documentSnapshot.reference.update({'mediaUrls': listPhoto});
    }
  }

  void _showBiggerImageDialog(String imageUrl, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _deleteImage(imageUrl, index);
                    Navigator.of(context).pop();
                  },
                  child: Text('Delete Image'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.black26;
                      }
                      return const Color(0xFF00ABB3);
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteImage(String imageUrl, int index) async {
    try {
      // Delete image from Firebase Storage
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();

      // Remove image URL from mediaUrls list
      setState(() {
        mediaUrls.removeAt(index);
      });

      // Update mediaUrls in Firestore
      await _updateMediaUrls(mediaUrls);
    } catch (error) {
      // Handle any errors that occur during deletion
      print('Error deleting image: $error');
      // Display an error message to the user, if needed
    }
  }

  Future<void> _updateMediaUrls(List<String> mediaUrls) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final email = user?.email ?? '';
      final querySnapshot = await FirebaseFirestore.instance
          .collection('workers')
          .where('email', isEqualTo: email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var documentSnapshot = querySnapshot.docs[0];
        await documentSnapshot.reference.update({'mediaUrls': mediaUrls});
      }
    } catch (error) {
      print('Error updating mediaUrls: $error');
      // Handle any errors that occur during the update
    }
  }

  @override
  Widget build(BuildContext context) {
    print(uid);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00ABB3),
        elevation: 0,
        title: const Text('My Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context, photoUrl);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WorkerInformationPage(uid: uid)),
              );
              print(result);
              if (result == true) {
                // refresh the page only if editing is complete
                setState(() {
                  _loadData();
                  photo;
                });
              }
            },
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('workers')
              .where('email', isEqualTo: email)
              .snapshots(),
          builder: (context, snapshot) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 120,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Stack(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: photo == ""
                                        ? const NetworkImage(
                                            'https://www.w3schools.com/w3images/avatar2.png')
                                        : NetworkImage(photo),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  backgroundColor:
                                      Colors.white.withOpacity(0.7),
                                  radius: 16,
                                  child: IconButton(
                                    icon: const Icon(Icons.edit,
                                        size: 16, color: Colors.black),
                                    onPressed: () {
                                      pickUploadProfilePic();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Color(0xFF00ABB3),
                                    size: 20,
                                  ),
                                  Text(
                                    city,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '$service Services',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: 50,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: const [
                  //           Icon(
                  //             Icons.star,
                  //             color: Colors.yellow,
                  //             size: 20,
                  //           ),
                  //           SizedBox(width: 5),
                  //           Text(
                  //             '4.5',
                  //             style: TextStyle(
                  //               fontSize: 20,
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: const [
                  //           Text(
                  //             '100',
                  //             style: TextStyle(
                  //               fontSize: 20,
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //           Text(
                  //             'Reviews',
                  //             style: TextStyle(color: Colors.grey),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey[400],
                  ),
                  // Text(
                  //   '$service Services',
                  //   style: const TextStyle(
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  const Text(
                    'About me:  ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 6),

                  SizedBox(
                    height: 100,
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      const Text(
                        "Photos",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          pickUploadPhotos();
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 16,
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                      ),
                      itemCount: mediaUrls.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            _showBiggerImageDialog(mediaUrls[index], index);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(mediaUrls[index]),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
