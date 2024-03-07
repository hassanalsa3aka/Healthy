import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy/Provider/local_provider.dart';
import 'package:healthy/firbase_helper/firebase_helper.dart';
import 'package:healthy/snakbar.dart';
import 'package:provider/provider.dart';

class PtDoctors extends StatefulWidget {
  const PtDoctors({super.key});

  @override
  _PtDoctorsState createState() => _PtDoctorsState();
}

class _PtDoctorsState extends State<PtDoctors> {
  late BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Doctors',
          style: GoogleFonts.lato(fontSize: 20,fontWeight: FontWeight.bold, color: const Color.fromRGBO(83, 113, 136,1),),
        ),

      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/black.jpg'),
                ),
                color: Colors.white,
              ),
              child: Text(''),
            ),
            ListTile(
              title: const Text('My Profile'),
              onTap: () {
                Navigator.pushNamed(context, 'dr_profile');
              },
            ),
            ListTile(
              title: const Text('My Patients'),
              onTap: () {
                Navigator.pushNamed(context, 'dr_patients');
              },
            ),
            ListTile(
              title: const Text('Sign out'),
              onTap: () {
                Navigator.pushNamed(context, 'start');
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          StreamBuilder(
            stream: FireBaseHelper().getVerifiedDoctors(context),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong try again');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return snapshot.data!.size == 0
                  ? Container(
                padding: const EdgeInsets.only(left: 35, top: 80),
                child: const Text(
                  '     No doctors found',
                  style: TextStyle(color: Colors.black, fontSize: 33),
                ),
              )
                  : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {},
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Text(
                                                snapshot.data!.docs[index]
                                                ['name'],
                                                style: GoogleFonts.lato(
                                                  color: const Color.fromRGBO(83, 113, 136,1),
                                                  fontSize: 20.0,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            snapshot.data!.docs[index]
                                            ['verified'] ==
                                                "1"
                                                ? SizedBox(
                                                width: 15,
                                                height: 15,
                                                child: Image.asset(
                                                    "assets/images/verified.png"))
                                                : Container(),
                                          ],
                                        ),
                                        Text(
                                          snapshot.data!.docs[index]
                                          ['spec'],
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        StreamBuilder(
                                            stream: FirebaseFirestore
                                                .instance
                                                .collection('patients')
                                                .doc(Provider.of<
                                                Localprovider>(
                                                context,
                                                listen: false)
                                                .auth
                                                .currentUser!
                                                .uid)
                                                .snapshots(),
                                            builder: (context, snap) {
                                              if (!snap.hasData) {
                                                return Container();
                                              }
                                              var userDocument =
                                                  snap.data;
                                              return userDocument![
                                              "docId"] !=
                                                  "0"
                                                  ? Container()
                                                  : IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context:
                                                        context,
                                                        barrierDismissible:
                                                        false,
                                                        builder:
                                                            (context) {
                                                          dialogContext =
                                                              context;
                                                          return const Center(
                                                            child:
                                                            CircularProgressIndicator(),
                                                          );
                                                        });
                                                    FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                        'patients')
                                                        .doc(Provider.of<
                                                        Localprovider>(
                                                        context,
                                                        listen:
                                                        false)
                                                        .auth
                                                        .currentUser!
                                                        .uid)
                                                        .update({
                                                      'docId': snapshot
                                                          .data!
                                                          .docs[index]
                                                      ['userId']
                                                    }).then((_) {
                                                      buildShowSnackBar(
                                                          context,
                                                          "Added success");
                                                      Navigator.pop(
                                                          dialogContext);
                                                    }).catchError(
                                                            (error) {
                                                          buildShowSnackBar(
                                                              context,
                                                              "error");
                                                        });
                                                  },
                                                  icon: const Icon(
                                                    Icons.add,
                                                  ));
                                            }),
                                        IconButton(
                                            onPressed: () {
                                              Provider.of<Localprovider>(
                                                  context,
                                                  listen: false)
                                                  .startChattingWithDoctor(
                                                  snapshot,
                                                  index,
                                                  context);
                                            },
                                            icon: const Icon(Icons.chat,size: 25,color: Color.fromRGBO(83, 113, 136,1)))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )));
                  });
            },
          )
        ],
      ),
    );
  }
}
