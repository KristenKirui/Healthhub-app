import 'dart:async';
import 'package:assessment_one/pages/login.dart';
//import 'package:assessment_one/pages/register.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) =>  LoginPage(onTap: () {},)));
    });
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 10, 232, 213),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Image.asset(
              'assests/images/favicon.png',
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
         
        ),
      ),
    );
  }
}
