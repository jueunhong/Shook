import 'package:camera_app/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'login_Page.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final userEmail = FirebaseAuth.instance.currentUser?.email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyPage"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(CupertinoIcons.arrow_left),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 30,
            ),
            Icon(
              CupertinoIcons.person_alt_circle,
              size: 50,
            ),
            SizedBox(
              height: 15,
            ),
            Center(child: Text(userEmail.toString())),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                AuthService authService = AuthService();
                authService.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, "login", ((route) => false));
              },
              child: Text("로그아웃"),
            ),
          ],
        ),
      ),
    );
  }
}
