import 'package:camera_app/fonts.dart';
import 'package:camera_app/mission/mission_page.dart';
import 'package:camera_app/ranking_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home/home_page.dart';

import '../mypage/my_page.dart';

class MissionGallery extends StatefulWidget {
  const MissionGallery({super.key});

  @override
  State<MissionGallery> createState() => _MissionGalleryState();
}

class _MissionGalleryState extends State<MissionGallery> {
  PageController _pageController = PageController();
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
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffB5A8FF),
      body: Stack(children: [
        Container(
            margin: EdgeInsets.only(top: 60),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Color(0xffF6F6F6),
                borderRadius:
                    BorderRadius.only(topRight: Radius.circular(100)))),
        Positioned(
          top: 80,
          left: 20,
          child: Text(
            'Explore Missions',
            style: TextStyle(
              color: Color(0xffB5A8FF),
              fontFamily: MyfontsFamily.pretendardSemiBold,
              fontSize: 24,
            ),
          ),
        ),
        StreamBuilder(
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
            return Padding(
              padding: const EdgeInsets.only(top: 120),
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: missions!.length,
                itemBuilder: (context, index) {
                  final mission = missions[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MissionPage(mission: mission)));
                    },
                    child: GestureDetector(
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity! < 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MissionPage(mission: mission)));
                        }
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xffD9D9D9),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "Mission",
                                        style: TextStyle(
                                          fontFamily:
                                              MyfontsFamily.pretendardSemiBold,
                                          color: Color(0xff5F50B1),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    mission.missionTitle,
                                    style: TextStyle(
                                        fontFamily:
                                            MyfontsFamily.pretendardSemiBold,
                                        color: Color(0xffA395EE),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xffD9D9D9),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "Description",
                                        style: TextStyle(
                                            fontFamily: MyfontsFamily
                                                .pretendardSemiBold,
                                            color: Color(0xff5F50B1),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 60,
                                    child: Text(
                                      mission.missionDesc,
                                      style: TextStyle(
                                          color: Color(0xff636363),
                                          fontFamily:
                                              MyfontsFamily.pretendardMedium,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
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
