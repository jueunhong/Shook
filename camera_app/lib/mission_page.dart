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
    return Container(
      color: Color(0xff7D67E6),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Container(
              margin: EdgeInsets.only(top: 60),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(80)))),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 90,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xffD9D9D9),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Mission",
                      style: TextStyle(
                          color: Color(0xff5F50B1),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.mission.missionTitle,
                  style: TextStyle(
                      color: Color(0xffA395EE),
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xffD9D9D9),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Description",
                      style: TextStyle(
                          color: Color(0xff5F50B1),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.mission.missionDesc,
                  style: TextStyle(
                      color: Color(0xff636363),
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 100,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xffD9D9D9),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Participants",
                      style: TextStyle(
                          color: Color(0xff5F50B1),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 14,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  CupertinoIcons.arrow_left,
                  color: Colors.white,
                )),
          )
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            getImageFromCam(ImageSource.camera);
          },
          child: Icon(CupertinoIcons.camera),
          tooltip: "take picture!",
        ),
      ),
    );
  }
}
