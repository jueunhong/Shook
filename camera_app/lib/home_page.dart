import 'dart:io';

import 'package:camera_app/my_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TakePicture extends StatefulWidget {
  const TakePicture({super.key});

  @override
  State<TakePicture> createState() => _TakePictureState();
}

class _TakePictureState extends State<TakePicture> {
  final picker = ImagePicker();
  File? _image;

  Future getImageFromCam(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);
    setState(() {
      _image = File(image!.path);
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
      body: Center(
        child: _image == null
            ? Text("No image selected")
            : Image.file(File(_image!.path)),
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
