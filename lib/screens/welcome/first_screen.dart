
import 'package:flutter/material.dart';

import '../../reusable_widgets/reusable_widget.dart';
import '../login-signup/signin_screen.dart';
import '../login-signup/signup_screen.dart';
import '../../reusable_widgets/utils/color_utils.dart';


class FirstScreen extends StatefulWidget {
  const FirstScreen({ Key? key }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
@override
  Widget build(BuildContext context) {
    return Scaffold(
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
                logoWidget("images/logo1.PNG"),
                const SizedBox(
                  height: 80,
                ),
                const Text(
                  "Welcome to Handy Worker!",
                  style: TextStyle(color: Color(0xFF626262),fontSize: 24),

                  ),
                const SizedBox(
                  height: 30,
                ),
                signinButton(context, true, () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const SignInScreen()));
                }),
                
                 signinButton(context, false, () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()));
                }),

              ]),
            ),
          )),
    );
  }
}



