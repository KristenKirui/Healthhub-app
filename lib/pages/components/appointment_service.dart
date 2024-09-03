import 'dart:convert';
import 'package:http/http.dart' as http;

class AppointmentService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  Future<void> createAppointment(Map<String, dynamic> appointmentData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/appointment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(appointmentData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create appointment');
    }
  }

  Future<List<dynamic>> fetchAppointments() async {
    final response = await http.get(Uri.parse('$baseUrl/appointment'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  Future<void> updateAppointment(int id, Map<String, dynamic> updatedData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/appointment/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update appointment');
    }
  }

  Future<void> deleteAppointment(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/appointment/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete appointment');
    }
  }
}