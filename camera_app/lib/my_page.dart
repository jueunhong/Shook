import 'package:camera_app/auth_service.dart';
import 'package:camera_app/fonts.dart';
import 'package:camera_app/ranking_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'home_page.dart';
import 'login_page.dart';
import 'missiongallery_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final email = FirebaseAuth.instance.currentUser?.email as String;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          margin: const EdgeInsets.only(top: 50, right: 20, left: 0),
          width: double.infinity,
          height: 230,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/mypage_bg.png'),
              fit: BoxFit.contain,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "SETTING",
                      style: TextStyle(
                          fontFamily: MyfontsFamily.pretendardMedium,
                          fontSize: 14,
                          color: Colors.white),
                    ),
                  ),
                  Text(
                    "|",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      AuthService authService = AuthService();
                      authService.signOut();
                      Navigator.pushNamedAndRemoveUntil(
                          context, "login", ((route) => false));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: Text(
                        "LOGOUT",
                        style: TextStyle(
                            fontFamily: MyfontsFamily.pretendardMedium,
                            fontSize: 14,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ]),
                SizedBox(
                  height: 40,
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text('Loading...');
                      }
                      final userData = snapshot.data;
                      return Text(
                        userData!['nickname'],
                        style: TextStyle(
                            fontFamily: MyfontsFamily.pretendardSemiBold,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontSize: 32),
                      );
                    }),
                Text(
                  email,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: MyfontsFamily.pretendardMedium,
                      fontSize: 14),
                ),
                SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text('Loading...');
                      }
                      final userData = snapshot.data;
                      return Text(
                        'My points: ${userData!['points']}',
                        style: TextStyle(
                            fontFamily: MyfontsFamily.pretendardSemiBold,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontSize: 28),
                      );
                    }),
              ],
            ),
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
                color: Color(0xff7E70E1),
              )),
        )
      ]),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xff7E70E1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                icon: Image(image: AssetImage('assets/icons/MissionList.png')),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MissionGallery()));
              },
              icon: Image(image: AssetImage('assets/icons/Home.png')),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RankingPage()));
              },
              icon: Image(image: AssetImage('assets/icons/Ranking.png')),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyPage()));
              },
              icon: Image(image: AssetImage('assets/icons/MyPage.png')),
            ),
          ],
        ),
      ),
    );
  }
}
