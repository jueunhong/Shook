import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'fonts.dart';

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
      backgroundColor: Color(0xff7E70E1),
      body: Stack(children: [
        Container(
            margin: EdgeInsets.only(top: 120),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.only(topRight: Radius.circular(80)))),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Text(
                          'Create Mission',
                          style: TextStyle(
                              fontSize: 24,
                              fontFamily: MyfontsFamily.pretendardSemiBold,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Text(
                          'Describe the picture you want!',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: MyfontsFamily.pretendardSemiBold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xffD9D9D9),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "TITLE",
                          style: TextStyle(
                            fontFamily: MyfontsFamily.pretendardSemiBold,
                            color: Color(0xff5F50B1),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Please enter a title',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 50,
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
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    TextFormField(
                      controller: _descController,
                      decoration: InputDecoration(
                        hintText: 'Please enter a description',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 200,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(70)),
                          backgroundColor: Color(0xff7E70E1),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            FirebaseFirestore.instance
                                .collection("missions")
                                .add({
                              'title': _titleController.text,
                              'desc': _descController.text,
                              'user': userId,
                              'isCompleted': false,
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          "Post",
                          style: TextStyle(
                              fontFamily: MyfontsFamily.pretendardSemiBold,
                              fontSize: 32),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
        Positioned(
          top: 20,
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

class CreateChallengePage extends StatefulWidget {
  const CreateChallengePage({super.key});

  @override
  State<CreateChallengePage> createState() => _CreateChallengePageState();
}

class _CreateChallengePageState extends State<CreateChallengePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  int? goalNum;

  final userId = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff7E70E1),
      body: Stack(children: [
        Container(
            margin: EdgeInsets.only(top: 120),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.only(topRight: Radius.circular(80)))),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Create Challenge',
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: MyfontsFamily.pretendardSemiBold,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
                Text(
                  'Describe challege you want to accomplish together!',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: MyfontsFamily.pretendardSemiBold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 120,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Color(0xffD9D9D9),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "TITLE",
                                  style: TextStyle(
                                    fontFamily:
                                        MyfontsFamily.pretendardSemiBold,
                                    color: Color(0xff5F50B1),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 14),
                            TextFormField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                hintText: 'Please enter a title',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a title';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 50,
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
                                    fontFamily:
                                        MyfontsFamily.pretendardSemiBold,
                                    color: Color(0xff5F50B1),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 14),
                            TextFormField(
                              controller: _descController,
                              decoration: InputDecoration(
                                hintText: 'Please enter a description',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a description';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 30),
                            Container(
                              decoration: BoxDecoration(
                                  color: Color(0xffD9D9D9),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "Goals",
                                  style: TextStyle(
                                    fontFamily:
                                        MyfontsFamily.pretendardSemiBold,
                                    color: Color(0xff5F50B1),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            CustomFormField(
                                onSaved: (goalNum) => this.goalNum = goalNum,
                                initialValue: null,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select the number of pics';
                                  }

                                  return null;
                                }),
                            SizedBox(
                              height: 60,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(70)),
                                  backgroundColor: Color(0xff7E70E1),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();

                                    FirebaseFirestore.instance
                                        .collection("challenges")
                                        .add({
                                      'title': _titleController.text,
                                      'desc': _descController.text,
                                      'goals': goalNum,
                                      'user': userId,
                                      'isCompleted': false,
                                    });
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text(
                                  "Post",
                                  style: TextStyle(
                                      fontFamily:
                                          MyfontsFamily.pretendardSemiBold,
                                      fontSize: 32),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ]),
            )),
        Positioned(
          top: 20,
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

class CustomFormField extends FormField {
  CustomFormField({
    FormFieldSetter? onSaved,
    FormFieldValidator? validator,
    int? initialValue,
  }) : super(
            validator: validator,
            onSaved: onSaved,
            initialValue: initialValue,
            builder: (FormFieldState state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            side: BorderSide(
                                width: 1.5,
                                color: state.value == 1
                                    ? Color(0xff5F50B1)
                                    : Color(0xffD9D9D9)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            state.didChange(1);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              '1 pic',
                              style: TextStyle(
                                  color: state.value == 1
                                      ? Color(0xff5F50B1)
                                      : Color(0xffD9D9D9)),
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            side: BorderSide(
                                width: 1.5,
                                color: state.value == 3
                                    ? Color(0xff5F50B1)
                                    : Color(0xffD9D9D9)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            state.didChange(3);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              '3 pics',
                              style: TextStyle(
                                  color: state.value == 3
                                      ? Color(0xff5F50B1)
                                      : Color(0xffD9D9D9)),
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            side: BorderSide(
                                width: 1.5,
                                color: state.value == 5
                                    ? Color(0xff5F50B1)
                                    : Color(0xffD9D9D9)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            state.didChange(5);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              '5 pics',
                              style: TextStyle(
                                  color: state.value == 5
                                      ? Color(0xff5F50B1)
                                      : Color(0xffD9D9D9)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  (state.hasError)
                      ? Text(
                          state.errorText!,
                          style:
                              TextStyle(color: Color(0xffD32F2F), fontSize: 12),
                        )
                      : Container()
                ],
              );
            });
}
