import 'package:camera_app/fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: 152,
              width: double.infinity,
              child: Align(
                alignment: Alignment.center,
                child: Text('RANKING',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontFamily: MyfontsFamily.pretendardExtrabold,
                    )),
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/rankingpage_bg.png'),
              ))),
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
        ],
      ),
    );
  }
}
