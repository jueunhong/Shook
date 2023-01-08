import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  User? currentUser() {
    // 현재 유저(로그인 되지 않은 경우 null 반환)
    return FirebaseAuth.instance.currentUser;
  }

  void signUp({
    required String id,
    required String email, // 이메일
    required String password, // 비밀번호
    required Function() onSuccess, // 가입 성공시 호출되는 함수
    required Function(String err) onError, // 에러 발생시 호출되는 함수
  }) async {
    // 회원가입
    //이메일 및 비밀번호 입력 여부 확인
    if (email.isEmpty) {
      onError("Please enter your email.");
      return;
    } else if (password.isEmpty) {
      onError("Please enter your password.");
      return;
    } else if (id.isEmpty) {
      onError("Please enter your id.");
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      onSuccess();
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      onError(e.message!);
    } catch (e) {
      onError(e.toString());
    }

    final uid = currentUser()!.uid;
    String nickname = email;
    final userCollection =
        await FirebaseFirestore.instance.collection('users').doc(uid);
    final snapshot = await userCollection.get();
    if (snapshot.exists) {
      nickname = snapshot.data()!['nickname'];
    } else {
      await userCollection.set({'nickname': id}, SetOptions(merge: true));
    }
  }

  void signIn({
    required String email, // 이메일
    required String password, // 비밀번호
    required Function() onSuccess, // 로그인 성공시 호출되는 함수
    required Function(String err) onError, // 에러 발생시 호출되는 함수
  }) async {
    // 로그인
    //이메일 및 비밀번호 입력 여부 확인
    if (email.isEmpty) {
      onError("Please enter your email.");
      return;
    } else if (password.isEmpty) {
      onError("Please enter your password.");
      return;
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      onSuccess();
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      onError(e.message!);
    } catch (e) {
      onError(e.toString());
    }
  }

  void signOut() async {
    // 로그아웃
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
