import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy/Provider/local_provider.dart';
import 'package:healthy/doctor/add_prescription.dart';
import 'package:healthy/pharmaceutical/pharm_pt.dart';
import 'package:healthy/widget/doctors_recent_chats.dart';
import 'package:provider/provider.dart';



class Pharmhome extends StatefulWidget {
  const Pharmhome({super.key});

  @override
  _Pharmhomestate createState() => _Pharmhomestate();
}

class _Pharmhomestate extends State<Pharmhome> {
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
                style: GoogleFonts.lato(fontSize: 20,fontWeight: FontWeight.bold,color:  Colors.black,),
              ),

              const SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>   PatientReportsPage()));

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
                          child: Text('search for report',style: GoogleFonts.lato(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),),
                        ),
                        const SizedBox(width: 10,),
                        const Icon(CupertinoIcons.search,size: 24,color: Colors.white,),
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
                          child: Text('Add map ',style: GoogleFonts.lato(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),),
                        ),
                        const SizedBox(width: 10,),
                        const Icon(Icons.map,size: 24,color: Colors.white,),
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
                  Navigator.pushNamed(context, 'ph_profile');

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
                          child: Text('Profile',style: GoogleFonts.lato(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),),
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
}
