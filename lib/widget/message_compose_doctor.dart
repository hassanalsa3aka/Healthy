// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy/Provider/local_provider.dart';
import 'package:healthy/firbase_helper/firebase_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';


class MessagesComposeDoctor extends StatefulWidget {
   const MessagesComposeDoctor({super.key});

  @override
  State<MessagesComposeDoctor> createState() => _MessagesComposeState();
}

class _MessagesComposeState extends State<MessagesComposeDoctor> with WidgetsBindingObserver{
  final TextEditingController _textController = TextEditingController();
  bool sendChatButton = false;
  final ImagePicker _picker = ImagePicker();
  late BuildContext dialogContext;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width - 55,
            child: Card(
              color: const Color.fromRGBO(22, 75, 96,1),
              margin: const EdgeInsets.only(
                  left: 6, right: 6, bottom: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: TextField(
                  style: const TextStyle(color: Colors.white,),
                  controller: _textController,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  minLines: 1,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      FireBaseHelper().updateDoctorStatus("typing....",Provider.of<Localprovider>(context,listen: false).auth.currentUser!.uid);
                      setState(() {
                        sendChatButton = true;
                      });
                    } else {
                      FireBaseHelper().updateDoctorStatus("Online",Provider.of<Localprovider>(context,listen: false).auth.currentUser!.uid);
                      setState(() {
                        sendChatButton = false;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "   Type your message...",
                    hintStyle:  GoogleFonts.lato(color: Colors.white,),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        IconButton(
                            onPressed: ()  async {
                              final status = await Permission.storage.request();
                              if(status == PermissionStatus.granted) {
                                final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                                UploadTask uploadTask = FireBaseHelper().getRefrenceFromStorage(
                                    photo, "", context);
                                uploadFile("", "image", uploadTask, context);
                              }else{
                                await Permission.storage.request();
                              }

                            },
                            icon: const Icon(Icons.camera_alt,color: Colors.white,)
                        )
                      ],
                    ),
                    contentPadding: const EdgeInsets.all(5),
                  )),
            )),
        Container(),
        Padding(
          padding:
          const EdgeInsets.only(bottom: 8.0, right: 2),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: const Color.fromRGBO(22, 75, 96,1),
            child:Center(
              child: IconButton(
                  onPressed: () async {
                    if (sendChatButton) {
                      //txt message
                      FireBaseHelper().sendMessage(
                          chatId : Provider.of<Localprovider>(context,listen: false).getChatId(context),
                          senderId : Provider.of<Localprovider>(context,listen: false).auth.currentUser!.uid,
                          receiverId : Provider.of<Localprovider>(context,listen: false).peerUserData!["userId"],
                          msgTime : FieldValue.serverTimestamp(),
                          msgType : "text",
                          message : _textController.text.toString(),
                          fileName: ""
                      );

                      FireBaseHelper().updateLastMessage(
                          chatId : Provider.of<Localprovider>(context,listen: false).getChatId(context),
                          senderId : Provider.of<Localprovider>(context,listen: false).auth.currentUser!.uid,
                          receiverId : Provider.of<Localprovider>(context,listen: false).peerUserData!["userId"],
                          receiverUsername : Provider.of<Localprovider>(context,listen: false).peerUserData!["name"],
                          msgTime : FieldValue.serverTimestamp(),
                          msgType : "text",
                          message : _textController.text.toString(),
                          context: context
                      );
                      // notifyUser(Provider.of<MyProvider>(context,listen: false).auth.currentUser!.displayName,
                      //     _textController.text.toString(),
                      //     Provider.of<MyProvider>(context,listen: false).peerUserData!["email"],
                      //     Provider.of<MyProvider>(context,listen: false).auth.currentUser!.email);
                      _textController.clear();
                      setState(() {
                        sendChatButton = false;
                      });
                      FireBaseHelper().updatePatientStatus("Online",Provider.of<Localprovider>(context,listen: false).auth.currentUser!.uid);

                    }

                  },
                  icon: const Center(
                    child: Icon(
                       Icons.send,
                      color: Colors.white,
                      size: 25,
                    ),
                  )),
            ),


          ),
        ),
      ],
    );
  }


  void uploadFile(String fileName,String fileType,UploadTask uploadTask, BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          dialogContext = context;
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );
    uploadTask.whenComplete(() => {
      Navigator.of(dialogContext).pop(),

      uploadTask.then((fileUrl) {
        fileUrl.ref.getDownloadURL().then((value) {
          FireBaseHelper().sendMessage(
              chatId : Provider.of<Localprovider>(context,listen: false).getChatId(context),
              senderId : Provider.of<Localprovider>(context,listen: false).auth.currentUser!.uid,
              receiverId : Provider.of<Localprovider>(context,listen: false).peerUserData!["userId"],
              msgTime : FieldValue.serverTimestamp(),
              msgType : fileType,
              message : value,
              fileName: (fileType =="document")||(fileType =="audio")||(fileType =="voice message")? fileName:""
          );

          FireBaseHelper().updateLastMessage(
              chatId : Provider.of<Localprovider>(context,listen: false).getChatId(context),
              senderId : Provider.of<Localprovider>(context,listen: false).auth.currentUser!.uid,
              receiverId : Provider.of<Localprovider>(context,listen: false).peerUserData!["userId"],
              receiverUsername : Provider.of<Localprovider>(context,listen: false).peerUserData!["name"],
              msgTime : FieldValue.serverTimestamp(),
              msgType : fileType,
              message : value,
              context: context
          );
        });
      })
    });
  }



}