import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:healthy/Provider/local_provider.dart';
import 'package:healthy/doctor/add_prescription.dart';
import 'package:healthy/doctor/doctor_profile.dart';
import 'package:healthy/widget/doctors_recent_chats.dart';
import 'package:provider/provider.dart';



class Doctorhome extends StatefulWidget {
  const Doctorhome({super.key});

  @override
  _Doctorhomestate createState() => _Doctorhomestate();
}

class _Doctorhomestate extends State<Doctorhome> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(



      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                'Welcome dr, ${Provider.of<Localprovider>(context,listen: false).auth.currentUser!.displayName}',
                style: GoogleFonts.lato(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black,),
              ),

              Text('Recent Chat',style: GoogleFonts.lato(fontWeight: FontWeight.bold,fontSize: 30, color: const Color.fromRGBO(22, 75, 96,1),),),
              const SizedBox(height: 20,),
              Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [Colors.black,Colors.black87],
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: DoctorsRecentChats(),
                    )
                ),
              ),
              const SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddReport()));

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
                        colors: [Colors.black,Colors.black87],
                      ),

                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text('Add Report',style: GoogleFonts.lato(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),),
                        ),
                        const SizedBox(width: 10,),
                        const Icon(CupertinoIcons.news,size: 24,color: Colors.white,),
                        const Spacer(),
                        const Icon(Icons.chevron_right_outlined,color: Colors.white,size: 30,),
                        const SizedBox(width: 10,),

                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, 'add_patient');

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
                        colors: [Colors.black,Colors.black87],
                      ),

                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text('Add New Patient',style: GoogleFonts.lato(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),),
                        ),
                        const SizedBox(width: 10,),
                        const Icon(Icons.person_add,size: 24,color: Colors.white,),
                        const Spacer(),
                        const Icon(Icons.chevron_right_outlined,color: Colors.white,size: 30,),
                        const SizedBox(width: 10,),

                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, 'dr_patients');

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
                        colors: [Colors.black,Colors.black87],
                      ),

                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text('Patients',style: GoogleFonts.lato(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),),
                        ),
                        const SizedBox(width: 10,),
                        const Icon(Icons.people_alt,size: 24,color: Colors.white,),
                        const Spacer(),
                        const Icon(Icons.chevron_right_outlined,color: Colors.white,size: 30,),
                        const SizedBox(width: 10,),

                      ],
                    ),
                  ),
                ),
              ),


              const SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, 'Calendar');

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
                        colors: [Colors.black,Colors.black87],
                      ),

                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text('My Calendar',style: GoogleFonts.lato(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),),
                        ),
                        const SizedBox(width: 10,),
                        const Icon(Icons.calendar_today_outlined,size: 24,color: Colors.white,),
                        const Spacer(),
                        const Icon(Icons.chevron_right_outlined,color: Colors.white,size: 30,),
                        const SizedBox(width: 10,),

                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20,),
              InkWell(
                onTap: (){
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
                        colors: [Colors.black,Colors.black87],
                      ),

                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text('heart prediction',style: GoogleFonts.lato(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),),
                        ),
                        const SizedBox(width: 10,),
                        const Icon(Icons.rocket_launch_sharp,size: 24,color: Colors.white,),
                        const Spacer(),
                        const Icon(Icons.chevron_right_outlined,color: Colors.white,size: 30,),
                        const SizedBox(width: 10,),

                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, 'chatbot');

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
                        colors: [Colors.black,Colors.black87],
                      ),

                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text('Chat Bot',style: GoogleFonts.lato(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),),
                        ),
                        const SizedBox(width: 10,),
                        const Icon(Icons.rocket,size: 24,color: Colors.white,),
                        const Spacer(),
                        const Icon(Icons.chevron_right_outlined,color: Colors.white,size: 30,),
                        const SizedBox(width: 10,),

                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, 'addmap');

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
                        colors: [Colors.black,Colors.black87],
                      ),

                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text('add map',style: GoogleFonts.lato(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),),
                        ),
                        const SizedBox(width: 10,),
                        const Icon(Icons.rocket,size: 24,color: Colors.white,),
                        const Spacer(),
                        const Icon(Icons.chevron_right_outlined,color: Colors.white,size: 30,),
                        const SizedBox(width: 10,),

                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, 'dr_profile');

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
                        colors: [Colors.black,Colors.black87],
                      ),

                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text('profile',style: GoogleFonts.lato(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),),
                        ),
                        const SizedBox(width: 10,),
                        const Icon(Icons.person,size: 24,color: Colors.white,),
                        const Spacer(),
                        const Icon(Icons.chevron_right_outlined,color: Colors.white,size: 30,),
                        const SizedBox(width: 10,),

                      ],
                    ),
                  ),
                ),
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
                  MaterialPageRoute(builder: (context) =>const Doctorhome()),
                );
              }
               else if (_selectedIndex == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>const DrProfile()),
                );
              }
            },
          ),
        ),
      ),
    );
  }


}
