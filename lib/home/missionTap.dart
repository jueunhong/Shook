import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import '../fonts.dart';
import '../mission/mission_page.dart';
import 'home_page.dart';

class MissionTap extends StatefulWidget {
  const MissionTap({super.key});

  @override
  State<MissionTap> createState() => _MissionTapState();
}

class _MissionTapState extends State<MissionTap> {
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
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return Center(
                child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Image(
                    height: 100, image: AssetImage('assets/images/empty2.png')),
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
          return SizedBox(
            height: 100,
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
