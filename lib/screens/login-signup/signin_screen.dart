import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handyworker/screens/login-signup/reset_password.dart';

import '../NavigationBarItem/home_screen.dart';
import '../../reusable_widgets/reusable_widget.dart';
import '../../reusable_widgets/utils/color_utils.dart';
import '../welcome/first_screen.dart';
import '../worker/home_worker.dart';




class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
   // ignore: library_private_types_in_public_api
   _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  void _onSubmit(BuildContext context) async {
  final String email = _emailTextController.text.trim();
  if (email.isNotEmpty) {
    await checkWorkerStatus(context, email);
  }
}

Future<void> checkWorkerStatus(BuildContext context, String email) async {
  final QuerySnapshot workerSnapshot = await FirebaseFirestore.instance
      .collection('workers')
      .where('email', isEqualTo: email)
      .get();
  if (workerSnapshot.docs.isNotEmpty) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeWorker()),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Homesreen()),
    );
  }
}



  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // iconTheme: IconThemeData(color: Color(0xFF626262)), // set the color of the back button icon
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color(0xFF626262),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FirstScreen(),
              ),
            );
          },
        ),

        title: const Text(
          "LOG IN",
          style: TextStyle(
              color: Color(0xFF626262),
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("FFFFFF"),
            hexStringToColor("FFFFFF")
          ])),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.1, 20, 0),
              child: Column(children: <Widget>[
                logoWidget("images/Login-pana.png"),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("Enter Email", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 30,
                ),
                // reusableTextField("Enter Password", Icons.lock_outline, true,
                //     _passwordTextController),
                TextField(
                  controller: _passwordTextController,
                  obscureText: _obscureText,
                  enableSuggestions: !true,
                  autocorrect: !true,
                  cursorColor: const Color(0xFF848484),
                  style: TextStyle(color: const Color(0xFF626262).withOpacity(0.9)),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: const Color(0xFF848484).withOpacity(0.7),
                    ),
                    labelText: "Enter Password",
                    labelStyle:
                        TextStyle(color: const Color(0xFF848484).withOpacity(0.9)),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: const Color(0xFFB2B2B2).withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none),
                    ),
                    suffixIcon: true
                        ? IconButton(
                            icon: Icon(
                              color: const Color(0xFF00ABB3),
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          )
                        // ignore: dead_code
                        : null,
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(
                  height: 15,
                ),
                signUpOption(),
                signinButton(context, true, () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                        _onSubmit(context);
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => const Homesreen()));
                  }).onError((error, stackTrace) {
                    print("ERROR ${error.toString()}");
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(error.toString()),
                          );
                        });
                  });
                }),
              ]),
            ),
          )),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ResetPassword()));
          },
          child: const Text(
            "Foget password?",
            style: TextStyle(
                color: Color(0xFF626262), fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}



