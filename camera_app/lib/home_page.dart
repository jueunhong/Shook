import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera_app/my_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TakePicture extends StatefulWidget {
  const TakePicture({super.key});

  @override
  State<TakePicture> createState() => _TakePictureState();
}

class _TakePictureState extends State<TakePicture> {
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
    final imagesCollection = FirebaseFirestore.instance.collection("images");
    // read the image file as a bytes array
    List<int> imageBytes = await image.readAsBytes();
    // encode the bytes array as a base64 string
    String imageBase64 = base64Encode(imageBytes);

    // add a new document to the 'images' collection in Cloud Firestore
    imagesCollection.add(
      {'image': imageBase64, "user": userId},
    );
  }

  Stream<List<Map<String, dynamic>>> getImageFromFirestore() {
    final imagesCollection =
        FirebaseFirestore.instance.collection("images").snapshots();
    // map the snapshots to a stream of lists of ByteData objects
    return imagesCollection.map((snapshot) {
      // create a list of ByteData objects from the documents in the snapshot
      return snapshot.docs.map((doc) {
        // get the base64-encoded image data as a string
        final imageDataString = doc.data()['image'] as String;
        // decode the string to a Uint8List
        final imageData = base64Decode(imageDataString);
        // get the uploaderId
        final uploaderId = doc.data()['user'] as String;
        //create a map with the image data and uploaderId and docId
        return {
          'data': ByteData.view(imageData.buffer),
          'uploaderId': uploaderId,
          'docId': doc.id,
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera Mission"),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.person_solid),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyPage()));
            },
          )
        ],
      ),
      body: StreamBuilder(
          stream: getImageFromFirestore(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("😭 No photos yet"));
            }
            final images = snapshot.data;
            return ListView.builder(
                itemCount: images?.length,
                itemBuilder: (context, index) {
                  final imageData = images?[index]['data'];
                  final uploaderId = images?[index]['uploaderId'];
                  final docId = images?[index]['docId'];
                  return ImageFeed(
                    imageUrl: imageData!.buffer.asUint8List(),
                    uploaderId: uploaderId,
                    docId: docId,
                  );
                });
          }),
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

class ImageFeed extends StatefulWidget {
  const ImageFeed({
    Key? key,
    required this.imageUrl,
    required this.uploaderId,
    required this.docId,
  }) : super(key: key);

  final Uint8List imageUrl;
  final String uploaderId;
  final String docId;

  @override
  State<ImageFeed> createState() => _ImageFeedState();
}

class _ImageFeedState extends State<ImageFeed> {
  //로그인한 userid와 image uploader의 userid를 비교해서 삭제
  final userId = FirebaseAuth.instance.currentUser?.uid;
  bool canDelete = false;

  @override
  void initState() {
    super.initState();
    if (widget.uploaderId == userId) {
      canDelete = !canDelete;
    }
  }

  Future<void> deleteImageFromFireStore(String docId) async {
    final imageCollection = FirebaseFirestore.instance.collection("images");
    final imageDocument = imageCollection.doc(docId);
    await imageDocument.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.memory(
          widget.imageUrl,
          height: 400,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(CupertinoIcons.heart),
            ),
            Spacer(),
            (canDelete
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        deleteImageFromFireStore(widget.docId);
                      });
                    },
                    icon: Icon(CupertinoIcons.delete),
                  )
                : SizedBox()),
          ],
        )
      ],
    );
  }
}
