import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:healthy/Provider/local_provider.dart';
import 'package:healthy/chatbot/chatbot.dart';
import 'package:healthy/clander/clander.dart';
import 'package:healthy/google_map/view_map.dart';
import 'package:healthy/patient/patient_profile.dart';
import 'package:healthy/patient/prescription.dart';
import 'package:healthy/widget/patient_recent_chats.dart';
import 'package:provider/provider.dart';

class PtHome extends StatefulWidget {
  const PtHome({super.key});

  @override
  _PtHomeState createState() => _PtHomeState();
}

class _PtHomeState extends State<PtHome> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${Provider.of<Localprovider>(context, listen: false).auth.currentUser!.displayName}',
                style: GoogleFonts.lato(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                'Recent Chat',
                style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 20,
              ),
              _buildRecentChatContainer(),
              const SizedBox(
                height: 20,
              ),
              _buildViewReportContainer(),
              const SizedBox(
                height: 20,
              ),
              _buildChatBotContainer(),
              const SizedBox(
                height: 20,
              ),
              _buildMyCalendarContainer(),
              const SizedBox(
                height: 20,
              ),
              _buildPersonalInformationContainer(),
              const SizedBox(
                height: 20,
              ),
              _mydoctorsContainer(),
              const SizedBox(
                height: 20,
              ),
              _heartContainer(),

              const SizedBox(
                height: 20,
              ),
              _medContainer(),

              const SizedBox(
                height: 20,
              ),
              _finddoctorContainer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildRecentChatContainer() {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [Colors.black, Colors.black87],
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: PatientRecentChats(),
        ),
      ),
    );
  }

  Widget _buildViewReportContainer() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Reports()),
        );
      },
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [Colors.black, Colors.black87],
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'View Report',
                  style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                CupertinoIcons.news,
                size: 24,
                color: Colors.white,
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right_outlined,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatBotContainer() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Healthybot()),
        );
      },
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [Colors.black, Colors.black87],
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Chat Bot',
                  style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                CupertinoIcons.rosette,
                size: 24,
                color: Colors.white,
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right_outlined,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMyCalendarContainer() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CalendarPage()),
        );
      },
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [Colors.black, Colors.black87],
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'My Calendar',
                  style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.calendar_today_outlined,
                size: 24,
                color: Colors.white,
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right_outlined,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInformationContainer() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'personal');
      },
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [Colors.black, Colors.black87],
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'My Personal Information',
                  style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.note_alt_outlined,
                size: 24,
                color: Colors.white,
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right_outlined,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }




  Widget _medContainer() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'pt_med_his');
      },
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [Colors.black, Colors.black87],
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'medical history',
                  style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.history,
                size: 24,
                color: Colors.white,
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right_outlined,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _mydoctorsContainer() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'pt_doctors');
      },
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [Colors.black, Colors.black87],
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'my doctors',
                  style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.local_hospital_outlined,
                size: 24,
                color: Colors.white,
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right_outlined,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _finddoctorContainer() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'find_doctor');
      },
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [Colors.black, Colors.black87],
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'find doctors',
                  style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.search,
                size: 24,
                color: Colors.white,
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right_outlined,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heartContainer() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'heart');
      },
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [Colors.black, Colors.black87],
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'heart prediction',
                  style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.rocket_sharp,
                size: 24,
                color: Colors.white,
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right_outlined,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
      ]),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            gap: 8,
            activeColor: Colors.white,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            duration: const Duration(milliseconds: 800),
            tabBackgroundColor: Colors.black,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
              if (_selectedIndex == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>const PtHome()),
                );
              } else if (_selectedIndex == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewMapPage()),
                );
              } else if (_selectedIndex == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>const PtProfile()),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
