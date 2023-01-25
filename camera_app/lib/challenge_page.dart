import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'fonts.dart';
import 'home_page.dart';
import 'package:table_calendar/table_calendar.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({Key? key, required this.challenge}) : super(key: key);

  final Challenge challenge;

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  final picker = ImagePicker();
  final userId = FirebaseAuth.instance.currentUser?.uid;
  File? _image;

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future uploadImageToFirestore(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);
    setState(() {
      _image = File(image!.path);
    });

    Reference storageRef = FirebaseStorage.instance.ref().child(
        'images/${widget.challenge.challengeId}/$userId/${getRandomString(5)}');

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists && userDoc.data()!.containsKey('nickname')) {
      final userNickname = userDoc.data()!['nickname'] as String;

      final challengersCollection = FirebaseFirestore.instance
          .collection("challenges")
          .doc(widget.challenge.challengeId)
          .collection("challengers")
          .doc(userId)
          .set({'nickname': userNickname});
    }

    final imagesCollection = FirebaseFirestore.instance
        .collection("challenges")
        .doc(widget.challenge.challengeId)
        .collection("challengers")
        .doc(userId)
        .collection(userId!);
    if (_image != null) {
      await storageRef.putFile(_image!);
      final userImageUrl = await storageRef.getDownloadURL();

      imagesCollection.add({
        'image': userImageUrl,
        'user': userId,
        'date': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xff7D67E6),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                  margin: EdgeInsets.only(top: 55),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(80)))),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 70,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Color(0xffD9D9D9),
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "Challenge",
                                style: TextStyle(
                                  fontFamily: MyfontsFamily.pretendardSemiBold,
                                  color: Color(0xff5F50B1),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Color(0xffA395EE),
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                widget.challenge.challengeDuration,
                                style: TextStyle(
                                  fontFamily: MyfontsFamily.pretendardSemiBold,
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Color(0xffA395EE),
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                '${widget.challenge.challengeGoals} 장',
                                style: TextStyle(
                                  fontFamily: MyfontsFamily.pretendardSemiBold,
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.challenge.challengeTitle,
                        style: TextStyle(
                            fontFamily: MyfontsFamily.pretendardSemiBold,
                            color: Color(0xffA395EE),
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xffD9D9D9),
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Description",
                            style: TextStyle(
                                fontFamily: MyfontsFamily.pretendardSemiBold,
                                color: Color(0xff5F50B1),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 70,
                        child: Text(
                          widget.challenge.challengeDesc,
                          style: TextStyle(
                              color: Color(0xff636363),
                              fontFamily: MyfontsFamily.pretendardMedium,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xffD9D9D9),
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Participants",
                            style: TextStyle(
                                fontFamily: MyfontsFamily.pretendardSemiBold,
                                color: Color(0xff5F50B1),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        height: 20,
                        child: TabBar(
                          indicatorColor: Color(0xff5F50B1),
                          controller: _tabController,
                          labelColor: Color(0xff5F50B1),
                          unselectedLabelColor: Color(0xffD9D9D9),
                          tabs: [
                            Tab(
                              text: "내 참여",
                            ),
                            Tab(
                              text: "다른 참가자",
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("challenges")
                                .doc(widget.challenge.challengeId)
                                .collection("challengers")
                                .snapshots(),
                            builder: ((context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text("Error: ${snapshot.error}");
                              }
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.data!.docs.isEmpty) {
                                return Center(
                                    child: Column(
                                  children: [
                                    Image(
                                        height: 100,
                                        image: AssetImage(
                                            'assets/images/empty.png')),
                                    Text(
                                      'No images yet',
                                      style: TextStyle(
                                          color: Color(0xff7D67E6),
                                          fontFamily:
                                              MyfontsFamily.pretendardSemiBold,
                                          fontSize: 16),
                                    )
                                  ],
                                ));
                              }

                              final challengers = snapshot.data!.docs;
                              return TabBarView(
                                  controller: _tabController,
                                  children: [
                                    ListView.builder(
                                        itemCount: challengers.length,
                                        itemBuilder: ((context, index) {
                                          final docId = challengers[index].id;
                                          if (docId == userId) {
                                            final currentUserImages =
                                                challengers[index];
                                            return StreamBuilder<QuerySnapshot>(
                                                stream: currentUserImages
                                                    .reference
                                                    .collection(docId)
                                                    .snapshots(),
                                                builder: ((context, snapshot) {
                                                  if (snapshot.hasError) {
                                                    return Text(
                                                        "Error: ${snapshot.error}");
                                                  }
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  }

                                                  final images =
                                                      snapshot.data!.docs;

                                                  return ChallengeCalendar(
                                                    images: images,
                                                  );
                                                }));
                                          } else
                                            return Container();
                                        })),
                                    PageView.builder(
                                        itemCount: challengers.length,
                                        itemBuilder: ((context, index) {
                                          final docId = challengers[index].id;
                                          final nickname = challengers[index]
                                              .get('nickname');
                                          if (docId != userId) {
                                            final currentUserImages =
                                                challengers[index];
                                            return StreamBuilder<QuerySnapshot>(
                                                stream: currentUserImages
                                                    .reference
                                                    .collection(docId)
                                                    .snapshots(),
                                                builder: ((context, snapshot) {
                                                  if (snapshot.hasError) {
                                                    return Text(
                                                        "Error: ${snapshot.error}");
                                                  }
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  }

                                                  final images =
                                                      snapshot.data!.docs;

                                                  return Column(
                                                    children: [
                                                      Text(nickname),
                                                      Container(
                                                        height: 330,
                                                        child:
                                                            ChallengeCalendar(
                                                          images: images,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }));
                                          } else
                                            return Container();
                                        })),
                                  ]);
                            })),
                      ),
                    ]),
              ),
              Positioned(
                top: 14,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      CupertinoIcons.arrow_left,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              uploadImageToFirestore(ImageSource.camera);
            },
            child: Image(
              image: AssetImage('assets/icons/camera.png'),
              height: 30,
            ),
            tooltip: "take picture!",
          ),
        ));
  }
}

class ChallengeCalendar extends StatefulWidget {
  const ChallengeCalendar({
    Key? key,
    required this.images,
  }) : super(key: key);
  final List<QueryDocumentSnapshot> images;
  @override
  State<ChallengeCalendar> createState() => _ChallengeCalendarState();
}

class _ChallengeCalendarState extends State<ChallengeCalendar> {
  final _eventsList = {};

  List _getEventsForDay(
    DateTime day,
  ) {
    widget.images.forEach((image) {
      final date = DateTime.fromMillisecondsSinceEpoch(image.get('date'));
      _eventsList[date] ??= 0;
      _eventsList[date]++;
    });

    return _eventsList.entries
        .where((e) => isSameDay(e.key, day))
        .map((e) => e.value)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: TableCalendar(
        eventLoader: _getEventsForDay,
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            return Wrap(
              children: List.generate(events.length, (index) {
                return Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.purple[300],
                    ));
              }),
            );
          },
        ),
        headerStyle:
            HeaderStyle(formatButtonVisible: false, titleCentered: true),
        calendarFormat: CalendarFormat.month,
        focusedDay: DateTime.now(),
        firstDay: DateTime(2010, 10, 16),
        lastDay: DateTime(2030, 3, 14),
      ),
    );
  }
}

class DetailChallengePage extends StatefulWidget {
  const DetailChallengePage(
      {Key? key,
      required this.challengers,
      required this.challengersIndex,
      required this.imageIndex})
      : super(key: key);
  final List challengers;
  final int challengersIndex;
  final int imageIndex;
  @override
  State<DetailChallengePage> createState() => _DetailChallengePageState();
}

class _DetailChallengePageState extends State<DetailChallengePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView.builder(
      controller: PageController(initialPage: widget.challengersIndex),
      itemCount: widget.challengers.length,
      itemBuilder: ((context, index) {
        final userId = widget.challengers[index].id;
        final imagesStream = widget.challengers[index];
        final userNickname = imagesStream.get('nickname');
        return Stack(children: [
          Container(
              height: 390,
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/imagepage_bg.png'),
              ))),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$userNickname님의 참여 사진입니다!'),
                StreamBuilder<QuerySnapshot>(
                    stream:
                        imagesStream.reference.collection(userId).snapshots(),
                    builder: ((context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      }
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final images = snapshot.data!.docs;

                      return SizedBox(
                        width: 300,
                        height: 400,
                        child: ListView.builder(
                            controller:
                                PageController(initialPage: widget.imageIndex),
                            itemCount: images.length,
                            itemBuilder: ((context, index) {
                              final image = images[index];
                              final tsdate = image['date'];
                              return Card(
                                child: Column(
                                  children: [
                                    Text(
                                        DateTime.fromMillisecondsSinceEpoch(
                                                    tsdate)
                                                .year
                                                .toString() +
                                            '/' +
                                            DateTime.fromMillisecondsSinceEpoch(
                                                    tsdate)
                                                .month
                                                .toString() +
                                            '/' +
                                            DateTime.fromMillisecondsSinceEpoch(
                                                    tsdate)
                                                .day
                                                .toString() +
                                            ' ' +
                                            DateTime.fromMillisecondsSinceEpoch(
                                                    tsdate)
                                                .hour
                                                .toString() +
                                            '시' +
                                            ' ' +
                                            DateTime.fromMillisecondsSinceEpoch(
                                                    tsdate)
                                                .minute
                                                .toString() +
                                            '분'),
                                    Image.network(image['image'])
                                  ],
                                ),
                              );
                            })),
                      );
                    })),
              ],
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
                  color: Colors.white,
                )),
          )
        ]);
      }),
    ));
  }
}
