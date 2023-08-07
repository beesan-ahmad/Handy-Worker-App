import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handyworker/screens/NavigationBarItem/home/reviews/reviewPage.dart';
import '../../../models/worker.dart';

class WorkerFromUser extends StatefulWidget {
  final Worker worker;

  const WorkerFromUser({Key? key, required this.worker}) : super(key: key);

  @override
  _WorkerFromUserState createState() => _WorkerFromUserState();
}

class _WorkerFromUserState extends State<WorkerFromUser> {
  late String? email;
  late String photo = "";
  bool isFavorite = false;
  Set<String> favorites = {};

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    email = user?.email ?? ' ';
    photo = user?.photoURL ?? ' ';

    if (email != null) {
      FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          final userDoc = snapshot.docs.first;
          setState(() {
            favorites = Set<String>.from(userDoc.data()['favorites'] ?? []);
            isFavorite = favorites.contains(widget.worker.id);
          });
        }
      });
    }
  }

  void _showBiggerImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }

  Future<void> addToFavorites(String userEmail, String workerId) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userDoc = userSnapshot.docs.first;
        final userRef =
            FirebaseFirestore.instance.collection('users').doc(userDoc.id);

        await userRef.update({
          'favorites': FieldValue.arrayUnion([workerId])
        });

        setState(() {
          isFavorite = true;
          favorites.add(workerId);
        });
      }
    } catch (error) {
      // Handle error here
    }
  }

  Future<void> removeFromFavorites(String userEmail, String workerId) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userDoc = userSnapshot.docs.first;
        final userRef =
            FirebaseFirestore.instance.collection('users').doc(userDoc.id);

        await userRef.update({
          'favorites': FieldValue.arrayRemove([workerId])
        });

        setState(() {
          isFavorite = false;
          favorites.remove(workerId);
        });
      }
    } catch (error) {
      // Handle error here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00ABB3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Worker Details",
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 160,
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: widget.worker.photoUrl != null &&
                                      widget.worker.photoUrl.isNotEmpty &&
                                      Uri.parse(widget.worker.photoUrl)
                                          .isAbsolute
                                  ? NetworkImage(widget.worker.photoUrl)
                                  : const NetworkImage(
                                      'https://www.w3schools.com/w3images/avatar2.png'),
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
                          "${widget.worker.firstName} ${widget.worker.lastName}",
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
                              widget.worker.city,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${widget.worker.service} Services',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 7),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ReviewPage(worker: widget.worker),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.black26;
                              }
                              return const Color(0xFF00ABB3);
                            }),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(90),
                              ),
                            ),
                          ),
                          child: const Text('Rate and Review'),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: () {
                      final user = FirebaseAuth.instance.currentUser;
                      final userEmail = user?.email;

                      if (userEmail != null) {
                        if (isFavorite) {
                          removeFromFavorites(userEmail, widget.worker.id);
                        } else {
                          addToFavorites(userEmail, widget.worker.id);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.grey[400],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About me:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 60,
                    child: Text(
                      widget.worker.description,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Availability:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.worker.availability.length,
                    itemBuilder: (BuildContext context, int index) {
                      String key =
                          widget.worker.availability.keys.elementAt(index);
                      String value = widget.worker.availability[key] ?? '';
                      return Row(
                        children: [
                          Text(
                            "$key: ",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            value,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ... existing code ...
                ],
              ),
            ),
            const Text(
              "Photos",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: widget.worker.mediaUrls.isEmpty ||
                      widget.worker.mediaUrls == null
                  ? const Center(
                      child: Text('No images to display'),
                    )
                  : GridView.count(
                      crossAxisCount: 3,
                      children: List.generate(
                        widget.worker.mediaUrls.length,
                        (index) => GestureDetector(
                          onTap: () {
                            // Handle onTap event here
                            _showBiggerImageDialog(
                                widget.worker.mediaUrls[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      widget.worker.mediaUrls[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../../../models/worker.dart';

// class WorkerFromUser extends StatefulWidget {
//   final Worker worker;

//   const WorkerFromUser({ Key? key, required this.worker }) : super(key: key);

//   @override
//   _WorkerFromUserState createState() => _WorkerFromUserState();
// }


// class _WorkerFromUserState extends State<WorkerFromUser> {

//   late String? email;
//   late String photo = "";

//   @override
//   void initState() {
//     super.initState();
//     final user = FirebaseAuth.instance.currentUser;
//     email = user?.email ?? ' ';
//     photo =user?.photoURL ?? ' ';
 
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF00ABB3),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           color: Colors.white,
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text(
//           "Worker Details",
//           style: TextStyle(
//               color: Color.fromARGB(255, 255, 255, 255),
//               fontSize: 24,
//               fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Card(
//           elevation: 4.0,
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 width: 120.0,
//                 height: 120.0,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8.0),
//                   child: Image.network(
//                     photo,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 16.0),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 16.0),
//                   Text(
//                     "${widget.worker.firstName} ${widget.worker.lastName}",
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     "${widget.worker.city}",
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }