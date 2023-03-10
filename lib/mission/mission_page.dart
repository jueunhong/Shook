import 'dart:io';
import 'package:camera_app/fonts.dart';

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../home/home_page.dart';
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
  bool isCompleted = false;
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  void changeCompleted() {
    setState(() {
      isCompleted = !isCompleted;
    });
  }

  File? _image;

  Future uploadImageToFirestore(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);
    setState(() {
      _image = File(image!.path);
    });

    Reference storageRef = FirebaseStorage.instance.ref().child(
        'images/${widget.mission.missionId}/$userId/${getRandomString(5)}');
    final imageUploaderDoc =
        FirebaseFirestore.instance.collection('users').doc(userId);

    final missionDoc = FirebaseFirestore.instance
        .collection("missions")
        .doc(widget.mission.missionId);

    final imagesCollection = FirebaseFirestore.instance
        .collection("missions")
        .doc(widget.mission.missionId)
        .collection("images");
    if (_image != null) {
      await storageRef.putFile(_image!);
      final userImageUrl = await storageRef.getDownloadURL();

      imagesCollection.add({
        'image': userImageUrl,
        'user': userId,
      });
    }
    await missionDoc.set({
      'imageUploaders': FieldValue.arrayUnion([userId])
    }, SetOptions(merge: true));
    await imageUploaderDoc
        .set({'points': FieldValue.increment(10)}, SetOptions(merge: true));
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
        // get image data as a string
        final imageData = doc.data()['image'] as String;

        // get the uploaderId
        final uploaderId = doc.data()['user'] as String;
        //create a map with the image data and uploaderId and docId
        return ImageFromMission(
            missionId: widget.mission.missionId,
            missionUploaderId: widget.mission.missionUploader,
            imageId: doc.id,
            imageUrl: imageData,
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
                        if (!snapshot.hasData) {
                          return Center(
                              child: Container(
                                  width: 100,
                                  height: 100,
                                  child: CircularProgressIndicator()));
                        }

                        if (snapshot.data!.isEmpty) {
                          return Center(
                              child: Column(
                            children: [
                              SizedBox(
                                height: 50,
                              ),
                              Image(
                                  height: 100,
                                  image: AssetImage('assets/images/empty.png')),
                              Text(
                                'No images yet',
                                style: TextStyle(
                                    color: Color(0xff7D67E6),
                                    fontFamily:
                                        MyfontsFamily.pretendardSemiBold,
                                    fontSize: 16),
                              )
                            ],
                          ));
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
                                                changeCompleted:
                                                    changeCompleted,
                                                images: images,
                                                index: index,
                                              )));
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    image.imageUrl,
                                    width: 10,
                                    height: 10,
                                    fit: BoxFit.cover,
                                  ),
                                ));
                          },
                        );
                      }),
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
          ),
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            uploadImageToFirestore(ImageSource.camera);
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
  final String imageUrl;
  final String imageUploaderId;

  ImageFromMission({
    required this.missionId,
    required this.missionUploaderId,
    required this.imageUrl,
    required this.imageId,
    required this.imageUploaderId,
  });
}
