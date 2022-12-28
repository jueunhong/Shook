import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TakePicture(),
    );
  }
}

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
