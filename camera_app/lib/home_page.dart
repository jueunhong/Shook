import 'package:camera_app/challenge_page.dart';
import 'package:camera_app/missiongallery_page.dart';
import 'package:camera_app/ranking_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'fonts.dart';

import 'createmission_page.dart';
import 'mission_page.dart';
import 'my_page.dart';

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
                  child: Stack(
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
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: isMissionTap ? MissionList() : ChallengeTap(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

class MissionList extends StatefulWidget {
  const MissionList({super.key});

  @override
  State<MissionList> createState() => _MissionListState();
}

class _MissionListState extends State<MissionList> {
  Stream<List<Mission>> getMissionsFromFirestore() {
    final missionsCollection = FirebaseFirestore.instance
        .collection("missions")
        .orderBy('title')
        .snapshots();
    return missionsCollection.map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Mission(
          missionId: doc.id,
          missionTitle: data['title'],
          missionDesc: data['desc'],
          missionUploader: data['user'],
          selectedImageId: data['selectedImageId'],
          isCompleted: data['isCompleted'],
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: getMissionsFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (!snapshot.hasData) {
            return Center(
                child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Image(
                    height: 150, image: AssetImage('assets/images/empty2.png')),
                Text(
                  'No mission yet',
                  style: TextStyle(
                      color: Color(0xff7D67E6),
                      fontFamily: MyfontsFamily.pretendardSemiBold,
                      fontSize: 16),
                )
              ],
            ));
          }
          final missions = snapshot.data;
          return Expanded(
            child: ListView.separated(
                itemCount: missions!.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final mission = missions[index];
                  return ListTile(
                    title: Text(mission.missionTitle,
                        style: TextStyle(
                          fontFamily: MyfontsFamily.pretendardMedium,
                        )),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MissionPage(
                                    mission: mission,
                                  )));
                    },
                  );
                }),
          );
        });
  }
}

class ChallengeTap extends StatefulWidget {
  const ChallengeTap({super.key});

  @override
  State<ChallengeTap> createState() => _ChallengeTapState();
}

class _ChallengeTapState extends State<ChallengeTap> {
  Stream<List<Challenge>> getChallengesFromFirestore() {
    final challengesCollection = FirebaseFirestore.instance
        .collection("challenges")
        .orderBy('title')
        .snapshots();
    return challengesCollection.map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Challenge(
          challengeId: doc.id,
          challengeTitle: data['title'],
          challengeDesc: data['desc'],
          challengeUploader: data['user'],
          challengeGoals: data['goals'],
          isCompleted: data['isCompleted'],
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: getChallengesFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (!snapshot.hasData) {
            return Center(
                child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Image(
                    height: 150, image: AssetImage('assets/images/empty2.png')),
                Text(
                  'No challenge yet',
                  style: TextStyle(
                      color: Color(0xff7D67E6),
                      fontFamily: MyfontsFamily.pretendardSemiBold,
                      fontSize: 16),
                )
              ],
            ));
          }
          final challenges = snapshot.data;
          return Expanded(
            child: ListView.separated(
                itemCount: challenges!.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final challenge = challenges[index];
                  return ListTile(
                    title: Text(challenge.challengeTitle,
                        style: TextStyle(
                          fontFamily: MyfontsFamily.pretendardMedium,
                        )),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChallengePage(
                                    challenge: challenge,
                                  )));
                    },
                  );
                }),
          );
        });
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
  bool? isCompleted;

  Challenge({
    required this.challengeId,
    required this.challengeTitle,
    required this.challengeDesc,
    required this.challengeUploader,
    required this.challengeGoals,
    this.isCompleted,
  });
}
