import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy/Provider/local_provider.dart';
import 'package:provider/provider.dart';

class Reports extends StatelessWidget {
  const Reports({super.key});


  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.chevron_left,color: Color.fromRGBO(83, 113, 136,1),size: 30,),
          ),
          titleSpacing: 0,
          backgroundColor:   Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(
              color: Color.fromRGBO(83, 113, 136,1)
          ),
          title:
          Text(
            'View Reports',
            style: GoogleFonts.lato(fontSize: 20,fontWeight: FontWeight.bold, color: const Color.fromRGBO(83, 113, 136,1),),
          ),

        ),
        body:StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('patients')
              .doc(Provider.of<Localprovider>(context, listen: false).auth.currentUser!.uid)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data!.exists) {
              List<Map<dynamic, dynamic>> reports = List<Map<dynamic, dynamic>>.from(snapshot.data!.get('reports') ?? []);
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: reports.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<dynamic, dynamic> report = reports[index];
                  DateTime date = report['date'].toDate();
                  String reportText = report['text'];

                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            height: 400,
                            width: double.infinity,
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(15),
                              gradient:  const LinearGradient(
                                colors: [ Color.fromRGBO(83, 113, 136,1),Colors.black87],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Spacer(),
                                          Text('${date.day}/${date.month}/${date.year}',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.white),),
                                        ],
                                      ),
                                      const SizedBox(height: 10,),
                                      Text('Report-${index+1}:',style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.white),),
                                      const SizedBox(height: 10,),
                                      Text(reportText,style: const TextStyle(fontSize: 16,color: Colors.white70),),
                                    ]
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error.toString()}'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      );
  }

}
