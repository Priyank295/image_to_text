import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:googleapis/vault/v1.dart';
import 'package:image_to_text/api.dart';
import 'package:image_to_text/blind_people_home_screen.dart';
import 'package:image_to_text/caretaker_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSelectionScreen extends StatefulWidget {
  const UserSelectionScreen({super.key});

  @override
  State<UserSelectionScreen> createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  late SharedPreferences prefs;
  ValueNotifier userCredential = ValueNotifier('');
  FirebaseFirestore _fire = FirebaseFirestore.instance;
  String token = "";

  signIn(context) async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';

    userCredential.value = await signInWithGoogle();

    if (userCredential.value != null) {
      prefs.setString('token', userCredential.value.credential!.accessToken);
      prefs.setString('uid', userCredential.value.user!.uid);
      DateTime now = DateTime.now();
      // String combined = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      _fire.collection('users').doc(userCredential.value.user!.uid).update({
        'email': userCredential.value.user!.email,
        'name': userCredential.value.user!.displayName,
        'accessToken': userCredential.value.credential!.accessToken,
        // 'Time' : DateTime.now().
      }).then((value) {
        print('user added');
      }).catchError((err) {
        print('error adding user');
      });
    }

    // setState(() {});
  }

  @override
  void initState() {
    signIn(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double appBarHeight = AppBar().preferredSize.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    final height = MediaQuery.of(context).size.height;
    double heightWithoutAppBar = height - appBarHeight - statusBarHeight;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shakshu',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[400],
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              prefs.clear();
              userCredential.value = '';
              FirebaseAuth.instance.signOut().then((value) {
                exit(0);
              });
            },
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder<dynamic>(
          future: signIn(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Container(
                width: width,
                height: height,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => BlindPeopleHomeScreen(
                              uid: userCredential.value.user!.uid,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: BorderDirectional(
                            bottom: BorderSide(color: Colors.black, width: 1),
                          ),
                        ),
                        height: heightWithoutAppBar / 2,
                        width: width,
                        child: const Center(
                          child: Text(
                            "For Blind Peoples",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => CareTakerHomeScreen(
                                      uid: userCredential.value.user!.uid,
                                    )));
                      },
                      child: Container(
                        height: heightWithoutAppBar / 2,
                        width: width,
                        child: Center(
                          child: Text(
                            "For Care Takers",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
      // body: userCredential.value == '' || userCredential.value == null
      //     ? Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : Container(
      //         width: width,
      //         height: height,
      //         child: Column(
      //           children: <Widget>[
      //             GestureDetector(
      //               onTap: () {
      //                 Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                     builder: (ctx) => BlindPeopleHomeScreen(
      //                       uid: userCredential.value.user!.uid,
      //                     ),
      //                   ),
      //                 );
      //               },
      //               child: Container(
      //                 decoration: BoxDecoration(
      //                   border: BorderDirectional(
      //                     bottom: BorderSide(color: Colors.black, width: 1),
      //                   ),
      //                 ),
      //                 height: height / 2,
      //                 width: width,
      //                 child: const Center(
      //                   child: Text(
      //                     "For Blind Peoples",
      //                     style: TextStyle(
      //                         fontSize: 18, fontWeight: FontWeight.bold),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             GestureDetector(
      //               onTap: () {
      //                 Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                         builder: (ctx) => CareTakerHomeScreen()));
      //               },
      //               child: Container(
      //                 height: height / 2,
      //                 width: width,
      //                 child: Center(
      //                   child: Text(
      //                     "For Care Takers",
      //                     style: TextStyle(
      //                         fontSize: 18, fontWeight: FontWeight.bold),
      //                   ),
      //                 ),
      //               ),
      //             )
      //           ],
      //         ),
      //       ),
    );
  }
}
