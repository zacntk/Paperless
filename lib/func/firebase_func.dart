import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../firebase_options.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser?.uid;

// final user = <String, dynamic>{
//   "first": "Ada",
//   "last": "Lovelace",
//   "born": 1815
// };

void Set(String col, String doc, final data) {
// Add a new document with a generated ID
  db
      .collection(col)
      .doc(doc)
      .set(data)
      .then((value) => print("success"))
      .catchError((error) => print("Failed : $error"));
}

void Delete(String col, String doc) {
  db
      .collection(col)
      .doc(doc)
      .delete()
      .then((value) => print("success"))
      .catchError((error) => print("Failed : $error"));
}

void GetAll(String col) {}
