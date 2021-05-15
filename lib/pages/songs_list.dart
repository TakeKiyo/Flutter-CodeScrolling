import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth_model.dart';
import 'my_home_page.dart';

class SongsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User _user = context.select((AuthModel _auth) => _auth.user);

    String uid;
    if (_user != null) {
      uid = _user.uid;
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return MyHomePage();
        }),
      );
    }
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Songs')
            .where("userID", isEqualTo: uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data.docs;
            return ListView(
                children: documents
                    .map((doc) => TextButton(
                        onPressed: () {
                          print(doc["bpm"]);
                        },
                        child: Text(doc["Title"])))
                    .toList());
          } else if (snapshot.hasError) {
            return Text('error');
          }
        });
  }
}
