import 'package:camera_app/auth_service.dart';
import 'package:camera_app/fonts.dart';
import 'package:camera_app/take_picture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isSignUp = false;
  void changeSignUp() {
    setState(() {
      isSignUp = !isSignUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (isSignUp
        ? SignUp(
            changeSignUp: changeSignUp,
          )
        : SignIn(
            changeSignUp: changeSignUp,
          ));
  }
}

class SignIn extends StatefulWidget {
  const SignIn({Key? key, required this.changeSignUp}) : super(key: key);

  final Function() changeSignUp;
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 390,
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/signin_bg.png'),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 120,
                    ),
                    Text('Sign In',
                        style: TextStyle(
                          fontFamily: MyfontsFamily.pretendardExtrabold,
                          color: Color(0xff6D71E6),
                          fontSize: 32,
                        )),
                    SizedBox(
                      height: 40,
                    ),
                    Text('Email :',
                        style: TextStyle(
                          fontFamily: MyfontsFamily.pretendardSemiBold,
                          color: Color(0xff6D71E6),
                          fontSize: 16,
                        )),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Color(0xffECECEC),
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Password :',
                        style: TextStyle(
                          fontFamily: MyfontsFamily.pretendardSemiBold,
                          color: Color(0xff6D71E6),
                          fontSize: 16,
                        )),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Color(0xffECECEC),
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xff6D71E6),
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff6D71E6),
                          shape: StadiumBorder(),
                        ),
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
                                        builder: (context) => HomePage()));
                              },
                              onError: (err) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text(err)));
                              });
                        },
                        child: Text(
                          "Sign In",
                          style: TextStyle(fontSize: 21),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't you have a account?",
                          style: TextStyle(
                              color: Color(0xffAEA6DC),
                              fontFamily: MyfontsFamily.pretendardMedium,
                              fontSize: 14),
                        ),
                        TextButton(
                            onPressed: widget.changeSignUp,
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontFamily: MyfontsFamily.pretendardSemiBold,
                                  color: Color(0xff6468E7),
                                  fontSize: 15),
                            ))
                      ],
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({Key? key, required this.changeSignUp}) : super(key: key);

  final Function() changeSignUp;
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 390,
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/signup_bg.png'),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 90,
                    ),
                    Text('Sign Up',
                        style: TextStyle(
                          fontFamily: MyfontsFamily.pretendardExtrabold,
                          color: Color(0xff6D71E6),
                          fontSize: 32,
                        )),
                    SizedBox(
                      height: 40,
                    ),
                    Text('Your ID :',
                        style: TextStyle(
                          fontFamily: MyfontsFamily.pretendardSemiBold,
                          color: Color(0xff6D71E6),
                          fontSize: 16,
                        )),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Color(0xffECECEC),
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: TextField(
                        controller: idController,
                        obscureText: true,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Email :',
                        style: TextStyle(
                          fontFamily: MyfontsFamily.pretendardSemiBold,
                          color: Color(0xff6D71E6),
                          fontSize: 16,
                        )),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Color(0xffECECEC),
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Password :',
                        style: TextStyle(
                          fontFamily: MyfontsFamily.pretendardSemiBold,
                          color: Color(0xff6D71E6),
                          fontSize: 16,
                        )),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Color(0xffECECEC),
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xff6D71E6),
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff6D71E6),
                          shape: StadiumBorder(),
                        ),
                        onPressed: () {
                          AuthService authService = AuthService();
                          authService.signUp(
                              id: idController.text,
                              email: emailController.text,
                              password: passwordController.text,
                              onSuccess: () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("회원가입 성공"),
                                ));
                                widget.changeSignUp();
                              },
                              onError: (err) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text(err)));
                              });
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 21),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Remember your account?",
                          style: TextStyle(
                              color: Color(0xffAEA6DC),
                              fontFamily: MyfontsFamily.pretendardMedium,
                              fontSize: 14),
                        ),
                        TextButton(
                            onPressed: widget.changeSignUp,
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontFamily: MyfontsFamily.pretendardSemiBold,
                                  color: Color(0xff6468E7),
                                  fontSize: 15),
                            ))
                      ],
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
