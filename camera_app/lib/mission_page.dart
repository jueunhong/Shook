import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'home_page.dart';

class MissionPage extends StatefulWidget {
  const MissionPage({Key? key, required this.mission}) : super(key: key);
  final Mission mission;
  @override
  State<MissionPage> createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  final picker = ImagePicker();
  final userId = FirebaseAuth.instance.currentUser?.uid;

  File? _image;

  Future getImageFromCam(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);
    setState(() {
      _image = File(image!.path);
    });
    await uploadImageToFirestore(_image!);
  }

  Future<void> uploadImageToFirestore(File image) async {
    final imagesCollection = FirebaseFirestore.instance
        .collection("missions")
        .doc(widget.mission.missionId)
        .collection("images");
    // read the image file as a bytes array
    List<int> imageBytes = await image.readAsBytes();
    // encode the bytes array as a base64 string
    String imageBase64 = base64Encode(imageBytes);

    // add a new document to the 'images' collection in Cloud Firestore
    imagesCollection.add(
      {'image': imageBase64, "user": userId},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mission.missionTitle),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(widget.mission.missionTitle),
            Text(widget.mission.missionDesc)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImageFromCam(ImageSource.camera);
        },
        child: Icon(CupertinoIcons.camera),
        tooltip: "take picture!",
      ),
    );
  }
}
