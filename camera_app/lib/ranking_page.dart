import 'package:camera_app/fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'missiongallery_page.dart';
import 'my_page.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  Stream<List<Users>> getUsersRanking() {
    final userCollection =
        FirebaseFirestore.instance.collection('users').snapshots();
    return userCollection.map((snapshot) {
      return snapshot.docs.map((doc) {
        final userNickname = doc.data()['nickname'] as String;
        final userPoints = doc.data()['points'] as int;
        return Users(points: userPoints, nickname: userNickname);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: 152,
              width: double.infinity,
              child: Align(
                alignment: Alignment.center,
                child: Text('RANKING',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontFamily: MyfontsFamily.pretendardExtrabold,
                    )),
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/rankingpage_bg.png'),
              ))),
          Padding(
            padding: const EdgeInsets.only(top: 160, left: 16, right: 16),
            child: StreamBuilder(
              stream: getUsersRanking(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return Text('Loading...');
                }
                final users = snapshot.data;
                users!.sort((a, b) => (a.points != b.points)
                    ? b.points - a.points
                    : a.nickname.compareTo(b.nickname));
                final rankedUsers = <RankedUsers>[];
                int rank = 0;
                int previousPoints = 0;
                for (var user in users) {
                  if (user.points != previousPoints) {
                    rank++;
                  }

                  rankedUsers.add(RankedUsers(
                      points: user.points,
                      nickname: user.nickname,
                      rank: rank));
                  previousPoints = user.points;
                }
                return ListView.builder(
                  itemCount: rankedUsers.length,
                  itemBuilder: (context, index) {
                    final user = rankedUsers[index];
                    return Card(
                      child: ListTile(
                        leading: Text(
                          '${user.rank}',
                          style: TextStyle(
                              fontFamily: MyfontsFamily.pretendardSemiBold,
                              fontSize: 28,
                              color: Color(0xff7D67E6)),
                        ),
                        // leading: Text('${user.rank}', style: TextStyle(fontFamily: MyfontsFamily.pretendardSemiBold, fontSize: 28, color: Color(0xff)),),
                        title: Text(user.nickname),
                        subtitle: Text('points: ${user.points}'),
                      ),
                    );
                  },
                );
              },
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
        ],
      ),
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

class Users {
  final int points;
  final String nickname;

  Users({
    required this.points,
    required this.nickname,
  });
}

class RankedUsers {
  final int points;
  final String nickname;
  final int rank;

  RankedUsers({
    required this.points,
    required this.nickname,
    required this.rank,
  });
}
