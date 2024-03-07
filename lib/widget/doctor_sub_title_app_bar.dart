
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:healthy/Provider/local_provider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
class DoctorSubTitleAppBar extends StatefulWidget {
    const DoctorSubTitleAppBar({super.key});

  @override
  State<DoctorSubTitleAppBar> createState() => _DoctorSubTitleAppBarState();
}

class _DoctorSubTitleAppBarState extends State<DoctorSubTitleAppBar> {
   String userStatus = "";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('patients')
          .where('userId', isEqualTo: Provider.of<Localprovider>(context,listen: false).peerUserData!['userId'])
          .snapshots(),
      builder: (context,  AsyncSnapshot<QuerySnapshot>  snapshot) {
        if(snapshot.data?.docs[0]["userStatus"]!=null){
            if(snapshot.data?.docs[0]["userStatus"] == "Online") {
              userStatus = snapshot.data?.docs[0]["userStatus"];
            }else if(snapshot.data?.docs[0]["userStatus"] == "typing....") {
              userStatus = snapshot.data?.docs[0]["userStatus"];
            }else {

              userStatus = "last seen : ${ Jiffy.parse(
                      DateFormat('dd-MM-yyyy hh:mm a').format(DateTime
                      .parse(snapshot.data!.docs[0]["userStatus"]
                      .toDate()
                      .toString(),
                  ),
                      ), pattern: "dd-MM-yyyy hh:mm a").fromNow()}";
            }
        }
        return Text(userStatus,style: const TextStyle(fontSize: 13));

      }
      ,
    );
  }
}