import 'package:camera_app/challenge/challenge_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:flutter/material.dart';
import '../fonts.dart';
import 'home_page.dart';

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
          challengeDuration: data['duration'],
          challengeGoals: data['goals'],
          isCompleted: data['isCompleted'],
        );
      }).toList();
    });
  }

  final durationType = ["daily", "weekly", "monthly"];
  String selectedDuration = 'daily';
  List<Challenge> selectedChallenges = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: getChallengesFromFirestore(),
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
          selectedChallenges = challenges!
              .where((challenge) =>
                  challenge.challengeDuration == selectedDuration)
              .toList();

          return Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  height: 35,
                  child: DropdownButton(
                    value: selectedDuration,
                    items: durationType
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
                    onChanged: (value) {
                      setState(() {
                        selectedDuration = value!;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                    itemCount: selectedChallenges.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      final challenge = selectedChallenges[index];
                      return ListTile(
                        title: Text(challenge.challengeTitle,
                            style: TextStyle(
                              fontFamily: MyfontsFamily.pretendardMedium,
                            )),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Color(0xffA395EE),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    '${challenge.challengeDuration}',
                                    style: TextStyle(
                                      fontFamily:
                                          MyfontsFamily.pretendardSemiBold,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Color(0xffA395EE),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    '${challenge.challengeGoals} pic',
                                    style: TextStyle(
                                      fontFamily:
                                          MyfontsFamily.pretendardSemiBold,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
              ),
            ],
          );
        });
  }
}
