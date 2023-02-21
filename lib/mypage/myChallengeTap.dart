import 'package:camera_app/challenge/challenge_page.dart';
import 'package:camera_app/fonts.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../home/home_page.dart';

class MyChallengeTap extends StatefulWidget {
  const MyChallengeTap({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<MyChallengeTap> createState() => _MyChallengeTapState();
}

class _MyChallengeTapState extends State<MyChallengeTap> {
  final myChallengeType = ["made", "involved"];
  String selectedChallengeType = "made";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(children: [
        Align(
          alignment: Alignment.topRight,
          child: SizedBox(
              child: DropdownButton(
            value: selectedChallengeType,
            items: myChallengeType
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
                selectedChallengeType = value!;
              });
            }),
          )),
        ),
        StreamBuilder(
          stream: selectedChallengeType == "made"
              ? FirebaseFirestore.instance
                  .collection("challenges")
                  .where("user", isEqualTo: widget.userId)
                  .snapshots()
              : FirebaseFirestore.instance
                  .collection("challenges")
                  .where("participants", arrayContains: widget.userId)
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final challenges = snapshot.data!.docs;

            if (challenges.isEmpty) {
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 25,
                      crossAxisSpacing: 12),
                  itemCount: challenges.length,
                  itemBuilder: ((context, index) {
                    final challenge = challenges[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 10),
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
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChallengePage(
                                            challenge: Challenge(
                                              challengeId: challenge.id,
                                              challengeTitle:
                                                  challenge['title'],
                                              challengeDesc: challenge['desc'],
                                              challengeUploader:
                                                  challenge['user'],
                                              challengeGoals:
                                                  challenge['goals'],
                                              challengeDuration:
                                                  challenge['duration'],
                                              isCompleted:
                                                  challenge['isCompleted'],
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
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      challenge.data()['title'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Color(0xff2E73C2),
                                          fontFamily:
                                              MyfontsFamily.pretendardMedium),
                                    ),
                                    SvgPicture.asset(
                                        'assets/icons/calendar.svg'),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Color(0xffA395EE),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              challenge['duration'],
                                              style: TextStyle(
                                                fontFamily: MyfontsFamily
                                                    .pretendardSemiBold,
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
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              '${challenge['goals']} pic',
                                              style: TextStyle(
                                                fontFamily: MyfontsFamily
                                                    .pretendardSemiBold,
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
      ]),
    );
  }
}
