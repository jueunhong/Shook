import 'package:camera_app/fonts.dart';
import 'package:camera_app/mypage/stackedimages.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../home/home_page.dart';
import '../mission/mission_page.dart';

class MyMissionTab extends StatefulWidget {
  const MyMissionTab({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<MyMissionTab> createState() => _MyMissionTabState();
}

class _MyMissionTabState extends State<MyMissionTab> {
  final myMissionType = ["made", "involved"];
  String selectedMissionType = "made";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: SizedBox(
                child: DropdownButton(
              value: selectedMissionType,
              items: myMissionType
                  .map((e) => DropdownMenuItem(
                        child: Text(
                          e,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: MyfontsFamily.pretendardMedium),
                        ),
                        value: e,
                      ))
                  .toList(),
              onChanged: ((value) {
                setState(() {
                  selectedMissionType = value!;
                });
              }),
            )),
          ),
          StreamBuilder(
            stream: selectedMissionType == "made"
                ? FirebaseFirestore.instance
                    .collection("missions")
                    .where("user", isEqualTo: widget.userId)
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection("missions")
                    .where("imageUploaders", arrayContains: widget.userId)
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
                    Image(
                        height: 100,
                        image: AssetImage('assets/images/empty2.png')),
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
              return Expanded(
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 25,
                            crossAxisSpacing: 12),
                    itemCount: missions.length,
                    itemBuilder: ((context, index) {
                      final mission = missions[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xff68A0E2),
                                    Color(0xffB5A8FF)
                                  ]),
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
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MissionPage(
                                              mission: Mission(
                                                missionId: mission.id,
                                                missionTitle: mission['title'],
                                                missionDesc: mission['desc'],
                                                missionUploader:
                                                    mission['user'],
                                                selectedImageId: mission
                                                        .data()
                                                        .containsKey(
                                                            "selectedImageId")
                                                    ? mission['selectedImageId']
                                                    : null,
                                                isCompleted:
                                                    mission['isCompleted'],
                                              ),
                                            )));
                              },
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      mission
                                              .data()
                                              .containsKey("selectedImageId")
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: Image.network(
                                                mission
                                                    .data()['selectedImageId'],
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
                                                      BorderRadius.circular(
                                                          100),
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
                                            fontFamily:
                                                MyfontsFamily.pretendardMedium),
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
                                            final imageList =
                                                images.map((image) {
                                              return ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image.network(
                                                  image.data()['image'],
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            }).toList();
                                            return images.isEmpty
                                                ? Container()
                                                : StackedWidgets(
                                                    items: imageList);
                                          })
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    })),
              );
            },
          ),
        ],
      ),
    );
  }
}
