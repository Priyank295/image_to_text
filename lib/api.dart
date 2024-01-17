import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/oauth2/v2.dart' as oauth2;
import 'package:googleapis/vmwareengine/v1.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

const projectID = "groovy-height-411217", location = "us-central1";
FlutterTts flutterTts = FlutterTts();

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('assets/$path');

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.create(recursive: true);
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}

Future<String> fetchCaptions(String accessToken, XFile image) async {
  Uint8List _bytes = await image.readAsBytes();

  String _base64String = base64.encode(_bytes);
  final url =
      'https://${location}-aiplatform.googleapis.com/v1/projects/${projectID}/locations/${location}/publishers/google/models/imagetext:predict';

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${accessToken}'
  };

  final body = {
    "instances": [
      {
        "image": {"bytesBase64Encoded": _base64String}
      }
    ],
    "parameters": {"sampleCount": 1, "language": "en"}
  };
  final body2 = jsonEncode(body);

  final response =
      await http.post(Uri.parse(url), headers: headers, body: body2);

  if (response.statusCode == 200) {
    // Request successful, handle the response
    // print(response.body);
    var data = jsonDecode(response.body);
    var text = data['predictions'][0];

    return text;
  } else {
    // Request failed, handle the error
    print('Request failed with status: ${response.body}');
    return "";
  }
}

Future<void> textToSpeech(String text, context) async {
  await flutterTts.setLanguage("en-US");
  await flutterTts.setPitch(1);
  await flutterTts.speak(text).then((value) {
    Timer(const Duration(seconds: 5), () {
      Navigator.pop(context);
    });
  });
}
