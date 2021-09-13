import 'package:cloud_firestore/cloud_firestore.dart';

void checkFirebase() {
  // print('firebase test');
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference testRef = firestore.collection('test');
  var doc = testRef.doc('Cw0TbgK0w0FtA3vt2XRo');
  doc.get().then((value) => print(value.data()));
}
