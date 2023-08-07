

import 'package:flutter/material.dart';
import 'package:handyworker/screens/welcome/page1.dart';
import 'package:handyworker/screens/welcome/page2.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: const [
          Page1(),
          Page2(),
        ],
      ),
     
    );
  }
}
