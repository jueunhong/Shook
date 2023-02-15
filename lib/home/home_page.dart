import 'package:camera_app/mission/missiongallery_page.dart';
import 'package:camera_app/ranking_page.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../fonts.dart';

import 'challengeTap.dart';
import 'missionTap.dart';
import 'createmission_page.dart';

import '../mypage/my_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isMissionTap = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: 390,
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/homepage_bg.png'),
              ))),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 90),
              Text(
                "CATCH",
                style: TextStyle(
                  fontFamily: "Pretendard-ExtraBold",
                  fontSize: 36,
                  color: Colors.white,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 330,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.only(top: 70, right: 35, left: 35),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: isMissionTap
                                    ? Color(0xff7B68E6)
                                    : Color(0xffD1C7E8),
                                textStyle: TextStyle(
                                  fontFamily: MyfontsFamily.pretendardSemiBold,
                                  fontSize: 24,
                                )),
                            onPressed: () {
                              setState(() {
                                isMissionTap = true;
                              });
                            },
                            child: Text(
                              'Missions',
                            ),
                          ),
                          Text(
                            '|',
                            style: TextStyle(
                                fontFamily: MyfontsFamily.pretendardSemiBold,
                                color: Color(0xff7B68E6),
                                fontSize: 24,
                                fontWeight: FontWeight.w700),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: !isMissionTap
                                    ? Color(0xff7B68E6)
                                    : Color(0xffD1C7E8),
                                textStyle: TextStyle(
                                  fontFamily: MyfontsFamily.pretendardSemiBold,
                                  fontSize: 24,
                                )),
                            onPressed: () {
                              setState(() {
                                isMissionTap = false;
                              });
                            },
                            child: Text(
                              'Challenges',
                            ),
                          ),
                        ],
                      ),
                      isMissionTap
                          ? Expanded(child: MissionTap())
                          : Expanded(child: ChallengeTap()),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Positioned(
          //   top: 30,
          //   right: 8,
          //   child: IconButton(
          //     icon: Icon(
          //       size: 40,
          //       CupertinoIcons.person_solid,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {
          //       Navigator.push(
          //           context, MaterialPageRoute(builder: (context) => MyPage()));
          //     },
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xff7E70E1),
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
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
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          isMissionTap
              ? Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateMissionPage()))
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateChallengePage()));
        },
        child: Icon(
          CupertinoIcons.add,
          color: Color(0xff6A62BD),
        ),
      ),
    );
  }
}

class Mission {
  final String missionId;
  final String missionTitle;
  final String missionDesc;
  final String missionUploader;
  bool? isCompleted;
  String? selectedImageId;

  Mission({
    required this.missionId,
    required this.missionTitle,
    required this.missionDesc,
    required this.missionUploader,
    this.isCompleted,
    this.selectedImageId,
  });
}

class Challenge {
  final String challengeId;
  final String challengeTitle;
  final String challengeDesc;
  final String challengeUploader;
  final int challengeGoals;
  final String challengeDuration;
  bool? isCompleted;

  Challenge({
    required this.challengeId,
    required this.challengeTitle,
    required this.challengeDesc,
    required this.challengeUploader,
    required this.challengeGoals,
    required this.challengeDuration,
    this.isCompleted,
  });
}
