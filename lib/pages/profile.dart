import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class User {
  final int id;
  String name;
  String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

class _ProfilePageState extends State<ProfilePage> {
  final storage = const FlutterSecureStorage();

  late User _currentUser;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  late String token;
  late String userId;

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  _getToken() async {
    token = await storage.read(key: 'token') ?? '';
    userId = await storage.read(key: 'user_id') ?? '';
    _loadCurrentUser();
  }

  _loadCurrentUser() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/user'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        _currentUser = User.fromJson(json.decode(response.body));
        _nameController.text = _currentUser.name;
        _emailController.text = _currentUser.email;
      });
    }
  }

  _updateProfile() async {
    final String newName = _nameController.text;
    final String newEmail = _emailController.text;

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/user/$userId'),
      headers: {'Authorization': 'Bearer $token'},
      body: json.encode({'name': newName, 'email': newEmail}),
    );

    if (response.statusCode == 200) {
      setState(() {
        _currentUser.name = newName;
        _currentUser.email = newEmail;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  _deleteAccount() async {
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/api/user'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 204) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 5, 252, 232)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff121212),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 1, 252, 252)),
      ),
      body: 
      // ignore: unnecessary_null_comparison
      _currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color:  const Color.fromARGB(255, 4, 235, 215),
                          borderRadius: BorderRadius.circular(25)),
                      padding: const EdgeInsets.all(25.0),
                      child: const Icon(
                        Icons.person,
                        size: 65,
                        color:  Color.fromARGB(255, 19, 19, 19),
                      ),
                    ),
                  const Text(
                    'Name:',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 3, 232, 224)),
                  ),
                   SizedBox(height: 8,
                 child:TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter your name', 
                    labelText: '', 
                    
                  ),
                  
                  obscureText: false, 
                  controller: _nameController, 
                 //prefixIcon: null, 
                  //suffixIcon: null
                  ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Email:',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 17, 232, 217)),
                  ),
                  SizedBox(height: 16,
               child:  TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter your email', 
                  labelText: '', 
                ),
                  
                  obscureText: false, 
                  controller: _emailController, 
                  //prefixIcon: null, 
                  //suffixIcon: null
                  ),),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            const Color.fromARGB(255, 8, 246, 246)),
                      ),
                      onPressed: _updateProfile,
                      child: const Text(
                        'Update Profile',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff121212)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: const Color(0xff121212),
                              title: const Text(
                                'Delete Account',
                                style: TextStyle(color: Color.fromARGB(255, 10, 228, 232)),
                              ),
                              content: const Text(
                                'Are you sure you want to delete your account?',
                                style: TextStyle(color: Color.fromARGB(255, 7, 224, 240)),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Color.fromARGB(255, 2, 229, 245)),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _deleteAccount();
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Color.fromARGB(255, 5, 227, 243)),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text(
                        'Delete Account',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 5, 223, 243)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}