import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:handyworker/screens/NavigationBarItem/home_screen.dart';

import 'package:handyworker/screens/welcome/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handyworker/screens/worker/home_worker.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final email = user?.email;

    Future<Widget> checkWorkerStatus(String email) async {
      final QuerySnapshot workerSnapshot = await FirebaseFirestore.instance
          .collection('workers')
          .where('email', isEqualTo: email)
          .get();
      if (workerSnapshot.docs.isNotEmpty) {
        return const HomeWorker();
      } else {
        return const Homesreen();
      }
    }


    Widget homeScreen;

    if (user != null) {
      homeScreen = FutureBuilder(
        future: checkWorkerStatus(email!),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data!;
          } else {
            return const CircularProgressIndicator();
          }
        },
      );
    } else {
      homeScreen = const WelcomeScreen();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Handy Worker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: homeScreen,
    );
  }
}





// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Handy Worker',
//       theme: ThemeData(

//         primarySwatch: Colors.blue,
//       ),

//       //       routes: {
//       //   '/page2': (context) => const Page2(),
//       //   '/firstscreen': (context) => const FirstScreen(),
//       //   '/login': (context) => const SignInScreen(),
//       //   '/signup': (context) => const SignUpScreen(),
        
//       //   '/home': (context) => const Homesreen(),


//       // },
//       home: const WelcomeScreen(),


      
//     );
//   }
// }










//if the email is in workers collocation  in firebase go to HomeWorker
// if not go Homesreen
// and if is the first time use application go to WelcomeScreen

// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator();
//         } else {
//           if (snapshot.hasData) {
//             // User is already signed in, check if they are a worker or not
//             User? user = snapshot.data;
//             String? email = user?.email;

//             // Check if the user's email is in the workers collection
//             // Replace this with your own code to check if the email is in the workers collection
//             bool isWorker = false;

//             // ignore: dead_code
//             if (isWorker) {
//               return MaterialApp(
//                 debugShowCheckedModeBanner: false,
//                 title: 'Handy Worker',
//                 theme: ThemeData(
//                   primarySwatch: Colors.blue,
//                 ),
//                 home: const HomeWorker(),
//               );
//             } else {
//               // User is not a worker, navigate to the regular home screen
//               return MaterialApp(
//                 debugShowCheckedModeBanner: false,
//                 title: 'Handy Worker',
//                 theme: ThemeData(
//                   primarySwatch: Colors.blue,
//                 ),
//                 home: const FirstScreen(),
//               );
//             }
//           } else {
//             // User is not signed in, navigate to the welcome screen
//             return MaterialApp(
//               debugShowCheckedModeBanner: false,
//               title: 'Handy Worker',
//               theme: ThemeData(
//                 primarySwatch: Colors.blue,
//               ),
//               home: const WelcomeScreen(),
//             );
//           }
//         }
//       },
//     );
//   }
// }