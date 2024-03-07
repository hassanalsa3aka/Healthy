import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthy/Provider/local_provider.dart';
import 'package:healthy/firbase_helper/firebase_helper.dart';
import '../widget/message_compose.dart';
import '../widget/messages_list.dart';
import '../widget/patient_sub_title_app_bar.dart';

class PtChat extends StatefulWidget {
  const PtChat({Key? key}) : super(key: key);

  @override
  _PtChatState createState() => _PtChatState();
}

class _PtChatState extends State<PtChat> with WidgetsBindingObserver {
  late Localprovider _appProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _appProvider = Provider.of<Localprovider>(context, listen: false);
    FireBaseHelper().updatePatientStatus("Online", _appProvider.auth.currentUser!.uid);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    FireBaseHelper().updatePatientStatus(FieldValue.serverTimestamp(), _appProvider.auth.currentUser!.uid);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        FireBaseHelper().updatePatientStatus(FieldValue.serverTimestamp(), _appProvider.auth.currentUser!.uid);
        break;
      case AppLifecycleState.resumed:
        FireBaseHelper().updatePatientStatus("Online", _appProvider.auth.currentUser!.uid);
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: const Color.fromRGBO(83, 113, 136, 1),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left, size: 30),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _appProvider.peerUserData?["name"] ?? "", // Ensure that peerUserData is not null
              style: GoogleFonts.lato(fontSize: 18.5, fontWeight: FontWeight.bold),
            ),
            const PatientSubTitleAppBar(),
          ],
        ),
      ),
      body: Column(
        children: const [
          Expanded(child: Messages()),
          MessagesCompose(),
        ],
      ),
    );
  }
}
