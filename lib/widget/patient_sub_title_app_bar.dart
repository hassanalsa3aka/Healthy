import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy/Provider/local_provider.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';


class PatientSubTitleAppBar extends StatefulWidget {
    const PatientSubTitleAppBar({super.key});

  @override
  State<PatientSubTitleAppBar> createState() => _PatientSubTitleAppBarState();
}

class _PatientSubTitleAppBarState extends State<PatientSubTitleAppBar> {
   String userStatus = "";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('doctors')
          .where('userId', isEqualTo: Provider.of<Localprovider>(context,listen: false).peerUserData!['userId'])
          .snapshots(),
      builder: (context,  AsyncSnapshot<QuerySnapshot>  snapshot) {
        if(snapshot.data?.docs[0]["userStatus"]!=null){
            if(snapshot.data?.docs[0]["userStatus"] == "Online") {
              userStatus = snapshot.data?.docs[0]["userStatus"];
            }else if(snapshot.data?.docs[0]["userStatus"] == "typing....") {
              userStatus = snapshot.data?.docs[0]["userStatus"];
            }else {

              userStatus = "last seen : ${ Jiffy.parse (
                  DateFormat('dd-MM-yyyy hh:mm a').format(DateTime
                      .parse(snapshot.data!.docs[0]["userStatus"]
                      .toDate()
                      .toString()
                  ))
              , pattern: "dd-MM-yyyy hh:mm a").fromNow()}";
            }
        }
        return Text(userStatus,style: const TextStyle(fontSize: 13));

      }
      ,
    );
  }
}