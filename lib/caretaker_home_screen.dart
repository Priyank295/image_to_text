import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:image_to_text/widgets.dart';

class CareTakerHomeScreen extends StatefulWidget {
  String uid;
  CareTakerHomeScreen({required this.uid});

  @override
  State<CareTakerHomeScreen> createState() => _CareTakerHomeScreenState();
}

FirebaseFirestore _fire = FirebaseFirestore.instance;

LatLng latLng = LatLng(0, 0);
String name = "";

class _CareTakerHomeScreenState extends State<CareTakerHomeScreen> {
  Completer<GoogleMapController> _controller = Completer();
  _getLocationData() async {
    await _fire.collection('users').doc(widget.uid).get().then((value) {
      print(value.data());
      latLng = LatLng(value['latitude'], value['longitude']);
      name = value['name'];
    });
  }

  @override
  void initState() {
    print("UID: " + widget.uid);
    _getLocationData();
    // TODO: implement initState
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: buildAppBar(context),
      ),
      body: name.isEmpty
          ? FutureBuilder(
              future: _getLocationData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return GoogleMap(
                  mapType: MapType.hybrid,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: latLng,
                    zoom: 11.0,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId(name),
                      position: latLng,
                    )
                  },
                );
              },
            )
          : GoogleMap(
              mapType: MapType.hybrid,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: latLng,
                zoom: 11.0,
              ),
              markers: {
                Marker(
                  markerId: MarkerId(name),
                  position: latLng,
                )
              },
            ),
    );
  }
}
