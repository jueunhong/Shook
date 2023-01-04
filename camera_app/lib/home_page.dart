import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'mission_page.dart';
import 'my_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<List<Mission>> getMissionsFromFirestore() {
    final missionsCollection =
        FirebaseFirestore.instance.collection("missions").snapshots();
    return missionsCollection.map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Mission(
            missionId: doc.id,
            missionTitle: data['title'],
            missionDesc: data['desc'],
            missionUploader: data['user']);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: 390,
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/homepage_bg.png'),
              ))),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 120),
              Text(
                "CATCH",
                style: TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                height: 360,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.only(top: 70, right: 35, left: 35),
                child: StreamBuilder(
                    stream: getMissionsFromFirestore(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      }
                      if (!snapshot.hasData) {
                        return Center(child: Text("😭 No missions yet"));
                      }
                      final missions = snapshot.data;
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Text(
                                  'Missions',
                                  style: TextStyle(
                                      color: Color(0xff7B68E6),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateMissionPage()));
                                    },
                                    tooltip: "add Mission!",
                                    icon: Image(
                                        image: AssetImage(
                                            'assets/icons/create_mission.png')))
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.separated(
                                itemCount: missions!.length,
                                separatorBuilder: (context, index) => Divider(),
                                itemBuilder: (context, index) {
                                  final mission = missions[index];
                                  return ListTile(
                                    title: Text(mission.missionTitle),
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
                          ),
                        ],
                      );
                    }),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Color(0xff7E70E1),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                icon: Image(image: AssetImage('assets/icons/MissionList.png')),
              ),
              label: 'List',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                icon: Image(image: AssetImage('assets/icons/Home.png')),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                icon: Image(image: AssetImage('assets/icons/Ranking.png')),
              ),
              label: 'Ranking',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyPage()));
                },
                icon: Image(image: AssetImage('assets/icons/MyPage.png')),
              ),
              label: 'MyPage',
            ),
          ]),
    );
  }
}

class CreateMissionPage extends StatefulWidget {
  const CreateMissionPage({super.key});

  @override
  State<CreateMissionPage> createState() => _CreateMissionPageState();
}

class _CreateMissionPageState extends State<CreateMissionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Mission"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 16),
                Text(
                  'Describe picture you want🔎',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    hintText: 'Please enter a title',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _descController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Please enter a description',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        FirebaseFirestore.instance.collection("missions").add({
                          'title': _titleController.text,
                          'desc': _descController.text,
                          'user': userId,
                        });
                      }
                      Navigator.pop(context);
                    },
                    child: Text("Post"),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class Mission {
  final String missionId;
  final String missionTitle;
  final String missionDesc;
  final String missionUploader;

  Mission({
    required this.missionId,
    required this.missionTitle,
    required this.missionDesc,
    required this.missionUploader,
  });
}
