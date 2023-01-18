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

class ChallengePage extends StatefulWidget {
  const ChallengePage({Key? key, required this.challenge}) : super(key: key);

  final Challenge challenge;

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
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
                  margin: EdgeInsets.only(top: 60),
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
                        height: 90,
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
                        height: 80,
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
                        height: 30,
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
                              return ListView.builder(
                                  itemCount: challengers.length,
                                  itemBuilder: ((context, index) {
                                    final userId = challengers[index].id;
                                    int challengersIndex = index;
                                    final imagesStream = challengers[index];
                                    final userNickname =
                                        imagesStream.get('nickname');
                                    return StreamBuilder<QuerySnapshot>(
                                        stream: imagesStream.reference
                                            .collection(userId)
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

                                          return SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(userNickname),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Color(0xffE2E2E2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: Wrap(
                                                      runSpacing: 5,
                                                      children: List.generate(
                                                        images.length,
                                                        (index) => Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            DetailChallengePage(
                                                                              challengers: challengers,
                                                                              challengersIndex: challengersIndex,
                                                                              imageIndex: index,
                                                                            )));
                                                              },
                                                              child:
                                                                  Image.network(
                                                                images[index].get(
                                                                        'image')
                                                                    as String,
                                                                width: 100,
                                                                height: 92,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                )
                                              ],
                                            ),
                                          );
                                        }));
                                  }));
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
                                            DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        tsdate)
                                                .month
                                                .toString() +
                                            '/' +
                                            DateTime.fromMillisecondsSinceEpoch(
                                                    tsdate)
                                                .day
                                                .toString()),
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
