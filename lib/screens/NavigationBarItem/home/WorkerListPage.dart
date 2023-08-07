import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handyworker/screens/NavigationBarItem/home/WorkerViewFromUser.dart';
import '../../../models/worker.dart';

class WorkerListPage extends StatefulWidget {
  final String service;

  const WorkerListPage({Key? key, required this.service}) : super(key: key);

  @override
  _WorkerListPageState createState() => _WorkerListPageState();
}

class _WorkerListPageState extends State<WorkerListPage> {
  List<Worker>? workers;
  bool isLoading = true;
  final user = FirebaseAuth.instance.currentUser;

  // Use a Set to store favorite worker IDs
  Set<String> favorites = {};

  @override
  void initState() {
    super.initState();
            retrieveFavorites();

    isLoading = true;
    // Retrieve the list of workers from Firebase based on the selected service
    FirebaseFirestore.instance
        .collection('workers')
        .where('service', isEqualTo: widget.service)
        .get()
        .then((snapshot) {
      setState(() {
        workers = snapshot.docs.map((doc) => Worker.fromSnapshot(doc)).toList();
        isLoading = false; // set isLoading to false when the data is loaded

        // Retrieve the user's favorites list
        retrieveFavorites();
      });
    });
  }

  Future<void> retrieveFavorites() async {
    try {
      final userEmail = user?.email;
      if (userEmail != null) {
        final userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: userEmail)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          final userDoc = userSnapshot.docs.first;
          favorites = Set<String>.from(userDoc.data()['favorites'] ?? []);
          // print(favorites);
        }
      }
    } catch (error) {
      // Handle error here
    }
  }

  Future<void> addToFavorites(String userEmail, String workerId) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userDoc = userSnapshot.docs.first;
        final userRef = FirebaseFirestore.instance.collection('users').doc(userDoc.id);

        await userRef.update({
          'favorites': FieldValue.arrayUnion([workerId])
        });

        setState(() {
          favorites.add(workerId);
        });
      }
    } catch (error) {
      //  error 
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
        final userRef = FirebaseFirestore.instance.collection('users').doc(userDoc.id);

        await userRef.update({
          'favorites': FieldValue.arrayRemove([workerId])
        });

        setState(() {
          favorites.remove(workerId);
        });
      }
    } catch (error) {
      // Handle error here
    }
  }

bool isFavorite(String workerId) {
  // print('Favorites: $favorites');
  // print('Is Favorite? ${favorites.contains(workerId)}');
  return favorites.contains(workerId);
}


  @override
Widget build(BuildContext context) {
  if (isLoading) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

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
      title: Text(
        widget.service,
        style: const TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    body: ListView.builder(
      itemCount: workers!.length,
      itemBuilder: (BuildContext context, int index) {
        final worker = workers![index];
        final isFavoriteWorker = isFavorite(worker.id);

        return Card(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkerFromUser(worker: worker),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: worker.photoUrl != null &&
                        worker.photoUrl.isNotEmpty &&
                        Uri.parse(worker.photoUrl).isAbsolute
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        worker.photoUrl,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Image.network(
                      'https://www.w3schools.com/w3images/avatar2.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${worker.firstName} ${worker.lastName}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          worker.city,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            const SizedBox(width: 5),
                            Text(worker.rating.toStringAsFixed(2)),
                            const SizedBox(width: 8),
                            Text('| (${worker.numReviews}) reviews'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavoriteWorker ? Icons.favorite : Icons.favorite_border,
                      color: isFavoriteWorker ? Colors.red : null,
                    ),
                    onPressed: () {
                      final userEmail = user?.email;
                      if (userEmail != null) {
                        setState(() {
                          if (isFavoriteWorker) {
                            removeFromFavorites(userEmail, worker.id);
                          } else {
                            addToFavorites(userEmail, worker.id);
                          }
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
}