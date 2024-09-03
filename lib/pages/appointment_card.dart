import 'package:flutter/material.dart';

class AppointmentCard extends StatefulWidget {
  const AppointmentCard({super.key});

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 10, 232, 213),
          borderRadius: BorderRadius.circular(15),
        ),
        child:  Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
               const Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assests/images/doctor.png'),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Dr Fred Omondi",
                            style: TextStyle(color: Colors.black)),
                        SizedBox(
                          height: 3,
                        ),
                      Text("Dental", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              const  ScheduleCard(),
               const  SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {},)),
                            const SizedBox(width: 20,),
                            Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text(
                              'Completed',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {},))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 13,
          ),
          SizedBox(
            width: 6,
          ),
          Text(
            "Monday 12/05/2024",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 16,
          ),
          Icon(
            Icons.alarm,
            color: Colors.white,
            size: 13,
          ),
          Flexible(
              child: Text(
            "2.00pm",
            style: TextStyle(color: Colors.white),
          ))
        ],
      ),
    );
  }
}
