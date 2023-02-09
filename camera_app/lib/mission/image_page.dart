import 'package:camera_app/fonts.dart';
import 'package:camera_app/mission/mission_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DetailImagePage extends StatefulWidget {
  const DetailImagePage(
      {Key? key,
      required this.images,
      required this.index,
      required this.changeCompleted})
      : super(key: key);
  final List<ImageFromMission> images;
  final int index;
  final Function changeCompleted;
  @override
  State<DetailImagePage> createState() => _DetailImagePageState();
}

class _DetailImagePageState extends State<DetailImagePage> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  String userNickname = 'default';
  bool canChoose = false;

  void givePointsAndSetMissionCompleted(SelectedImage selectedImage) async {
    final imageUploaderDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(selectedImage.imageUploaderId);
    final missionUploaderDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(selectedImage.missionUploaderId);
    final missionDoc = FirebaseFirestore.instance
        .collection('missions')
        .doc(selectedImage.missionId);

    await imageUploaderDoc
        .set({'points': FieldValue.increment(10)}, SetOptions(merge: true));
    await missionUploaderDoc
        .set({'points': FieldValue.increment(10)}, SetOptions(merge: true));
    await missionDoc.set({
      'isCompleted': true,
      'selectedImageId': selectedImage.imageUrl,
      'selectedImageUploader': selectedImage.imageUploaderId,
    }, SetOptions(merge: true));
  }

  @override
  void initState() {
    super.initState();
    if (widget.images[widget.index].missionUploaderId == userId) {
      canChoose = !canChoose;
    }
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.images[widget.index].imageUploaderId)
        .get()
        .then((snapshot) => setState(() {
              userNickname = snapshot.data()!['nickname'];
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          controller: PageController(initialPage: widget.index),
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
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Card(
                        color: Colors.white,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, right: 25.0, left: 25, bottom: 22),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    widget.images[index].imageUrl,
                                    height: 340,
                                    width: 230,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, bottom: 16),
                                child: Row(
                                  children: [
                                    Text(
                                      'Photo by',
                                      style: TextStyle(
                                          color: Color(0xff5F50B1),
                                          fontFamily:
                                              MyfontsFamily.pretendardSemiBold),
                                    ),
                                    Text('  '),
                                    Text(
                                      userNickname,
                                      style: TextStyle(
                                          color: Color(0xffAFA8D8),
                                          fontFamily:
                                              MyfontsFamily.pretendardSemiBold),
                                    )
                                  ],
                                ),
                              )
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    canChoose
                        ? SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(70)),
                                backgroundColor: Color(0xff5F50B1),
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(
                                          'Will you select this picture?',
                                          style: TextStyle(
                                            fontFamily:
                                                MyfontsFamily.pretendardMedium,
                                            color: Color(0xff5F50B1),
                                            fontSize: 18,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              givePointsAndSetMissionCompleted(
                                                  SelectedImage(
                                                      missionId: widget
                                                          .images[index]
                                                          .missionId,
                                                      missionUploaderId: widget
                                                          .images[index]
                                                          .missionUploaderId,
                                                      imageUrl: widget
                                                          .images[index]
                                                          .imageUrl,
                                                      imageUploaderId: widget
                                                          .images[index]
                                                          .imageUploaderId));
                                              widget.changeCompleted;
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'Yes',
                                              style: TextStyle(
                                                fontFamily: MyfontsFamily
                                                    .pretendardMedium,
                                                color: Color(0xffB5A8FF),
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'No',
                                              style: TextStyle(
                                                fontFamily: MyfontsFamily
                                                    .pretendardMedium,
                                                color: Color(0xffB5A8FF),
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Text(
                                'CATCH!',
                                style: TextStyle(
                                  fontFamily: MyfontsFamily.pretendardSemiBold,
                                  color: Colors.white,
                                  fontSize: 28,
                                ),
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
  final String imageUrl;
  final String imageUploaderId;

  SelectedImage({
    required this.missionId,
    required this.missionUploaderId,
    required this.imageUrl,
    required this.imageUploaderId,
  });
}