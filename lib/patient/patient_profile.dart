import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:healthy/Provider/local_provider.dart';
import 'package:provider/provider.dart';

class PtProfile extends StatefulWidget {
  const PtProfile({super.key});

  @override
  _PtProfileState createState() => _PtProfileState();
}

class _PtProfileState extends State<PtProfile> {
  // show the dialog
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Profile',
          style: GoogleFonts.lato(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 20),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Colors.black, Colors.black87],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -10,
                left: 40,
                child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(('assets/images/70.jpg')),
                          fit: BoxFit.cover)),
                  height: 120,
                  width: 120,
                ),
              ),
              Positioned(
                top: 140,
                left: 50,
                child: Text(
                  'Name:  ${Provider.of<Localprovider>(context, listen: false).auth.currentUser!.displayName}',
                  style: GoogleFonts.lato(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Positioned(
                top: 170,
                left: 50,
                child: Text(
                  'Email:  ${Provider.of<Localprovider>(context, listen: false).auth.currentUser!.email}',
                  style: GoogleFonts.lato(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 60,
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
                      'Delete My Account',
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Widget cancelButton = TextButton(
                          child: const Text("No"),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        );
                        Widget continueButton = TextButton(
                          child: const Text("Yes"),
                          onPressed: () {
                            Navigator.pushNamed(context, 'start');
                          },
                        );

                        AlertDialog alert = AlertDialog(
                          title: const Text("Your account will be deleted"),
                          content: const Text(
                              "Are you sure you want to delete your account?"),
                          actions: [cancelButton, continueButton],
                        );
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      },
                      icon: const Icon(Icons.delete, color: Colors.red, size: 30))
                ],
              ),
            ),
          ),
          const SizedBox(height: 30,),
          ElevatedButton(
            onPressed: () {
              // Handle Logout
              Navigator.pushNamed(context, 'start');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
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
                  Navigator.pushNamed(context, 'pt_home');
                } else if (_selectedIndex == 1) {
                  Navigator.pushNamed(context, 'map');
                } else if (_selectedIndex == 2) {
                  Navigator.pushNamed(context, 'pt_profile');
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
