

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy/Provider/local_provider.dart';
import 'package:healthy/firbase_helper/firebase_helper.dart';
import 'package:healthy/widget/message_tile.dart';
import 'package:provider/provider.dart';

class DoctorsRecentChats extends StatelessWidget {

 const  DoctorsRecentChats({super.key, });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius:const BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5.0)
        ),
        child: StreamBuilder(
          stream: FireBaseHelper().getLastMessages(
              context,
              Provider.of<Localprovider>(context, listen: false)
                  .auth
                  .currentUser!
                  .uid),
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
            return snapshot.data!.size == 0?
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [

                Center(child: Text('No messages start to chat with someone')),
              ],
            ):
            ListView.builder(
              physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index){
                  return InkWell(
                    onTap: (){
                      Provider.of<Localprovider>(context,listen: false).doctorRecentChatClickListener(snapshot, index, context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MessageTile(snapshot.data!.docs[index]),
                    ),
                  );
                }
            );
          },
        )
      ),
    );
  }
}