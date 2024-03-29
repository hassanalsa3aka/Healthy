
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:healthy/Provider/local_provider.dart';
import 'package:provider/provider.dart';




class FireBaseHelper {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  get user => _auth.currentUser;
  //SIGN UP METHOD
  Future signUp({required String email, required String password}) async {
    try {
      var userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,

      );
      if (userCredential.user !=null) {
        return "true";
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }



  //SIGN IN METHOD
  Future signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if(user != null) {
        return "Welcome";
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future createAccountForPatient({required String email, required String password}) async {

    var userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCredential.user !=null) {
      return userCredential.user!.uid.toString();
    }

  }



  Stream<QuerySnapshot<Map<String, dynamic>>> getDoctors(BuildContext context) {
    return FirebaseFirestore.instance
        .collection('doctors')
        .snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getPharm(BuildContext context) {
    return FirebaseFirestore.instance
        .collection('pharmacist')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getVerifiedDoctors(BuildContext context) {
    return FirebaseFirestore.instance
        .collection('doctors')
        .where('verified', isEqualTo: '1')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getVerifiedPharm(BuildContext context) {
    return FirebaseFirestore.instance
        .collection('pharmacist')
        .where('verified', isEqualTo: '1')
        .snapshots();
  }


  Stream<QuerySnapshot<Map<String, dynamic>>> getPatient(BuildContext context) {
    return FirebaseFirestore.instance
        .collection('patients')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFilteredPatient(BuildContext context,searchQuery) {
    return FirebaseFirestore.instance
        .collection('patients')
        .where('email', isEqualTo: searchQuery)
        .snapshots();
  }



  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();
  }




  void addPharm(userId,name,email,spec,cardUrl){
    FirebaseFirestore.instance
        .collection('pharmacist')
        .doc(userId)
        .set({
      'name': name,
      'email': email,
      'userId': userId,
      'spec' : spec,
      'cardUrl':cardUrl,
      'verified':"0",
      'userStatus' : "Online"
    });
  }



  // save user data
  void addDoctor(userId,name,email,spec,cardUrl){
    FirebaseFirestore.instance
        .collection('doctors')
        .doc(userId)
        .set({
      'name': name,
      'email': email,
      'userId': userId,
      'spec' : spec,
      'cardUrl':cardUrl,
      'verified':"0",
      'userStatus' : "Online"
    });
  }

  void addPatient(userId,name,email,docId){
    FirebaseFirestore.instance
        .collection('patients')
        .doc(userId)
        .set({
      'name': name,
      'email': email,
      'userId': userId,
      'docId' : docId,
      'userStatus' : "Online",
      'reports':[],

    });
  }



  // send message to user
  void sendMessage({required chatId,required senderId,required receiverId,required msgTime,required msgType,required message,required fileName}){
    FirebaseFirestore.instance
        .collection("messages")
        .doc(chatId)
        .collection(chatId)
        .doc("${Timestamp.now().millisecondsSinceEpoch}")
        .set({
      'chatId': chatId,
      'senderId': senderId,
      'receiverId': receiverId,
      'msgTime' : msgTime,
      'msgType':msgType,
      'message':message,
      'fileName':fileName,
    });
  }
  // update user status
  void updatePatientStatus(userStatus,userId){
    FirebaseFirestore.instance
        .collection('patients')
        .doc(userId)
        .update({'userStatus': userStatus});
  }

  void updateDoctorStatus(userStatus,userId){
    FirebaseFirestore.instance
        .collection('doctors')
        .doc(userId)
        .update({'userStatus': userStatus});
  }



  void updatePharmStatus(userStatus,userId){
    FirebaseFirestore.instance
        .collection('pharmacist')
        .doc(userId)
        .update({'userStatus': userStatus});
  }
  // get all messages
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(BuildContext context,
      {required String chatId}) {
    return FirebaseFirestore.instance
        .collection('messages')
        .doc(chatId)
        .collection(chatId)
        .orderBy("msgTime",descending: true)
        .snapshots();
  }

  // update last message
  void updateLastMessage({required chatId,required senderId,required receiverId,required receiverUsername,required msgTime,required msgType,required message,required context}){

    lastMessageForPeerUser(receiverId,senderId, chatId, context, receiverUsername, msgTime, msgType, message);
    lastMessageForCurrentUser(receiverId,senderId, chatId, context, receiverUsername, msgTime, msgType, message);

  }

  void lastMessageForCurrentUser(receiverId,senderId, chatId, context, receiverUsername, msgTime, msgType, message) {
    FirebaseFirestore.instance
        .collection("lastMessages")
        .doc(senderId)
        .collection(senderId)
        .where('chatId', isEqualTo: chatId)
        .get().then((QuerySnapshot value) {
      if(value.size == 0){
        FirebaseFirestore.instance
            .collection("lastMessages")
            .doc(senderId)
            .collection(senderId)
            .doc("${Timestamp.now().millisecondsSinceEpoch}")
            .set({
          'chatId': chatId,
          'messageFrom' :Provider.of<Localprovider>(context,listen: false).auth.currentUser!.displayName ,
          'messageTo' :receiverUsername ,
          'messageSenderId': senderId,
          'messageReceiverId': receiverId,
          'msgTime' : msgTime,
          'msgType':msgType,
          'message':message,
        });
      }else{
        FirebaseFirestore.instance
            .collection("lastMessages")
            .doc(senderId)
            .collection(senderId)
            .doc(value.docs[0].id)
            .update({
          'messageFrom' :Provider.of<Localprovider>(context,listen: false).auth.currentUser!.displayName ,
          'messageTo' :receiverUsername ,
          'messageSenderId': senderId,
          'messageReceiverId': receiverId,
          'msgTime' : msgTime,
          'msgType':msgType,
          'message':message,
        });
      }
    });
  }

  void lastMessageForPeerUser(receiverId,senderId, chatId, context, receiverUsername, msgTime, msgType, message) {
    FirebaseFirestore.instance
        .collection("lastMessages")
        .doc(receiverId)
        .collection(receiverId)
        .where('chatId', isEqualTo: chatId)
        .get().then((QuerySnapshot value) {
      if(value.size == 0){
        FirebaseFirestore.instance
            .collection("lastMessages")
            .doc(receiverId)
            .collection(receiverId)
            .doc("${Timestamp.now().millisecondsSinceEpoch}")
            .set({
          'chatId': chatId,
          'messageFrom' :Provider.of<Localprovider>(context,listen: false).auth.currentUser!.displayName ,
          'messageTo' :receiverUsername ,
          'messageSenderId': senderId,
          'messageReceiverId': receiverId,
          'msgTime' : msgTime,
          'msgType':msgType,
          'message':message,
        });
      }else{
        FirebaseFirestore.instance
            .collection("lastMessages")
            .doc(receiverId)
            .collection(receiverId)
            .doc(value.docs[0].id)
            .update({
          'messageFrom' :Provider.of<Localprovider>(context,listen: false).auth.currentUser!.displayName ,
          'messageTo' :receiverUsername ,
          'messageSenderId': senderId,
          'messageReceiverId': receiverId,
          'msgTime' : msgTime,
          'msgType':msgType,
          'message':message,
        });
      }
    });
  }

  // get all last messages
  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(BuildContext context, String myId) {
    return FirebaseFirestore.instance
        .collection('lastMessages')
        .doc(myId)
        .collection(myId)
        .orderBy("msgTime",descending: true)
        .snapshots();
  }

  UploadTask getRefrenceFromStorage(file,voiceMessageName, context){

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("Media")
    // ignore: use_build_context_synchronously
        .child(Provider.of<Localprovider>(context,listen: false).getChatId(context))
    // ignore: unrelated_type_equality_checks
        .child(file is File?voiceMessageName:file.runtimeType==FilePickerResult?file!.files.single.name:file!.name);
    return ref.putFile(file is File?file:File(file.runtimeType==FilePickerResult?file!.files.single.path:file.path));

  }

  UploadTask getRefFromStorageForUploadImages(file,voiceMessageName, context){

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("Media")
        .child(file is File?voiceMessageName:file.runtimeType==FilePickerResult?file!.files.single.name:file!.name);
    return ref.putFile(file is File?file:File(file.runtimeType==FilePickerResult?file!.files.single.path:file.path));

  }



}