import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      body: Stack(children: [
        Container(
            height: 390,
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/imagepage_bg.png'),
            ))),
        Container(
            margin: EdgeInsets.only(top: 100),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.only(topRight: Radius.circular(80)))),
        Padding(
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
                          FirebaseFirestore.instance
                              .collection("missions")
                              .add({
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
      ]),
    );
  }
}
