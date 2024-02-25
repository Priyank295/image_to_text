import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:camera_android/camera_android.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_to_text/text_screen.dart';
import './api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore _fire = FirebaseFirestore.instance;
  String? _currentAddress;
  Position? _currentPosition;
//
  // List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  XFile? image;
  // CloudApi? api;
  SharedPreferences? prefs;
  String accessToken = "";

  // Future<bool> _handleLocationPermission() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text(
  //             'Location services are disabled. Please enable the services')));
  //     return false;
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Location permissions are denied')));
  //       return false;
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text(
  //             'Location permissions are permanently denied, we cannot request permissions.')));
  //     return false;
  //   }
  //   return true;
  // }

  // Future<void> _getAddressFromLatLng(Position position) async {
  //   await placemarkFromCoordinates(
  //           _currentPosition!.latitude, _currentPosition!.longitude)
  //       .then((List<Placemark> placemarks) {
  //     Placemark place = placemarks[0];
  //     setState(() {
  //       _currentAddress =
  //           '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
  //     });
  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  // }

  // Future<void> _getCurrentPosition() async {
  //   final hasPermission = await _handleLocationPermission();

  //   if (!hasPermission) return;
  //   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //       .then((Position position) {
  //     setState(() => _currentPosition = position);
  //     _getAddressFromLatLng(_currentPosition!);
  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  // }

  // loadCamera() async {
  //   prefs = await SharedPreferences.getInstance();
  //   cameras = await availableCameras();

  //   if (cameras != null) {
  //     controller = CameraController(cameras![0], ResolutionPreset.max);
  //     //cameras[0] = first camera, change to 1 to another camera

  //     controller!.initialize().then((_) {
  //       if (!mounted) {
  //         return;
  //       }
  //       setState(() {
  //         accessToken = prefs!.getString('token')!;
  //       });
  //     });
  //   } else {
  //     print("NO any camera found");
  //   }
  // }

  // @override
  // void initState() {
  //   _handleLocationPermission();
  //   loadCamera();
  //   // fetchCaptions();
  //   _getCurrentPosition();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        // child: ,
        child: controller == null
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Stack(
                children: [
                  Container(
                    width: width,
                    height: height,
                    child: CameraPreview(
                      controller!,
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    right: width / 2 - 55,
                    child: GestureDetector(
                      onTap: () {
                        // _fire..collection('user').doc()
                        controller!.takePicture().then((value) {
                          print("ACCESS TOKEN : " + accessToken);
                          setState(() {
                            image = value;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) =>
                                        TextScreen(image!, accessToken)));
                          });
                        });
                      },
                      child: Container(
                        width: 110,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.blue),
                        child: Center(
                            child: Text(
                          "Capture",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
