import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  Stream<List<Mission>> getMissionsFromFirestore() {
    final missionsCollection =
        FirebaseFirestore.instance.collection("missions").snapshots();
    return missionsCollection.map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Mission(
            missionId: doc.id,
            missionTitle: data['title'],
            missionDesc: data['desc'],
            missionUploader: data['user']);
      }).toList();
    });
  }

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
              SizedBox(height: 120),
              Text(
                "CATCH",
                style: TextStyle(
                  fontFamily: "Pretendard-ExtraBold",
                  fontSize: 36,
                  color: Colors.white,
                ),
              ),
              Container(
                height: 350,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.only(top: 70, right: 35, left: 35),
                child: StreamBuilder(
                    stream: getMissionsFromFirestore(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      }
                      if (!snapshot.hasData) {
                        return Center(
                            child: Text(
                          "😭 No missions yet",
                          style: TextStyle(
                            fontFamily: "Pretendard-SemiBold",
                          ),
                        ));
                      }
                      final missions = snapshot.data;
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Text(
                                  'Missions',
                                  style: TextStyle(
                                      fontFamily:
                                          MyfontsFamily.pretendardSemiBold,
                                      color: Color(0xff7B68E6),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700),
                                ),
                                Spacer(),
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateMissionPage()));
                                    },
                                    tooltip: "add Mission!",
                                    icon: Image(
                                        image: AssetImage(
                                            'assets/icons/create_mission.png')))
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.separated(
                                itemCount: missions!.length,
                                separatorBuilder: (context, index) => Divider(),
                                itemBuilder: (context, index) {
                                  final mission = missions[index];
                                  return ListTile(
                                    title: Text(mission.missionTitle,
                                        style: TextStyle(
                                          fontFamily:
                                              MyfontsFamily.pretendardMedium,
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
                          ),
                        ],
                      );
                    }),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Color(0xff7E70E1),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                icon: Image(image: AssetImage('assets/icons/MissionList.png')),
              ),
              label: 'List',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                icon: Image(image: AssetImage('assets/icons/Home.png')),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                icon: Image(image: AssetImage('assets/icons/Ranking.png')),
              ),
              label: 'Ranking',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyPage()));
                },
                icon: Image(image: AssetImage('assets/icons/MyPage.png')),
              ),
              label: 'MyPage',
            ),
          ]),
    );
  }
}

class Mission {
  final String missionId;
  final String missionTitle;
  final String missionDesc;
  final String missionUploader;

  Mission({
    required this.missionId,
    required this.missionTitle,
    required this.missionDesc,
    required this.missionUploader,
  });
}
