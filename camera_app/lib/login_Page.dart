import 'package:camera_app/auth_service.dart';
import 'package:camera_app/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isSignUp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("로그인"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  isSignUp ? "회원가입해주세요 📸" : "로그인해주세요 📸",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            //이메일
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "이메일을 입력해주세요.",
              ),
            ),
            SizedBox(
              height: 13,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "비밀번호를 입력해주세요.",
              ),
            ),
            SizedBox(
              height: 30,
            ),
            isSignUp
                ? SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        AuthService authService = AuthService();
                        authService.signUp(
                            email: emailController.text,
                            password: passwordController.text,
                            onSuccess: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("회원가입 성공"),
                              ));
                            },
                            onError: (err) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(err)));
                            });
                      },
                      child: Text(
                        "회원가입",
                        style: TextStyle(fontSize: 21),
                      ),
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        AuthService authService = AuthService();
                        authService.signIn(
                            email: emailController.text,
                            password: passwordController.text,
                            onSuccess: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("로그인 성공"),
                              ));
                              //homepage로 이동
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TakePicture()));
                            },
                            onError: (err) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(err)));
                            });
                      },
                      child: Text(
                        "로그인",
                        style: TextStyle(fontSize: 21),
                      ),
                    ),
                  ),
            TextButton(
              child: Text(isSignUp ? "로그인 하러가기" : "회원가입 하러가기"),
              onPressed: () {
                setState(() {
                  isSignUp = !isSignUp;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
