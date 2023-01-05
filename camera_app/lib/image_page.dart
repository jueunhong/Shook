import 'package:camera_app/mission_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DetailImagePage extends StatefulWidget {
  const DetailImagePage({Key? key, required this.images, required this.index})
      : super(key: key);
  final List<ImageFromMission> images;
  final int index;
  @override
  State<DetailImagePage> createState() => _DetailImagePageState();
}

class _DetailImagePageState extends State<DetailImagePage> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  bool canChoose = false;

  void givePointsAndSetMissionCompleted(SelectedImage selectedImage) async {
    final imageUploaderDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(selectedImage.ImageUploaderId);
    final missionUploaderDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(selectedImage.missionUploaderId);
    final missionDoc = FirebaseFirestore.instance
        .collection('missions')
        .doc(selectedImage.missionId);

    await imageUploaderDoc.update({'points': FieldValue.increment(10)});
    await missionUploaderDoc.update({'points': FieldValue.increment(10)});
    await missionDoc.update({
      'isCompleted': true,
      'selectedImageId': selectedImage.ImageId,
      'selectedImageUploader': selectedImage.ImageUploaderId,
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.images[widget.index].missionUploaderId == userId) {
      canChoose = !canChoose;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          itemCount: widget.images.length,
          itemBuilder: (context, index) {
            return Stack(children: [
              Container(
                  height: 390,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/imagepage_bg.png'),
                  ))),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.memory(
                      widget.images[index].ImageUrl,
                      height: 380,
                      width: 260,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    canChoose
                        ? SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff5F50B1),
                              ),
                              onPressed: () {
                                givePointsAndSetMissionCompleted(SelectedImage(
                                    missionId: widget.images[index].missionId,
                                    missionUploaderId:
                                        widget.images[index].missionUploaderId,
                                    ImageId: widget.images[index].ImageId,
                                    ImageUploaderId:
                                        widget.images[index].ImageUploaderId));
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'CATCH!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Text(
                                    'I will select this picture',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Container(
                            height: 10,
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
            ]);
          }),
    );
  }
}

class SelectedImage {
  final String missionId;
  final String missionUploaderId;
  final String ImageId;
  final String ImageUploaderId;

  SelectedImage({
    required this.missionId,
    required this.missionUploaderId,
    required this.ImageId,
    required this.ImageUploaderId,
  });
}
