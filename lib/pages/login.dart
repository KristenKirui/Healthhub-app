

import 'dart:convert';


import 'package:assessment_one/pages/layout.dart';

import 'package:assessment_one/pages/register.dart';

import 'package:flutter/gestures.dart';
//import 'package:assessment_one/providers/dio_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//import 'package:http/http.dart';
//import 'package:http/http.dart';
//import 'package:http/http.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({
    super.key,
    required this.onTap,
  });
  final storage = const FlutterSecureStorage();

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isHidden = true;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final String username = usernameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;

    final response = await loginUser(username, email, password);

    Navigator.of(context).pop();

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];

      await widget.storage.write(key: 'token', value: token);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xff121212),
          // title:
          //     Lottie.asset('assets/images/Tick.json', height: 100, width: 100),
          content: const Text(
            'Logged In Successfully!',
            style: TextStyle(color: Color.fromARGB(255, 3, 227, 252)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LayoutPage()),
                );
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Color.fromARGB(255, 1, 244, 211)),
              ),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          // title: Lottie.asset('assets/images/Failed.json',
          //     height: 100, width: 100),
          content: const Text('Error:Bad credentials!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage(
                            onTap: () {},
                          )),
                );
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Color.fromARGB(255, 6, 243, 235)),
              ),
            ),
          ],
        ),
      );
    }
  }

  Future<http.Response> loginUser(
    String username,
    String email,
    String password,
  ) async {
    const String apiUrl = 'http://127.0.0.1:8000/api/login';

    final Map<String, String> data = {
      'user_name': username,
      'email': email,
      'password': password,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    return response;
  }

  @override
 Widget build(BuildContext context) {
  return Scaffold(
    body: SingleChildScrollView(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color.fromARGB(255, 4, 245, 205),
              Color.fromARGB(255, 3, 253, 228),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Text(
                    "Login",
                    style: TextStyle(
                      color: Color.fromARGB(255, 32, 31, 31),
                      fontSize: 43,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: Color.fromARGB(255, 14, 14, 14),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(255, 58, 22, 23),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey),
                              ),
                            ),
                            child: TextFormField(
                              controller: usernameController,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.person),
                                hintText: ' Username',
                                labelText: 'Username',
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey),
                              ),
                            ),
                            child: TextFormField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.email),
                                hintText: ' email',
                                labelText: 'Email',
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey),
                              ),
                            ),
                            child: TextFormField(
                              onTap: _togglePasswordView,
                              keyboardType: TextInputType.visiblePassword,
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.lock_outline),
                                hintText: ' password',
                                labelText: 'Password',
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color.fromARGB(255, 9, 238, 215),
                          ),
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          login();
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 8, 8, 8),
                          ),
                        ),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          const TextSpan(
                            text: 'Dont you have an account?',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: ' Register',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>  Register(onTap:(){} ,),
                                  ),
                                );
                              },
                            style: const TextStyle(
                              color: Color.fromARGB(255, 10, 232, 213),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}

// class _storeToken {
//   _storeToken(token);
// }
