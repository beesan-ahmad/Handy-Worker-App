import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../NavigationBarItem/home_screen.dart';
import '../../reusable_widgets/reusable_widget.dart';
import '../../reusable_widgets/utils/color_utils.dart';
import '../welcome/first_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();

  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _firstTextController = TextEditingController();
  final TextEditingController _lastTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _passwordTextController.dispose();
    _emailTextController.dispose();
    _firstTextController.dispose();
    _lastTextController.dispose();
    _phoneTextController.dispose();
    super.dispose();
  }

  // Future signUp() async {
  //   // await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //   //     email: _emailTextController.text,
  //   //     password: _passwordTextController.text);

  //   addUserDetails(
  //     _firstTextController.text.trim(),
  //     _lastTextController.text.trim(),
  //     _phoneTextController.text.trim(),
  //     _emailTextController.text.trim(),
  //   );
  // }

  Future addUserDetails(
      String fName, String lName, String email, String phone) async {
    await FirebaseFirestore.instance.collection("users").add({
      'first name': fName,
      'last name': lName,
      'email': email,
      'phone': phone,
    });
    
  }

  // bool passwordConfirmed() {
  //   if (_emailTextController.text.trim() ==
  //       _confirmpasswordTextController.text.trim()) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

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
            "Sign Up",
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
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(children: <Widget>[
              const SizedBox(
                height: 20,
              ),

              reusableTextField("Enter First Name", Icons.person_outline, false,
                  _firstTextController),

              const SizedBox(
                height: 20,
              ),

              reusableTextField("Enter Last Name", Icons.person_outline, false,
                  _lastTextController),

              const SizedBox(
                height: 20,
              ),

              reusableTextField(
                  "Enter your phone", Icons.phone, false, _phoneTextController),

              const SizedBox(
                height: 20,
              ),

              reusableTextField(
                  "Enter Email", Icons.email, false, _emailTextController),

              const SizedBox(
                height: 20,
              ),

              // reusableTextField("Enter Password", Icons.lock_outline, true, _passwordTextController),
              TextField(
                controller: _passwordTextController,
                obscureText: _obscureText,
                enableSuggestions: !true,
                autocorrect: !true,
                cursorColor: const Color(0xFF848484),
                style:
                    TextStyle(color: const Color(0xFF626262).withOpacity(0.9)),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: const Color(0xFF848484).withOpacity(0.7),
                  ),
                  labelText: "Enter Password",
                  labelStyle: TextStyle(
                      color: const Color(0xFF848484).withOpacity(0.9)),
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
                height: 20,
              ),

              signinButton(context, false, () {
                FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text)
                    .then((value) {
                  print("Created New Account");
                  addUserDetails(
                    _firstTextController.text.trim(),
                    _lastTextController.text.trim(),
                    _emailTextController.text.trim(),
                    _phoneTextController.text.trim(),
                  );
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Homesreen()));
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
          )),
        ));
  }
}
