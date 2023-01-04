import 'package:camera_app/mission_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailImagePage extends StatefulWidget {
  const DetailImagePage({Key? key, required this.image}) : super(key: key);
  final ImageFromMission image;
  @override
  State<DetailImagePage> createState() => _DetailImagePageState();
}

class _DetailImagePageState extends State<DetailImagePage> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  bool canChoose = false;
  @override
  void initState() {
    super.initState();
    if (widget.image.missionUploaderId == userId) {
      canChoose = !canChoose;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
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
                widget.image.ImageUrl,
                height: 380,
                width: 260,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 30,
              ),
              canChoose
                  ? Container(
                      width: double.infinity,
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xff5F50B1),
                      ))
                  : SizedBox(
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
      ]),
    );
  }
}
