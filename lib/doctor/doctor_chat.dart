import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy/Provider/local_provider.dart';
import 'package:healthy/firbase_helper/firebase_helper.dart';
import 'package:healthy/widget/doctor_sub_title_app_bar.dart';
import 'package:healthy/widget/message_compose_doctor.dart';
import 'package:healthy/widget/messages_list.dart';
import 'package:provider/provider.dart';


class DrChats extends StatefulWidget {
  const DrChats({super.key});

  @override
  _DrChatsState createState() => _DrChatsState();
}

class _DrChatsState extends State<DrChats> with WidgetsBindingObserver{
  late Localprovider _appProvider;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    FireBaseHelper().updateDoctorStatus("Online",Provider.of<Localprovider>(context,listen: false).auth.currentUser!.uid);
    // updatePeerDevice(Provider.of<MyProvider>(context,listen: false).auth.currentUser!.email, Provider.of<MyProvider>(context,listen: false).peerUserData!["email"]);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _appProvider = Provider.of<Localprovider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    FireBaseHelper().updateDoctorStatus(FieldValue.serverTimestamp(),_appProvider.auth.currentUser!.uid);
    // updatePeerDevice(_appProvider.auth.currentUser!.email, "0");
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch(state)
    {
      case AppLifecycleState.paused:
        FireBaseHelper().updateDoctorStatus(FieldValue.serverTimestamp(),Provider.of<Localprovider>(context,listen: false).auth.currentUser!.uid);
        // updatePeerDevice(Provider.of<MyProvider>(context,listen: false).auth.currentUser!.email, "0");
        break;
      case AppLifecycleState.inactive:
        FireBaseHelper().updateDoctorStatus(FieldValue.serverTimestamp(),Provider.of<Localprovider>(context,listen: false).auth.currentUser!.uid);
        // updatePeerDevice(Provider.of<MyProvider>(context,listen: false).auth.currentUser!.email, "0");
        break;
      case AppLifecycleState.detached:
        FireBaseHelper().updateDoctorStatus(FieldValue.serverTimestamp(),Provider.of<Localprovider>(context,listen: false).auth.currentUser!.uid);
        // updatePeerDevice(Provider.of<MyProvider>(context,listen: false).auth.currentUser!.email, "0");
        break;
      case AppLifecycleState.resumed:
        FireBaseHelper().updateDoctorStatus("Online",Provider.of<Localprovider>(context,listen: false).auth.currentUser!.uid);
        // updatePeerDevice(Provider.of<MyProvider>(context,listen: false).auth.currentUser!.email, Provider.of<MyProvider>(context,listen: false).peerUserData!["email"]);
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
    }    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          elevation: 5,
          backgroundColor:  const Color.fromRGBO(22, 75, 96,1),
          leading: IconButton(
            icon: const Icon(Icons.chevron_left,size: 30,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(Provider.of<Localprovider>(context,listen: false).peerUserData!["name"],
                      style:  GoogleFonts.lato(fontSize: 18.5, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  const DoctorSubTitleAppBar(),
                ],
              ),
              SelectableText(Provider.of<Localprovider>(context,listen: false).peerUserData!["userId"],
                  style: const TextStyle(fontSize: 11, )),
            ],
          ),
        ),
        body:const Column(
          children:  [
            Expanded(child: Messages(),),
            MessagesComposeDoctor(),
          ],
        )

    );
  }
}