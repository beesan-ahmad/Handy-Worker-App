import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../reusable_widgets/reusable_widget.dart';
import 'Worker.dart';
import 'WorkerProvider.dart';

class WorkerInformationPage extends StatefulWidget {
  final String uid;

  const WorkerInformationPage({super.key, required this.uid});

  @override
  _WorkerInformationPageState createState() => _WorkerInformationPageState();
}

class _WorkerInformationPageState extends State<WorkerInformationPage> {
  late String photo;

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _serviceController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _photoUrlController = TextEditingController();
  final _descriptionController = TextEditingController();

  Worker? _worker;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    photo = user?.photoURL ?? ' ';
    
    _loadWorkerInformation();
  }

  Future<void> _loadWorkerInformation() async {
    final workerProvider = WorkerProvider();
    final worker = await workerProvider.getWorker(widget.uid);
    print(worker);
    setState(() {
      _worker = worker;
      _firstNameController.text = worker.firstName;
      _lastNameController.text = worker.lastName;
      _serviceController.text = worker.service;
      _cityController.text = worker.city;
      _phoneController.text = worker.phone;
      _emailController.text = worker.email;
      _photoUrlController.text = worker.photoUrl;
      _descriptionController.text = worker.description;

      final av = worker.availability;
      for (int i = 0; i < days.length; i++) {
        final x = (av[days[i]])?.split("-");

        if (x != null && x.isNotEmpty) {
          controllers[i * 2].text = x[0];
          controllers[i * 2 + 1].text = x[1];
        }

        // if (startTime.isNotEmpty && endTime.isNotEmpty) {
        //   availability[days[i]] = '$startTime-$endTime';
        // }
      }
    });
    print(_worker);
  }

  // Create a list of days
  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

// Create a list to hold the controllers for each text field
  final List<TextEditingController> controllers = List.generate(
    7 * 2,
    (_) => TextEditingController(),
  );

// Generate controllers for the AM and PM dropdowns and add them to the list

  final Map<String, String> availability = {};

  @override
  Widget build(BuildContext context) {
    // Store the availability map in Firestore
    // FirebaseFirestore.instance.collection('workers').doc(widget.uid).update({
    //   'availability': availability,
    // });

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
          "Worker Information",
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: _worker == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _firstNameController,
                      decoration:
                          const InputDecoration(labelText: 'First Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a first name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(labelText: 'Last Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a last name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _serviceController,
                      decoration: const InputDecoration(labelText: 'Service'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a service';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(labelText: 'City'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a city';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Column(
                      children: [
                        Row(
                          children: const [
                            Text(
                              'Available:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: const [
                            Text(
                              'Use 24-hour format',
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        for (int i = 0; i < days.length; i++)
                          Row(
                            children: [
                              SizedBox(
                                width: 80, // fixed width for day label
                                child: Text(days[i]),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: controllers[i * 2],
                                  decoration: const InputDecoration(
                                    hintText: 'Start time',
                                  ),
                                ),
                              ),
                              // const SizedBox(width: 10),
                              // DropdownButton<String>(
                              //   value: 'AM',
                              //   onChanged: (String? newValue) {},
                              //   items: <String>[
                              //     'AM',
                              //     'PM'
                              //   ].map<DropdownMenuItem<String>>((String value) {
                              //     return DropdownMenuItem<String>(
                              //       value: value,
                              //       child: Text(value),
                              //     );
                              //   }).toList(),
                              // ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: controllers[i * 2 + 1],
                                  decoration: const InputDecoration(
                                    hintText: 'End time',
                                  ),
                                ),
                              ),
                              // const SizedBox(width: 10),
                              // DropdownButton<String>(
                              //   value: 'AM',
                              //   onChanged: (String? newValue) {},
                              //   items: <String>[
                              //     'AM',
                              //     'PM'
                              //   ].map<DropdownMenuItem<String>>((String value) {
                              //     return DropdownMenuItem<String>(
                              //       value: value,
                              //       child: Text(value),
                              //     );
                              //   }).toList(),
                              // ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    getstart(context, "Save Changes", _saveChanges),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _saveChanges() async {
    for (int i = 0; i < days.length; i++) {
      final String startTime = controllers[i * 2].text;
      final String endTime = controllers[i * 2 + 1].text;
      if (startTime.isNotEmpty && endTime.isNotEmpty) {
        availability[days[i]] = '$startTime-$endTime';
      }
    }
    if (_formKey.currentState!.validate()) {
      final workerProvider = WorkerProvider();
      final updatedWorker = Worker(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        service: _serviceController.text,
        city: _cityController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        photoUrl: photo,
        description: _descriptionController.text,
        availability: availability,
        // Map<String, String>.from(json.decode(_availabilityController.text)),
        uid: widget.uid,
        mediaUrls: _worker!.mediaUrls, 
        // numReviews: _worker!.numReviews, 
        // rating: _worker!.rating,
      );
      print(availability);
      await workerProvider.updateWorkerByEmail(updatedWorker);
      Navigator.pop(context, true);
    }
  }
}
