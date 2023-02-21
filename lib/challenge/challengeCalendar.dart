import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../fonts.dart';
import 'package:table_calendar/table_calendar.dart';

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

    final challengeUploaderDoc =
        FirebaseFirestore.instance.collection("users").doc(userId);
    final imageUploaderDoc =
        FirebaseFirestore.instance.collection("users").doc(imageUploader);
    if (isConfirm) {
      await challengeUploaderDoc
          .set({'points': FieldValue.increment(5)}, SetOptions(merge: true));
      await imageUploaderDoc
          .set({'points': FieldValue.increment(10)}, SetOptions(merge: true));
    } else {
      await challengeUploaderDoc
          .set({'points': FieldValue.increment(-5)}, SetOptions(merge: true));
      await imageUploaderDoc
          .set({'points': FieldValue.increment(-10)}, SetOptions(merge: true));
    }
  }

  void addLike(String imageUploader, String imageId, bool isLike) async {
    final imagesCollection = FirebaseFirestore.instance
        .collection("challenges")
        .doc(widget.challengeId)
        .collection("challengers")
        .doc(imageUploader)
        .collection(imageUploader)
        .doc(imageId);
    final userDoc = FirebaseFirestore.instance.collection("users").doc(userId);

    if (isLike) {
      await imagesCollection.update({
        "likes": FieldValue.arrayUnion([userId])
      });
      await userDoc
          .set({'points': FieldValue.increment(5)}, SetOptions(merge: true));
    } else {
      await imagesCollection.update({
        "likes": FieldValue.arrayRemove([userId])
      });
      await userDoc
          .set({'points': FieldValue.increment(-5)}, SetOptions(merge: true));
    }
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
                                                likesCount <= 1
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
