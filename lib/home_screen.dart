import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:camera_android/camera_android.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_to_text/text_screen.dart';
import './api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  XFile? image;
  // CloudApi? api;
  SharedPreferences? prefs;
  String accessToken = "";

  @override
  void initState() {
    loadCamera();
    // fetchCaptions();
    super.initState();
  }

  loadCamera() async {
    prefs = await SharedPreferences.getInstance();
    cameras = await availableCameras();

    if (cameras != null) {
      controller = CameraController(cameras![0], ResolutionPreset.max);
      //cameras[0] = first camera, change to 1 to another camera

      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          accessToken = prefs!.getString('token')!;
        });
      });
    } else {
      print("NO any camera found");
    }
  }

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
