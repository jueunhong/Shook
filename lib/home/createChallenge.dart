import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../fonts.dart';

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
  String? duration;

  final userId = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff7E70E1),
      body: Stack(children: [
        Container(
            margin: EdgeInsets.only(top: 100),
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
                      height: 100,
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
                            SizedBox(height: 10),
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
                                    fontFamily:
                                        MyfontsFamily.pretendardSemiBold,
                                    color: Color(0xff5F50B1),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
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
                                  "Duration",
                                  style: TextStyle(
                                    fontFamily:
                                        MyfontsFamily.pretendardSemiBold,
                                    color: Color(0xff5F50B1),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            DurationFormField(
                                onSaved: (duration) => this.duration = duration,
                                initialValue: null,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select the Duration';
                                  }

                                  return null;
                                }),
                            SizedBox(height: 10),
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
                              height: 5,
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
                                      'duration': duration,
                                      'user': userId,
                                      'isCompleted': false,
                                      'participants': [],
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

class DurationFormField extends FormField {
  DurationFormField({
    FormFieldSetter? onSaved,
    FormFieldValidator? validator,
    String? initialValue,
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
                                color: state.value == "daily"
                                    ? Color(0xff5F50B1)
                                    : Color(0xffD9D9D9)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            state.didChange("daily");
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              'daily',
                              style: TextStyle(
                                  color: state.value == "daily"
                                      ? Color(0xff5F50B1)
                                      : Color(0xffD9D9D9)),
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            side: BorderSide(
                                width: 1.5,
                                color: state.value == "weekly"
                                    ? Color(0xff5F50B1)
                                    : Color(0xffD9D9D9)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            state.didChange("weekly");
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              'weekly',
                              style: TextStyle(
                                  color: state.value == 'weekly'
                                      ? Color(0xff5F50B1)
                                      : Color(0xffD9D9D9)),
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            side: BorderSide(
                                width: 1.5,
                                color: state.value == "monthly"
                                    ? Color(0xff5F50B1)
                                    : Color(0xffD9D9D9)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            state.didChange("monthly");
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              'monthly',
                              style: TextStyle(
                                  color: state.value == "monthly"
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
