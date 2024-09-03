import 'dart:convert';

import 'package:assessment_one/pages/booking_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  Future<List<Map<String, dynamic>>> getAllDoctorDetails() async {
    final response = await http.get(Uri.parse('$baseUrl/detail'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load doctor details');
    }
  }

  Future<Map<String, dynamic>> getDoctorDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/detail/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load doctor detail');
    }
  }

  Future<void> createDoctorDetail(Map<String, dynamic> detail) async {
    final response = await http.post(
      Uri.parse('$baseUrl/detail'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(detail),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create detail');
    }
  }

  Future<void> updateDoctorDetail(int id, Map<String, dynamic> detail) async {
    final response = await http.post(
      Uri.parse('$baseUrl/detail/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(detail),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update detail');
    }
  }

  Future<void> deleteDoctorDetail(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/detail/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete detail');
    }
  }
}

class DoctorDetails extends StatefulWidget {
  final int doctorId;

  const DoctorDetails({super.key, required this.doctorId});

  @override
  _DoctorDetailsState createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  late Future<Map<String, dynamic>> _doctorDetails;
  
  

  @override
  void initState() {
    super.initState();
    _doctorDetails = ApiService().getDoctorDetail(widget.doctorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 10, 232, 213),
        title: const Text(
          "Doctor Details",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _doctorDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data found'));
          } else {
            final doctor = snapshot.data!;
            return ListView(
              children: <Widget>[
                AboutDoctor(
                  imageUrl: doctor['image'] ?? '',
                  name: doctor['doctor_name'] ?? 'Unknown Doctor',
                  hospitalName: doctor['hospital_name'] ?? 'Unknown Hospital',
                ),
                DetailBody(
                  description: doctor['description'] ?? 'No description available',
                  experience: doctor['experience']?.toString() ?? 'Unknown',
                  rating: doctor['rating']?.toString() ?? 'N/A',
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 10, 232, 213),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context, MaterialPageRoute(
             builder: (context) => const BookingPage(
              userId: 1,
             doctorId: 2,
            hospitalId: 2,
    ),
  ),
);
                      },
                      child: const Text(
                        "Book appointments here",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class AboutDoctor extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String hospitalName;

  const AboutDoctor({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.hospitalName,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 85.0,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            hospitalName,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  final String description;
  final String experience;
  final String rating;

  const DetailBody({
    super.key,
    required this.description,
    required this.experience,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DoctorInfo(
            experience: experience,
            rating: rating,
          ),
          const SizedBox(height: 12),
          const Text(
            'About Doctor',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}

class DoctorInfo extends StatelessWidget {
  final String experience;
  final String rating;

  const DoctorInfo({
    super.key,
    required this.experience,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const InfoCard(label: 'Patients', value: '100'),
        const SizedBox(width: 15),
        InfoCard(label: 'Experience', value: experience),
        const SizedBox(width: 15),
        InfoCard(label: 'Rating', value: rating),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  final String label;
  final String value;

  const InfoCard({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromARGB(255, 10, 232, 213),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class DoctorDetails extends StatefulWidget {
//   const DoctorDetails({super.key});

//   @override
//   State<DoctorDetails> createState() => _DoctorDetailsState();
// }

// class _DoctorDetailsState extends State<DoctorDetails> {
//   bool isFavourite = false;
  
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 10, 232, 213),
//         title: const Text(
//           " Doctor Details",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: ListView(
//         children:[ 
//           const AboutDoctor(),
//           const DetailBody(),
//           const Spacer(),
//            Padding(
//             padding: const EdgeInsets.all(20),
//             child: SizedBox(
//             height: 40,
//             child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color.fromARGB(255, 10, 232, 213),
//                     foregroundColor: Colors.white,
//                   ),
//                   onPressed: (){
//                     Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>  const BookingPage()),
//                         );
//                   },
//                   child: const Text(
//                     "Book appoinments here",
//                     style: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//                     ),
//                   ),
//             ),
//                     ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AboutDoctor extends StatelessWidget {
//   const AboutDoctor({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const SizedBox(
//       width: double.infinity,
//       child: Column(
//         children: <Widget>[
//           CircleAvatar(
//             radius: 85.0,
//             backgroundColor: Colors.white,
//             backgroundImage: AssetImage('assests/images/pexels-thirdman-5327580.jpg'),
//           ),
//           SizedBox(height: 12),
//           Text(
//             " Dr Sarah Tan",
//             style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 24.0,
//                 fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 12),
//           SizedBox(
//               height: 20,
//               child: Text(
//                 " St John Hopkins hospital",
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 15,
//                 ),
//                 softWrap: true,
//                 textAlign: TextAlign.center,
//               )),
//           SizedBox(height: 12),
//           Text(
//             " Nairobi Hospital",
//             style: TextStyle(
//                 color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
//             softWrap: true,
//             textAlign: TextAlign.center,
//           )
//         ],
//       ),
//     );
//   }
// }

// class DetailBody extends StatelessWidget {
//   const DetailBody({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       margin: const EdgeInsets.only(bottom: 30),
//       child:const Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           SizedBox(
//             height: 12,
//           ),
//            DoctorInfo(),
//           SizedBox(
//             height: 12,
//           ),
//            Text(
//             'About Doctor',
//             style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
//           ),
//           SizedBox(
//             height: 12,
//           ),
//            Text('Dr Sarah Tan is an experience dental Specialist at Nairobi hospital, graduated since 2008, and completed her training at St John Hopkins.',
//             style:  TextStyle(
//               fontWeight: FontWeight.w500,
//               height: 1.5,
              
//             ),
//              softWrap: true,
//             textAlign: TextAlign.justify),
//         ],
//       ),
//     );
//   }
// }

// class DoctorInfo extends StatelessWidget {
//   const DoctorInfo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return  const Row(
//       children: <Widget>[
//        InfoCard(label: 'Patients', value: '100'),
//        SizedBox(width: 15,),
//         InfoCard(label: 'Experiences', value: '10 years'),
//         SizedBox(width: 15,),
//          InfoCard(label: 'Rating', value: '4.6')
//       ],
//     );
//   }
// }

// class InfoCard extends StatelessWidget {
//   const InfoCard({super.key, required this.label, required this.value});

//   final String label;
//   final String value;

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           color:const Color.fromARGB(255, 10, 232, 213),
//         ),
//         padding: const EdgeInsets.symmetric(
//           vertical: 15,
//           horizontal: 15,
//         ),
//         child: Column(
//           children: <Widget>[
//             Text(
//               label,
//               style: const TextStyle(
//                 color: Colors.black,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Text(
//               value,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

