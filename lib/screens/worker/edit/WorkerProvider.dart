import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Worker.dart';

class WorkerProvider {
  final uEmail = FirebaseAuth.instance.currentUser!.email;
     late final String documentId;

  final CollectionReference _workersCollection =
      FirebaseFirestore.instance.collection('workers');

  Future<Worker> getWorker(String uid) async {
    final snapshot =
        await _workersCollection.where('email', isEqualTo: uEmail).get();
    final data = snapshot.docs[0].data() as Map<String, dynamic>;
    return Worker.fromMap(data);
  }

  // Future<void> updateWorker(Worker worker) async {
  //   await _workersCollection.doc('cUiv2qQShp6dZTK6Tti7').update(worker.toMap());
  // }

  Future<void> updateWorkerByEmail(Worker worker) async {  
  final workerDoc = await _workersCollection.where('email', isEqualTo: worker.email).get();
  if (workerDoc.docs.isNotEmpty) {
    await workerDoc.docs.first.reference.update(worker.toMap());
  }
}



// Future<String?> getWorkerId(String email) async {
//   final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//       .collection('workers')
//       .where('email', isEqualTo: email)
//       .get();

//   if (querySnapshot.docs.isEmpty) {
//     return null;
//   } else {
//     final workerId = querySnapshot.docs.first.id;
//     return workerId;
//   }
// }


  // Future<void> updateWorker(Worker worker) async {

  //   if (worker.uid == null || worker.uid.isEmpty) {
  //     // handle the case where the worker UID is empty or null
  //   }
  //   await _workersCollection.doc(worker.uid).update(worker.toMap());
  // }


}
