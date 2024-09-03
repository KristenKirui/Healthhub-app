import 'package:flutter/material.dart';
import 'package:assessment_one/pages/components/appointment_service.dart';

class AppointmentListPage extends StatefulWidget {
  const AppointmentListPage({super.key});

  @override
  _AppointmentListPageState createState() => _AppointmentListPageState();
}

class _AppointmentListPageState extends State<AppointmentListPage> {
  final AppointmentService _appointmentService = AppointmentService();
  late Future<List<dynamic>> futureAppointments;

  @override
  void initState() {
    super.initState();
    futureAppointments = _appointmentService.fetchAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureAppointments,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title:
                      Text('Doctor: ${snapshot.data![index]['doctor_name']}'),
                  subtitle: Text(
                      'Date: ${snapshot.data![index]['date']} Time: ${snapshot.data![index]['time']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await _appointmentService.deleteAppointment(snapshot.data![index]['id']);
                      setState(() {
                        futureAppointments =_appointmentService. fetchAppointments();
                      });
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
