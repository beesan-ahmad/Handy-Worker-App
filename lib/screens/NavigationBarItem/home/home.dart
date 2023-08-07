import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handyworker/screens/NavigationBarItem/home/WorkerListPage.dart';
import '../../../models/worker.dart';
import 'WorkerViewFromUser.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

List<String> services = [
  "Electrical work",
  "Plumbing",
  "Painting",
  "Blacksmithing",
  "Welding",
  "Glasswork",
  "Appliance repair",
  "Tiling",
  "Carpentry",
  "HVAC",
];

class _HomePageState extends State<HomePage> {
  List<Worker>? workers;
  bool isLoading = true;
  final user = FirebaseAuth.instance.currentUser;

  // Use a Set to store favorite worker IDs
  Set<String> favorites = {};

  @override
  void initState() {
    super.initState();

    print(services.length);

    retrieveFavorites();

    isLoading = true;
    // Retrieve the list of workers from Firebase based on the selected service
    FirebaseFirestore.instance
        .collection('workers')
        .orderBy('rating', descending: true)
        .limit(10)
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
        final userRef =
            FirebaseFirestore.instance.collection('users').doc(userDoc.id);

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
        final userRef =
            FirebaseFirestore.instance.collection('users').doc(userDoc.id);

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
    return Scaffold(
      body: ListView(
        children: [
          _buildCategoriesRow([
            {
              'color': const Color.fromARGB(255, 101, 205, 250),
              'icon': Icons.electrical_services,
              'label': services[0]
            },
            {
              'color': const Color.fromARGB(255, 250, 107, 107),
              'icon': Icons.plumbing,
              'label': services[1]
            },
            {
              'color': const Color.fromARGB(255, 143, 241, 187),
              'icon': Icons.format_paint,
              'label': services[2]
            },
            {
              'color': const Color.fromARGB(255, 178, 221, 125),
              'icon': Icons.construction,
              'label': services[3]
            },
            {
              'color': Color.fromARGB(255, 248, 200, 57),
              'icon': Icons.build,
              'label': services[4]
            },
            {
              'color': Color.fromARGB(255, 91, 236, 236),
              'icon': Icons.window_outlined,
              'label': services[5]
            },
            {
              'color': Color.fromARGB(255, 218, 181, 245),
              'icon': Icons.home_repair_service_rounded,
              'label': services[6]
            },
            {
              'color': Color.fromARGB(255, 242, 175, 212),
              'icon': Icons.gite_rounded,
              'label': services[7]
            },
            {
              'color': Color.fromARGB(255, 97, 220, 109),
              'icon': Icons.carpenter,
              'label': services[8]
            },
            {
              'color': const Color.fromARGB(255, 253, 149, 93),
              'icon': Icons.ac_unit,
              'label': services[9]
            },
          ]),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Top Rated Workers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: workers?.length ?? 0,
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
                                worker.service,
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
                            isFavoriteWorker
                                ? Icons.favorite
                                : Icons.favorite_border,
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
        ],
      ),
    );
  }

  Widget _buildCategoriesRow(List<Map<String, dynamic>> categories) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 20),
      child: ListView.builder(
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return _buildCategoryItem(
            categories[index]['color'],
            categories[index]['icon'],
            categories[index]['label'],
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem(Color color, IconData icon, String label) {
    return SizedBox(
      width: 95,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkerListPage(service: label),
                ),
              );
            },
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
