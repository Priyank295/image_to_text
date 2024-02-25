import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_to_text/api.dart';
import 'package:image_to_text/userSelectionScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserSelectionScreen(),
    ),
  );
}
