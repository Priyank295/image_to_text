import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_to_text/api.dart';

class TextScreen extends StatefulWidget {
  XFile image;
  String accessToken;

  TextScreen(this.image, this.accessToken);

  @override
  State<TextScreen> createState() => _TextScreenState();
}

String caption = "";

class _TextScreenState extends State<TextScreen> {
  @override
  void initState() {
    setState(() {
      caption = "";
    });
    fetchCaptions(widget.accessToken, widget.image).then((value) {
      setState(() {
        caption = value;
      });
    }).then((value) async {
      await textToSpeech(caption, context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.file(
          //   widget.image ,
          //   height: 300,
          //   width: 300,
          // ),
          caption.isEmpty
              ? Center(
                  child: Text(
                  "Loading...",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  textAlign: TextAlign.center,
                ))
              : Center(
                  child: Text(
                    caption,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
        ],
      ),
    ));
  }
}
