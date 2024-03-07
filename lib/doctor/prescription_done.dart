import 'package:flutter/material.dart';
import 'package:healthy/doctor/doctor_home.dart';

class ReportDone extends StatelessWidget {
  const ReportDone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Text('Report Add Successfully',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),),

          ],
        ),
        floatingActionButton:FloatingActionButton(
          onPressed: (){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const Doctorhome()), (route) => false);
          },
          child: const Icon(Icons.home),
        )
    );
  }
}
