import 'package:assessment_one/pages/doctor_details.dart';
import 'package:flutter/material.dart';

class DoctorPage extends StatelessWidget {
  const DoctorPage({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 150,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: 55,
                child:
                    Image.asset('assests/images/doctor.png', fit: BoxFit.fill),
              ),
              const Flexible(
                  child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Dr Wilson Fabian",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Dental",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 20,
                        ),
                        Text("4.5"),
                        Spacer(
                          flex: 1,
                        ),
                        Text("Reviews"),
                        Spacer(
                          flex: 1,
                        ),
                        Text("120")
                      ],
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
        onTap: () {
           Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  const DoctorDetails(doctorId: 2), ),
                          );
        },
      ),
    );
  }
}
