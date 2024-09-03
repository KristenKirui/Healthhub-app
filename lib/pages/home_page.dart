//import 'package:flutter/cupertino.dart';
//import 'package:assessment_one/pages/appointment_card.dart';
//import 'package:assessment_one/auth_helper.dart';
import 'dart:convert';

import 'package:assessment_one/auth_helper.dart';
import 'package:assessment_one/pages/about.dart';
import 'package:assessment_one/pages/appointment_card.dart';
import 'package:assessment_one/pages/doctors.dart';
import 'package:assessment_one/pages/feedback_page.dart';
//import 'package:assessment_one/pages/login.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  final storage = const FlutterSecureStorage();

  Future<void> fetchUserData() async {
    final token = await storage.read(key: 'token');

    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/users'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token', // Provide the access token here
    });
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        // Assuming your API response contains a field called 'name' for username
        username = jsonData['user_name'];
      });
    } else {
      throw Exception('Failed to load user data');
    }
  }

  //final storage = const FlutterSecureStorage();

  // Future<void> logout() async {
  //   final token = await storage.read(key: 'token');

  //   final response = await http.post(
  //     Uri.parse('http://127.0.0.1:8000/api/logout'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     await storage.delete(key: 'token');

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => LoginPage(onTap: (){})),
  //     );
  //   } else {}
  // }
  List<Map<String, dynamic>> hosCat = [
    {"icon": FontAwesomeIcons.userDoctor, "category": "General"},
    {"icon": FontAwesomeIcons.heartPulse, "category": "Cardiology"},
    {"icon": FontAwesomeIcons.lungs, "category": "Respiration"},
    {"icon": FontAwesomeIcons.personPregnant, "category": "Gynecology"},
    {"icon": FontAwesomeIcons.hand, "category": "Dermatology"},
    {"icon": FontAwesomeIcons.teeth, "category": "Dental"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Homepage",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 10, 232, 213),
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 10, 232, 213),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: const Text("Log out",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              onTap: () {
                AuthHelper.logout(context);
              },
            ),
            const Divider(
              height: 40,
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.white),
              title: const Text("About us",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => const AboutPage()),
                );
              },
            ),
            const Divider(
              height: 40,
            ),
            ListTile(
              leading: const Icon(Icons.folder, color: Colors.white),
              title: const Text("Feedback",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => const FeedbackPage()),
                );
              },
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          AssetImage('assests/images/pexels-rdne-6129206.jpg'),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Categories",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                ),
              ),
              // Divider(
              //   height: 6,
              // ),
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List<Widget>.generate(hosCat.length, (index) {
                    return Card(
                      margin: const EdgeInsets.only(right: 15),
                      color: const Color.fromARGB(255, 10, 232, 213),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            FaIcon(
                              hosCat[index]['icon'],
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              hosCat[index]['category'],
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                            //const  AppointmentCard(),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Appointments Today",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const AppointmentCard(),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Top Doctors",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Column(
                  children: List.generate(10, (index) {
                return const DoctorPage();
              }))
            ],
          ),
        )),
      ),
    );
  }
}
