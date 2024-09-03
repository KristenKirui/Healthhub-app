import 'package:assessment_one/pages/booked.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:assessment_one/pages/components/appointment_service.dart';

class BookingPage extends StatefulWidget {
  final int userId;
  final int doctorId;
  final int hospitalId;
  const BookingPage({
    super.key,
    required this.userId,
    required this.doctorId,
    required this.hospitalId,
  });

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
 final AppointmentService _appointmentService = AppointmentService();
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;

  Future<void> createAppointment() async {
  try {
    await _appointmentService.createAppointment({
      'users_id': widget.userId,
      'doctors_id': widget.doctorId,
      'hospitals_id': widget.hospitalId,
      'date': _currentDay.toString().split(' ')[0],
      'time': '${_currentIndex! + 9}:00',
      'status': 'pending',
    });
    
    // Navigate to AppointmentBooked page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const AppointmentBooked()),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to create appointment: $e')),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 10, 232, 213),
        title: const Text(
          " Appointment Details",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                _tableCalendar(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                  child: Center(
                    child: Text(
                      'Select Consultation Time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                      // _timeSelected = true;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _currentIndex == index
                            ? Colors.white
                            : Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      color: _currentIndex == index
                          ? const Color.fromARGB(255, 10, 232, 213)
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 9}:00 ${index + 9 > 11 ? "PM" : "AM"}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _currentIndex == index ? Colors.white : null,
                      ),
                    ),
                  ),
                );
              },
              childCount: 8,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, childAspectRatio: 1.5),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 10, 232, 213),
                  foregroundColor: Colors.white,
                ),
                onPressed: (_currentIndex != null) ? createAppointment : null,
                child: const Text(
                  "Make Your Appointment Here",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableCalendar() {
    return TableCalendar(
      focusedDay: _focusDay,
      firstDay: DateTime.now(),
      lastDay: DateTime(2024, 12, 31),
      calendarFormat: _format,
      currentDay: _currentDay,
      rowHeight: 48,
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
            color: Color.fromARGB(255, 10, 232, 213), shape: BoxShape.circle),
      ),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      onFormatChanged: (format) {
        setState(() {
          _format = format;
        });
      },
      onDaySelected: ((selectedDay, focusedDay) {
        setState(() {
          _currentDay = selectedDay;
          _focusDay = focusedDay;
          //_dateSelected = true;

          //check if weekend is selected
          if (selectedDay.weekday == 6 || selectedDay.weekday == 7) {
            // _isWeekend = true;
            // _timeSelected = false;
            _currentIndex = null;
          } else {
            //_isWeekend = false;
          }
        });
      }),
    );
  }
}
