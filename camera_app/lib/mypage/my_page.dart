import 'package:camera_app/login/auth_service.dart';
import 'package:camera_app/fonts.dart';
import 'package:camera_app/mypage/stackedimages.dart';
import 'package:camera_app/ranking_page.dart';
import 'package:camera_app/web3/web3.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../home/home_page.dart';
import '../mission/missiongallery_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with TickerProviderStateMixin {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final email = FirebaseAuth.instance.currentUser?.email as String;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 15,
        ),
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              CupertinoIcons.arrow_left,
              color: Color(0xff7E70E1),
            )),
        Container(
          margin: const EdgeInsets.only(top: 8, right: 20, left: 0),
          width: double.infinity,
          height: 230,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/mypage_bg.png'),
              fit: BoxFit.cover,
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
        Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 40, top: 20),
          child: SingleChildScrollView(
            child: Container(
              height: 20,
              child: TabBar(
                  isScrollable: true,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xff3E85E5),
                  ),
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Color(0xff96B8E0),
                  tabs: [
                    Tab(
                      text: "My Mission",
                    ),
                    Tab(
                      text: "My Challenge",
                    )
                  ]),
            ),
          ),
        ),
        Expanded(
          child: TabBarView(controller: _tabController, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: MyMissionTab(
                userId: uid!,
              ),
            ),
            MyChallengeTap()
          ]),
        ),
        // Center(
        //   child: SendToken(),
        // ),
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
              icon: const Image(image: AssetImage('assets/icons/Home.png')),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RankingPage()));
              },
              icon: const Image(image: AssetImage('assets/icons/Ranking.png')),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyPage()));
              },
              icon: const Image(image: AssetImage('assets/icons/MyPage.png')),
            ),
          ],
        ),
      ),
    );
  }
}

class MyMissionTab extends StatefulWidget {
  const MyMissionTab({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<MyMissionTab> createState() => _MyMissionTabState();
}

class _MyMissionTabState extends State<MyMissionTab> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("missions")
          .where("user", isEqualTo: widget.userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final missions = snapshot.data!.docs;
        if (missions.isEmpty) {
          return Center(
              child: Column(
            children: const [
              SizedBox(
                height: 40,
              ),
              Image(height: 100, image: AssetImage('assets/images/empty2.png')),
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
        return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 25, crossAxisSpacing: 12),
            itemCount: missions.length,
            itemBuilder: ((context, index) {
              final mission = missions[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xff68A0E2), Color(0xffB5A8FF)]),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: const Offset(4, 4))
                      ]),
                  height: 100,
                  width: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(2.5),
                    child: Container(
                      width: 90,
                      height: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            mission.data().containsKey("selectedImageId")
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                      mission.data()['selectedImageId'],
                                      height: 70,
                                      width: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Color(0xffD9D9D9)),
                                    child: const Center(
                                      child: Text(
                                        'Not \n Selected',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: MyfontsFamily
                                                .pretendardSemiBold,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                            Text(
                              mission.data()['title'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Color(0xff2E73C2),
                                  fontFamily: MyfontsFamily.pretendardMedium),
                            ),
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("missions")
                                    .doc(mission.id)
                                    .collection('images')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container();
                                  }
                                  final images = snapshot.data!.docs;
                                  final imageList = images.map((image) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        image.data()['image'],
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  }).toList();
                                  return images.isEmpty
                                      ? Container()
                                      : StackedWidgets(items: imageList);
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }));
      },
    );
  }
}

class MyChallengeTap extends StatefulWidget {
  const MyChallengeTap({super.key});

  @override
  State<MyChallengeTap> createState() => _MyChallengeTapState();
}

class _MyChallengeTapState extends State<MyChallengeTap> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
