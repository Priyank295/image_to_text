import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_to_text/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  final googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/cloud-platform',
      'https://www.googleapis.com/auth/cloud-vision',
    ],
  );
  await googleSignIn.signIn().then((value) {
    value!.authentication.then((e) {
      prefs.setString('token', e.accessToken.toString()).then((value) {
        print(e.accessToken.toString());
      });
    }).catchError((err) {
      print(err.toString());
    });
  }).catchError((err) {
    print("ERROR :" + err.toString());
  });

  runApp(
    MaterialApp(
      home: HomePage(),
    ),
  );
}
