  import 'package:flutter/material.dart';

  class AppointmentPage extends StatefulWidget {
    const AppointmentPage({super.key});

    @override
    State<AppointmentPage> createState() => _AppointmentPageState();
  }

  enum FilterStatus { upcoming, complete, cancel }

  class _AppointmentPageState extends State<AppointmentPage> {
    FilterStatus status = FilterStatus.upcoming;
    Alignment _alignment = Alignment.centerLeft;
    List<dynamic> schedules = [
      {
        "doctor_name": "Richard Tan",
        "doctor_profile": "assests/images/doctor.png",
        "category": "Dental",
        "status": FilterStatus.upcoming,
      },
      {
        "doctor_name": "Maxwell Tan",
        "doctor_profile": "assests/images/doctor.png",
        "category": "Dental",
        "status": FilterStatus.complete,
      },
      {
        "doctor_name": "Richard Omondi",
        "doctor_profile": "assests/images/doctor.png",
        "category": "Cardiology",
        "status": FilterStatus.cancel,
      },
      {
        "doctor_name": " Sarah Tan",
        "doctor_profile": "assests/images/doctor.png",
        "category": "Gynecology",
        "status": FilterStatus.upcoming,
      },
    ];
    @override
    Widget build(BuildContext context) {
      List<dynamic> filterSchedules = schedules.where((var schedule) {
        // switch (schedule['status']) {
        //   case 'upcoming':
        //     schedule['status'] = FilterStatus.upcoming;
        //   case 'complete':
        //     schedule['status'] = FilterStatus.complete;
        //   case 'cancel':
        //     schedule['status'] = FilterStatus.cancel;
        // }
        return schedule['status'] == status;
      }).toList();

      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 10, 232, 213),
          title: const Text(
            "Appointment Schedule",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Text("Appointment Schedule",
                // textAlign: TextAlign.center,
                // style: TextStyle(
                //   fontSize: 10,
                //   fontWeight: FontWeight.bold
                // ),),
                // SizedBox(
                //   height: 10,
                // ),
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (FilterStatus filterStatus in FilterStatus.values)
                            Expanded(
                                child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (filterStatus ==
                                            FilterStatus.upcoming) {
                                          status = FilterStatus.upcoming;
                                          _alignment = Alignment.centerLeft;
                                        } else if (filterStatus ==
                                            FilterStatus.complete) {
                                          status = FilterStatus.complete;
                                          _alignment = Alignment.center;
                                        } else if (filterStatus ==
                                            FilterStatus.cancel) {
                                          status = FilterStatus.cancel;
                                          _alignment = Alignment.centerRight;
                                        }
                                      });
                                    },
                                    child: Center(
                                      child: Text(filterStatus.name),
                                    ))),
                          AnimatedAlign(
                            alignment: _alignment,
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              width: 100,
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 10, 232, 213),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  status.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: filterSchedules.length,
                        itemBuilder: ((context, index) {
                          var schedule = filterSchedules[index];
                          bool isLastElement =
                              filterSchedules.length + 1 == index;
                          return Card(
                            shape: RoundedRectangleBorder(
                              side:const BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            margin: !isLastElement
                            ?const EdgeInsets.only(bottom: 20)
                            :EdgeInsets.zero,
                            child: Padding(padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: AssetImage(schedule['doctor_profile']),
                                    ),
                                   const  SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                           schedule["doctor_name"],
                                          style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                                    ),
                                     ),
                                 const SizedBox(height:5,),
                                       Text(
                                            schedule["category"],
                                            style: const TextStyle(
                                             color: Colors.grey,
                                           fontWeight: FontWeight.w600,
                                                                        ),
                                                                      ),
                                      ],
                                    ),
                                  ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                const  ScheduleCard(),
                                 const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: OutlinedButton(onPressed: () {}, 
                                      child:const Text('Cancel',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 10, 232, 213) 
                                        ),)
                                         )
                                         ),
                                         const SizedBox( width: 20,),
                                         Expanded(child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor:const Color.fromARGB(255, 10, 232, 213) 
                                          ),
                                          onPressed: () {}, 
                                      child:const Text('Reschedule',
                                      style: TextStyle(
                                        color: Colors.white
                                        ),)
                                         )
                                         ),
                                    ],
                                  )
                              ],
                              ),),
                          );
                          
                        })))
              ],
            ),
          ),
        ),
      );
    }
  }

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 105, 104, 104),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(
            Icons.calendar_today,
            color: Color.fromARGB(255, 10, 232, 213),
            size: 13,
          ),
          SizedBox(
            width: 6,
          ),
          Text(
            "Monday 12/05/2024",
            style: TextStyle(color: Color.fromARGB(255, 10, 232, 213),),
          ),
          SizedBox(
            width: 16,
          ),
          Icon(
            Icons.alarm,
            color:  Color.fromARGB(255, 10, 232, 213),
            size: 13,
          ),
          Flexible(
              child: Text(
            "2.00pm",
            style: TextStyle(color: Color.fromARGB(255, 10, 232, 213),),
          ))
        ],
      ),
    );
  }
}
