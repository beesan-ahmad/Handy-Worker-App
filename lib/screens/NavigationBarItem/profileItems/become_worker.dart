import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/worker.dart';
import '../../../reusable_widgets/reusable_widget.dart';
import '../../../reusable_widgets/utils/color_utils.dart';
import '../../worker/home_worker.dart';

class BecomeWorker extends StatefulWidget {
  const BecomeWorker({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BecomeWorkerState createState() => _BecomeWorkerState();
}

final email = FirebaseAuth.instance.currentUser!.email;

class _BecomeWorkerState extends State<BecomeWorker> {
  final TextEditingController _firstTextController = TextEditingController();
  final TextEditingController _lastTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  final TextEditingController _cityTextController = TextEditingController();
  final TextEditingController _phototTextController = TextEditingController();

  late String _selectedItem;
  late String _selectedCity;

  // Future<void> _addUserDetails() async {
  //   final email = FirebaseAuth.instance.currentUser!.email;

  //   await FirebaseFirestore.instance.collection('workers').add({
  //     'firstName': _firstTextController.text,
  //     'lastName': _lastTextController.text,
  //     'email': email,
  //     'phone': _phoneTextController.text,
  //     'city': _cityTextController.text,
  //     'service': _selectedItem,
  //     'imageUrl':   '',
  //   });
  // }

  @override
  Widget build(BuildContext context) {
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

List<String> cities = [
  "Jerusalem",
  "Ramallah",
  "Bethlehem",
  "Nablus",
  "Hebron",
  "Jericho",
  "Jenin",
  "Tulkarm",

];
// Create a List of DropdownMenuItem from the list of services
    List<DropdownMenuItem<String>> serviceItems = services
        .map((service) => DropdownMenuItem<String>(
              value: service,
              child: Text(
                service,
                style: const TextStyle(
                  color: Color(0xFF626262),
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                ),
              ),
            ))
        .toList();

// Sort the list of DropdownMenuItem alphabetically
    serviceItems.sort((a, b) => a.value!.compareTo(b.value!));


    List<DropdownMenuItem<String>> serviceCity = cities
        .map((city) => DropdownMenuItem<String>(
              value: city,
              child: Text(
                city,
                style: const TextStyle(
                  color: Color(0xFF626262),
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                ),
              ),
            ))
        .toList();

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: const Color(0xFF626262),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Become a Worker",
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
              // reusableTextField("Enter your City", Icons.location_city, false,
              //     _cityTextController),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.location_city,
                    color: const Color(0xFF848484).withOpacity(0.7),
                  ),
                  labelText: "select city",
                  labelStyle: const TextStyle(
                    color: Color(0xFF848484),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFB2B2B2).withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(
                  color: Color(0xFF626262),
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                ),
                iconEnabledColor: const Color(0xFF848484).withOpacity(0.7),
                items: serviceCity,
                onChanged: (String? value) {
                  _selectedCity = value!;
                },
              ),



              const SizedBox(
                height: 20,
              ),
              reusableTextField(
                  "Enter your phone", Icons.phone, false, _phoneTextController),
              const SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.select_all_rounded,
                    color: const Color(0xFF848484).withOpacity(0.7),
                  ),
                  labelText: "select service",
                  labelStyle: const TextStyle(
                    color: Color(0xFF848484),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFB2B2B2).withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(
                  color: Color(0xFF626262),
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                ),
                iconEnabledColor: const Color(0xFF848484).withOpacity(0.7),
                items: serviceItems,
                onChanged: (String? value) {
                  _selectedItem = value!;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              signinButton(context, false, () async {
                print(_selectedItem);

                final email = FirebaseAuth.instance.currentUser!.email!;

                await Worker.postWorker(
                  firstName: _firstTextController.text,
                  lastName: _lastTextController.text,
                  email: email,
                  phone: _phoneTextController.text,
                  city: _selectedCity,
                  service: _selectedItem,
                  availability: {},
                  description: '',
                  photoUrl: '',
                );

                

                // ignore: use_build_context_synchronously
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeWorker()));
              }),
            ]),
          )),
        ));
  }
}
