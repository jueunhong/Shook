import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

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

  Stream<List<ImageFromMission>> getImagesFromMission() {
    final imagesCollection = FirebaseFirestore.instance
        .collection("missions")
        .doc(widget.mission.missionId)
        .collection("images")
        .snapshots();
    // Map the snapshots to a stream of lists of Map<String, dynamic> objects
    return imagesCollection.map((snapshot) {
      // Create a list of Map<String, dynamic> objects from the documents in the snapshot
      return snapshot.docs.map((doc) {
        // get the base64-encoded image data as a string
        final imageDataString = doc.data()['image'] as String;
        // decode the string to a Uint8List
        final imageData = base64Decode(imageDataString);
        // get the uploaderId
        final uploaderId = doc.data()['user'] as String;
        //create a map with the image data and uploaderId and docId
        return ImageFromMission(
            missionId: widget.mission.missionId,
            missionUploaderId: widget.mission.missionUploader,
            ImageId: doc.id,
            ImageUrl: ByteData.view(imageData.buffer).buffer.asUint8List(),
            ImageUploaderId: uploaderId);
      }).toList();
    });
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
                SizedBox(
                  height: 100,
                  child: Text(
                    widget.mission.missionDesc,
                    style: TextStyle(
                        color: Color(0xff636363),
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  ),
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
                      "Participants",
                      style: TextStyle(
                          color: Color(0xff5F50B1),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 10,
                // ),
                SizedBox(
                  height: 290,
                  child: StreamBuilder(
                      stream: getImagesFromMission(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text("Error: ${snapshot.error}"));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text("😭 No images yet"));
                        }
                        final images = snapshot.data;
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemCount: images!.length,
                          itemBuilder: (context, index) {
                            final image = images[index];
                            return Image.memory(
                              image.ImageUrl,
                              height: 30,
                              fit: BoxFit.cover,
                            );
                          },
                        );
                      }),
                )
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

class ImageFromMission {
  final String missionId;
  final String missionUploaderId;
  final String ImageId;
  final Uint8List ImageUrl;
  final String ImageUploaderId;

  ImageFromMission({
    required this.missionId,
    required this.missionUploaderId,
    required this.ImageUrl,
    required this.ImageId,
    required this.ImageUploaderId,
  });
}
