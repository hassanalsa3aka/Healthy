import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthy/doctor/doctor_chat.dart';
import 'package:healthy/patient/patient_chat.dart';
import 'package:provider/provider.dart';

class Localprovider with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  QueryDocumentSnapshot<Object?>? peerUserData;


  void startChattingWithDoctor(AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int index, BuildContext context){
    FirebaseFirestore.instance
        .collection('doctors')
        .where('userId',
        isEqualTo: snapshot.data!.docs[index]['userId'].toString())
        .get()
        .then((QuerySnapshot value) {
      peerUserData = value.docs[0];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>   PtChat(),
        ),
      );
    });
    notifyListeners();
  }
  void startChattingWithPatient(AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int index, BuildContext context){
    FirebaseFirestore.instance
        .collection('patients')
        .where('userId',
        isEqualTo: snapshot.data!.docs[index]['userId'].toString())
        .get()
        .then((QuerySnapshot value) {
      peerUserData = value.docs[0];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  const DrChats(),
        ),
      );
    });
    notifyListeners();
  }


  String getChatId(BuildContext context){
    return Provider.of<Localprovider>(context,listen: false).auth.currentUser!.uid.hashCode <=
        Provider.of<Localprovider>(context,listen: false).peerUserData!["userId"].hashCode ?
    "${Provider.of<Localprovider>(context,listen: false).auth.currentUser!.uid} - ${Provider.of<Localprovider>(context,listen: false).peerUserData!["userId"]}" :
    "${Provider.of<Localprovider>(context,listen: false).peerUserData!["userId"]} - ${Provider.of<Localprovider>(context,listen: false).auth.currentUser!.uid}";
  }


  void patientRecentChatClickListener(AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int index, BuildContext context){
    if(snapshot.data!.docs[index]['messageSenderId'].toString() ==
        Provider.of<Localprovider>(context, listen: false).auth.currentUser!.uid){
      FirebaseFirestore.instance
          .collection('doctors')
          .where('userId',
          isEqualTo: snapshot.data!.docs[index]['messageReceiverId'].toString())
          .get()
          .then((QuerySnapshot value) {
        peerUserData = value.docs[0];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>   PtChat(),
          ),
        );
      });
      notifyListeners();
    }else{
      FirebaseFirestore.instance
          .collection('doctors')
          .where('userId',
          isEqualTo: snapshot.data!.docs[index]['messageSenderId'].toString())
          .get()
          .then((QuerySnapshot value) {
        peerUserData = value.docs[0];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  PtChat(),
          ),
        );
      });
      notifyListeners();
    }

  }
  void doctorRecentChatClickListener(AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int index, BuildContext context){
    if(snapshot.data!.docs[index]['messageSenderId'].toString() ==
        Provider.of<Localprovider>(context, listen: false).auth.currentUser!.uid){
      FirebaseFirestore.instance
          .collection('patients')
          .where('userId',
          isEqualTo: snapshot.data!.docs[index]['messageReceiverId'].toString())
          .get()
          .then((QuerySnapshot value) {
        peerUserData = value.docs[0];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  const DrChats(),
          ),
        );
      });
      notifyListeners();
    }else{
      FirebaseFirestore.instance
          .collection('patients')
          .where('userId',
          isEqualTo: snapshot.data!.docs[index]['messageSenderId'].toString())
          .get()
          .then((QuerySnapshot value) {
        peerUserData = value.docs[0];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  const DrChats(),
          ),
        );
      });
      notifyListeners();
    }

  }


}
