import 'dart:convert';
import 'dart:io';
import 'package:camera_app/fonts.dart';
import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'home_page.dart';
import 'image_page.dart';

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
            imageId: doc.id,
            imageUrl: ByteData.view(imageData.buffer).buffer.asUint8List(),
            imageUploaderId: uploaderId);
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
                        fontFamily: MyfontsFamily.pretendardSemiBold,
                        color: Color(0xff5F50B1),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.mission.missionTitle,
                  style: TextStyle(
                      fontFamily: MyfontsFamily.pretendardSemiBold,
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
                          fontFamily: MyfontsFamily.pretendardSemiBold,
                          color: Color(0xff5F50B1),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 80,
                  child: Text(
                    widget.mission.missionDesc,
                    style: TextStyle(
                        color: Color(0xff636363),
                        fontFamily: MyfontsFamily.pretendardMedium,
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
                          fontFamily: MyfontsFamily.pretendardSemiBold,
                          color: Color(0xff5F50B1),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 5,
                // ),
                SizedBox(
                  height: 240,
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
                          padding: EdgeInsets.all(10),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                          itemCount: images!.length,
                          itemBuilder: (context, index) {
                            final image = images[index];
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailImagePage(
                                                images: images,
                                                index: index,
                                              )));
                                },
                                child: Image.memory(
                                  image.imageUrl,
                                  width: 10,
                                  height: 10,
                                  fit: BoxFit.cover,
                                ));
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            getImageFromCam(ImageSource.camera);
          },
          child: Image(
            image: AssetImage('assets/icons/camera.png'),
            height: 30,
          ),
          tooltip: "take picture!",
        ),
      ),
    );
  }
}

class ImageFromMission {
  final String missionId;
  final String missionUploaderId;
  final String imageId;
  final Uint8List imageUrl;
  final String imageUploaderId;

  ImageFromMission({
    required this.missionId,
    required this.missionUploaderId,
    required this.imageUrl,
    required this.imageId,
    required this.imageUploaderId,
  });
}
