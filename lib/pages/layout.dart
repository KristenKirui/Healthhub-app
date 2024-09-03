import 'package:assessment_one/pages/appointment_page.dart';
import 'package:assessment_one/pages/home_page.dart';
import 'package:assessment_one/pages/profile.dart';
import 'package:flutter/material.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  int currentPage = 0;
  final PageController _page = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromARGB(255, 10, 232, 213),
      body: PageView(
        controller: _page,
          onPageChanged: ((value) {
            setState(() {
              currentPage = value;
            });
          }),
          children: const <Widget>[
            HomePage(),
            AppointmentPage(),
            ProfilePage()
          ]),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: const Color.fromARGB(255, 10, 232, 213),
        currentIndex: currentPage,
        onTap: (page) {
          setState(() {
            currentPage = page;
            _page.animateToPage(
              page,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        },
        items:const  <BottomNavigationBarItem> [
          BottomNavigationBarItem(icon: Icon(Icons.house_outlined),
          label: "Home",),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month),
          label: "Appointments",),
           BottomNavigationBarItem(icon: Icon(Icons.person),
          label: "Profile",),
        ]
      ),
    );
  }
}
