import 'package:camera_app/login/auth_service.dart';
import 'package:camera_app/home/home_page.dart';
import 'package:camera_app/login/login_page.dart';
import 'package:camera_app/notification_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mypage/my_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(NotificationController(), permanent: true);
  Get.find<NotificationController>().initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthService>().currentUser();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        "login": (BuildContext context) => LoginPage(),
        "homepage": (BuildContext context) => HomePage(),
        "mypage": (BuildContext context) => MyPage(),
      },
      home: user == null ? LoginPage() : HomePage(),
    );
  }
}
