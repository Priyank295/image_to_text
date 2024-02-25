import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget buildAppBar(context) {
  return AppBar(
    title: Text(
      'Shakshu',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.green[400],
    centerTitle: true,
    // actions: [
    //   IconButton(
    //     onPressed: () {
    //       prefs.clear();
    //       // userCredential.value = '';
    //       FirebaseAuth.instance.signOut();
    //     },
    //     icon: Icon(
    //       Icons.logout,
    //       color: Colors.white,
    //     ),
    //   ),
    // ],
  );
}
