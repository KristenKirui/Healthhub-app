import 'package:assessment_one/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthHelper {
  static const storage = FlutterSecureStorage();

  static Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  static Future<void> checkAuthentication(BuildContext context) async {
    final token = await getToken();
    
    if (token == null) {
      // Token not found, redirect to the login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(onTap: () {})),
      );
    }
  }

  static Future<void> logout(BuildContext context) async {
    final token = await getToken();

    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/logout'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          // Logout successful
          await storage.delete(key: 'token');
          print('Logged out successfully');

          // Navigate to login screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage(onTap: () {})),
          );
        } else {
          // Handle error
          print('Logout failed: ${response.body}');
        }
      } catch (e) {
        print('Error during logout: $e');
      }
    } else {
      // No token found, consider the user already logged out
      print('No token found, user is already logged out');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(onTap: () {})),
      );
    }
  }
}