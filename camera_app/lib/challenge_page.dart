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
  PageController _pageController = PageController();
  bool canChoose = false;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    if (widget.challenge.challengeUploader == userId) {
      canChoose = !canChoose;
    }
    _tabController = TabController(length: 2, vsync: this);
  }

  final picker = ImagePicker();
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
        'isConfirm': false,
        'likes': [],
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
                                '${widget.challenge.challengeGoals} pic',
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
                              text: "My",
                            ),
                            Tab(
                              text: "Others",
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

                              final challengers = snapshot.data!.docs;
                              final otherChallengers = challengers
                                  .where((c) => c.id != userId)
                                  .toList();
                              return TabBarView(
                                  controller: _tabController,
                                  children: [
                                    if (challengers.any((c) => c.id == userId))
                                      StreamBuilder<QuerySnapshot>(
                                        stream: challengers
                                            .firstWhere((c) => c.id == userId)
                                            .reference
                                            .collection(userId!)
                                            .orderBy('date', descending: false)
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

                                          final images = snapshot.data!.docs;

                                          return ChallengeCalendar(
                                            canChoose: canChoose,
                                            images: images,
                                            challengeId:
                                                widget.challenge.challengeId,
                                          );
                                        }),
                                      )
                                    else
                                      Center(
                                          child: Column(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                          ),
                                          Image(
                                              height: 100,
                                              image: AssetImage(
                                                  'assets/images/empty.png')),
                                          Text(
                                            "Let's start challenge",
                                            style: TextStyle(
                                                color: Color(0xff7D67E6),
                                                fontFamily: MyfontsFamily
                                                    .pretendardSemiBold,
                                                fontSize: 16),
                                          )
                                        ],
                                      )),
                                    if (otherChallengers.isEmpty)
                                      Center(
                                          child: Column(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                          ),
                                          Image(
                                              height: 100,
                                              image: AssetImage(
                                                  'assets/images/empty.png')),
                                          Text(
                                            "No other participant",
                                            style: TextStyle(
                                                color: Color(0xff7D67E6),
                                                fontFamily: MyfontsFamily
                                                    .pretendardSemiBold,
                                                fontSize: 16),
                                          )
                                        ],
                                      ))
                                    else
                                      PageView.builder(
                                          controller: _pageController,
                                          itemCount: otherChallengers.length,
                                          itemBuilder: ((context, index) {
                                            final docId =
                                                otherChallengers[index].id;
                                            final nickname =
                                                otherChallengers[index]
                                                    .get('nickname');

                                            return StreamBuilder<QuerySnapshot>(
                                                stream: otherChallengers[index]
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
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .grey[50],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Text(
                                                            "$nickname's challenge",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    MyfontsFamily
                                                                        .pretendardSemiBold,
                                                                color: Color(
                                                                    0xff7D67E6)),
                                                          )),
                                                      SizedBox(
                                                        height: 320,
                                                        child: ChallengeCalendar(
                                                            canChoose:
                                                                canChoose,
                                                            images: images,
                                                            challengeId: widget
                                                                .challenge
                                                                .challengeId),
                                                      ),
                                                    ],
                                                  );
                                                }));
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
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerFloat,
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
    required this.canChoose,
    required this.challengeId,
  }) : super(key: key);
  final List<QueryDocumentSnapshot> images;
  final bool canChoose;
  final String challengeId;

  @override
  State<ChallengeCalendar> createState() => _ChallengeCalendarState();
}

class _ChallengeCalendarState extends State<ChallengeCalendar> {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  final _eventsList = {};
  bool isConfirm = false;
  bool isLike = false;
  int likesCount = 0;
  List _getEventsForDay(
    DateTime day,
  ) {
    widget.images.forEach((image) {
      final date = DateTime.fromMillisecondsSinceEpoch(image.get('date'));
      _eventsList[date] ??= [];
      _eventsList[date].add(image);
    });

    return _eventsList.entries
        .where((e) => isSameDay(e.key, day))
        .map((e) => e.value)
        .toList();
  }

  void confirmChallengeImage(
      String imageUploader, String imageId, bool isConfirm) async {
    final imagesCollection = FirebaseFirestore.instance
        .collection("challenges")
        .doc(widget.challengeId)
        .collection("challengers")
        .doc(imageUploader)
        .collection(imageUploader)
        .doc(imageId);

    await imagesCollection
        .set({'isConfirm': isConfirm}, SetOptions(merge: true));
  }

  void addLike(String imageUploader, String imageId, bool isLike) async {
    final imagesCollection = FirebaseFirestore.instance
        .collection("challenges")
        .doc(widget.challengeId)
        .collection("challengers")
        .doc(imageUploader)
        .collection(imageUploader)
        .doc(imageId);

    isLike
        ? imagesCollection.update({
            "likes": FieldValue.arrayUnion([userId])
          })
        : imagesCollection.update({
            "likes": FieldValue.arrayRemove([userId])
          });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40, bottom: 30),
        child: TableCalendar(
          eventLoader: _getEventsForDay,
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              return InkWell(
                onTap: () {
                  final imagesOnSelectedDay = widget.images.where((image) {
                    return isSameDay(
                        DateTime.fromMillisecondsSinceEpoch(image.get('date')),
                        date);
                  }).toList();
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            content: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: SizedBox(
                                width: 100,
                                height: 300,
                                child: PageView.builder(
                                    itemCount: imagesOnSelectedDay.length,
                                    itemBuilder: (context, index) {
                                      final image = imagesOnSelectedDay[index];
                                      final imagesCollection = FirebaseFirestore
                                          .instance
                                          .collection("challenges")
                                          .doc(widget.challengeId)
                                          .collection("challengers")
                                          .doc(image['user'])
                                          .collection(image['user'])
                                          .doc(image.id)
                                          .get()
                                          .then((snapshot) => setState(() {
                                                isConfirm = snapshot
                                                    .data()!['isConfirm'];
                                              }));
                                      final likesCollection = FirebaseFirestore
                                          .instance
                                          .collection("challenges")
                                          .doc(widget.challengeId)
                                          .collection("challengers")
                                          .doc(image['user'])
                                          .collection(image['user'])
                                          .doc(image.id)
                                          .get()
                                          .then((snapshot) => setState(() {
                                                if (snapshot
                                                    .data()!['likes']
                                                    .any((element) =>
                                                        element == userId)) {
                                                  isLike = true;
                                                } else {
                                                  isLike = false;
                                                }
                                              }));
                                      final likesCollection2 = FirebaseFirestore
                                          .instance
                                          .collection("challenges")
                                          .doc(widget.challengeId)
                                          .collection("challengers")
                                          .doc(image['user'])
                                          .collection(image['user'])
                                          .doc(image.id)
                                          .get()
                                          .then((snapshot) => setState(() {
                                                likesCount = snapshot
                                                    .data()!['likes']
                                                    .length;
                                              }));

                                      final tsdate = image['date'];
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            DateTime
                                                        .fromMillisecondsSinceEpoch(
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
                                                ':' +
                                                DateTime.fromMillisecondsSinceEpoch(
                                                        tsdate)
                                                    .minute
                                                    .toString() +
                                                ' ' +
                                                DateTime.fromMillisecondsSinceEpoch(
                                                        tsdate)
                                                    .second
                                                    .toString() +
                                                's',
                                            style: TextStyle(
                                                fontFamily: MyfontsFamily
                                                    .pretendardSemiBold,
                                                color: Color(0xff5F50B1)),
                                          ),
                                          SizedBox(
                                            height: 40,
                                          ),
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                  image['image'])),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      isLike = !isLike;
                                                    });
                                                    addLike(image['user'],
                                                        image.id, isLike);
                                                  },
                                                  icon: isLike
                                                      ? Icon(
                                                          CupertinoIcons
                                                              .heart_fill,
                                                          color:
                                                              Color(0xff5F50B1),
                                                        )
                                                      : Icon(
                                                          CupertinoIcons.heart,
                                                          color:
                                                              Color(0xff5F50B1),
                                                        )),
                                              Text(
                                                likesCount == 0
                                                    ? '$likesCount like'
                                                    : '$likesCount likes',
                                                style: TextStyle(
                                                    fontFamily: MyfontsFamily
                                                        .pretendardMedium,
                                                    color: Color(0xff5F50B1),
                                                    fontSize: 14),
                                              ),
                                              Spacer(),
                                              widget.canChoose
                                                  ? TextButton.icon(
                                                      style: TextButton.styleFrom(
                                                          backgroundColor:
                                                              isConfirm
                                                                  ? Color(
                                                                      0xff5F50B1)
                                                                  : Colors
                                                                      .white,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          24),
                                                              side: BorderSide(
                                                                  width: 1,
                                                                  color: isConfirm
                                                                      ? Colors
                                                                          .grey
                                                                      : Color(
                                                                          0xff5F50B1)))),
                                                      onPressed: () {
                                                        setState(() {
                                                          isConfirm =
                                                              !isConfirm;
                                                        });
                                                        confirmChallengeImage(
                                                            image['user'],
                                                            image.id,
                                                            isConfirm);
                                                      },
                                                      label: isConfirm
                                                          ? Text(
                                                              'Confirmed!',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      MyfontsFamily
                                                                          .pretendardMedium,
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          : Text('Confirm!',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      MyfontsFamily
                                                                          .pretendardMedium,
                                                                  color: Color(
                                                                      0xff5F50B1))),
                                                      icon: isConfirm
                                                          ? Icon(
                                                              CupertinoIcons
                                                                  .check_mark_circled_solid,
                                                              size: 16,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : Icon(
                                                              CupertinoIcons
                                                                  .check_mark_circled,
                                                              size: 16,
                                                              color: Color(
                                                                  0xff5F50B1),
                                                            ),
                                                    )
                                                  : (isConfirm
                                                      ? Text('Confirmed!',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  MyfontsFamily
                                                                      .pretendardMedium,
                                                              color: Color(
                                                                  0xff5F50B1)))
                                                      : Text('Not Confirmed',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  MyfontsFamily
                                                                      .pretendardMedium,
                                                              color: Color(
                                                                  0xff5F50B1)))),
                                            ],
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                            ),
                          );
                        });
                      });
                },
                child: Wrap(
                  children: List.generate(events.length, (index) {
                    return Icon(
                      CupertinoIcons.sparkles,
                      size: 14,
                      color: Color(0xff5F50B1),
                    );
                  }),
                ),
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
      ),
    );
  }
}
