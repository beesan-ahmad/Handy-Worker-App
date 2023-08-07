import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handyworker/screens/NavigationBarItem/favorites.dart';

import 'home/home.dart';
import 'notification.dart';
import 'profile.dart';
import 'search.dart';

class Homesreen extends StatefulWidget {
  const Homesreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomesreenState createState() => _HomesreenState();
}

class _HomesreenState extends State<Homesreen> {
  List pages = [
    const HomePage(),
    const SearchPage(),
    const NotificationPage(),
    const ProfilePage(),
  ];
  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserEmail = currentUser?.email;

    Future<void> navigateToFavoritesPage() async {
      final usersRef = FirebaseFirestore.instance.collection('users');
      final userDoc =
          await usersRef.where('email', isEqualTo: currentUserEmail).get();

      if (userDoc.docs.isNotEmpty) {
        final userId = userDoc.docs.first.id;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FavPage(userId: userId),
          ),
        );
      } else {
        // Handle the case when user document is not found
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  'images/worker-icon.png',
                  width: 24.09,
                  height: 24.09,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Handy Worker",
                  style: TextStyle(color: Color(0xff00abb3)),
                ),
              ],
            ),
            IconButton(
              icon: const SizedBox(
                width: 32,
                height: 32,
                child: Icon(Icons.favorite_border, color: Colors.black),
              ),
              onPressed: navigateToFavoritesPage,

              // onPressed: () {
              //   // Navigator.push(
              //   //   context,
              //   //   MaterialPageRoute(
              //   //       builder: (context) =>
              //   //           const Favorites()), // Navigate to the favorite page
              //   // );
              // },
            ),
          ],
        ),
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: const Color(0xff00abb3),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 25,
        unselectedFontSize: 0,
        selectedFontSize: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
            ),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
