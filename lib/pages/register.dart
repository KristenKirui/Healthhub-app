
import 'dart:convert';
import 'package:assessment_one/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  final void Function()? onTap;

  const Register({
    super.key,
    required this.onTap,
  });

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController phonenumberController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  void register() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final String name = nameController.text;
    final String username = usernameController.text;
    final String email = emailController.text;
    final String phonenumber = phonenumberController.text;
    final String password = passwordController.text;
    final String passwordConfirmation = confirmPasswordController.text;

    final response = await registerUser(
        name, username, email,  phonenumber,password, passwordConfirmation);

    // Hide the progress indicator
    Navigator.of(context).pop();

    if (response.statusCode == 201) {
      // Registration successful

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          // title:
          //     Lottie.asset('assets/images/Tick.json', height: 100, width: 100),
          content: const Text('Registered Successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage(
                            onTap: () {},
                          )), //the import of your screen
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Registration failed
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          // title: Lottie.asset('assets/images/Failed.json',
          //     height: 100, width: 100),
          content: Text('Error: ${response.body}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<http.Response> registerUser(
    String name,
    String username,
    String email,
    String phonenumber,
    String password,
    String passwordConfirmation,
  ) async {
    const String apiUrl =
        'http://127.0.0.1:8000/api/register'; // Replace with your Laravel API endpoint

    final Map<String, String> data = {
      'name': name,
      'user_name': username,
      'email': email,
      'phone_number': phonenumber,
      'password': password,
      'password_confirmation': passwordConfirmation
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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 10, 232, 213),
              //  borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(50),
              //    topRight: Radius.circular(50),
              // )
              borderRadius: BorderRadius.circular(15.0),
            ),
            height: height * 0.30,
            width: width,
            child: Title(
                color: Colors.black,
                child: const Padding(
                  padding: EdgeInsets.all(55),
                  child: Text(
                    "Welcome to the Register Page",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                  ),
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'What do people call you?',
                  labelText: ' Full Name ',
                ),
                onSaved: (String? value) {},
                validator: (String? value) {
                  return (value != null && value.contains('@'))
                      ? 'Do not use the @ char.'
                      : null;
                },
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  //hintText: 'What do people call you?',
                  labelText: 'UserName ',
                ),
                onSaved: (String? value) {},
                validator: (String? value) {
                  return (value != null && value.contains('@'))
                      ? 'Do not use the @ char.'
                      : null;
                },
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Enter your email',
                  labelText: ' Email ',
                ),
                onSaved: (String? value) {},
                validator: (String? value) {
                  return (value != null && !value.contains('@'))
                      ? 'Do  use the @ char.'
                      : null;
                },
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: phonenumberController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.phone),
                  hintText: 'Phone Number',
                  labelText: ' Phone number ',
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.password),
                  hintText: 'password',
                  labelText: 'Password',
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.password),
                  hintText: ' confirm password',
                  labelText: 'Confirm password',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FloatingActionButton(
                onPressed: () {
                  register();
                },
                elevation: height * 56,
                backgroundColor: const Color.fromARGB(255, 10, 232, 213),
                child: const Text(
                  "Register",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }
}
