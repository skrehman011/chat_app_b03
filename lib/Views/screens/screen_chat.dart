import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mondaytest/Models/message_model.dart';
import 'package:mondaytest/Models/user_model.dart';
import 'package:mondaytest/helper/Fcm.dart';

import '../../helper/constants.dart';

class ScreenChat extends StatelessWidget {
  UserModel receiver;
  var inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiver.id),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<DatabaseEvent>(
                  stream: chatsRef
                      .child(getRoomId(receiver.id, currentUser!.uid))
                      .onValue,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    var data = snapshot.data;

                    if (data == null || data.snapshot.value == null) {
                      return Center(
                        child: Text("No messages yet"),
                      );
                    }

                    List<MessageModel> messages = data.snapshot.children
                        .map((e) => MessageModel.fromMap(
                            Map<String, dynamic>.from(e.value as Map)))
                        .toList();

                    return messages.isNotEmpty
                        ? ListView.builder(
                            itemCount: messages.length,
                            itemBuilder: (BuildContext context, int index) {
                              var message = messages[index];

                              return ListTile(
                                title: Text(message.text),
                                subtitle: Text(message.sender_id == currentUser!.uid ? "You" : "Other"),
                                trailing: Text(DateFormat("hh:mm").format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        message.timestamp))),
                              );
                            },
                          )
                        : Center(
                            child: Text("No messages"),
                          );
                  })),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration:
                      InputDecoration(hintText: "Write message here..."),
                  controller: inputController,
                ),
              ),
              FloatingActionButton(
                onPressed: () async {
                  FCM.sendMessageSingle(
                      "New message", inputController.text, receiver.token, {});

                  var timestamp = DateTime.now().millisecondsSinceEpoch;

                  var message = MessageModel(
                      id: timestamp.toString(),
                      text: inputController.text,
                      sender_id: currentUser!.uid,
                      timestamp: timestamp);

                  chatsRef
                      .child(getRoomId(receiver.id, currentUser!.uid))
                      .child(timestamp.toString())
                      .set(message.toMap());

                  inputController.clear();
                },
                child: Icon(Icons.send),
              )
            ],
          )
        ],
      ),
    );
  }

  String getRoomId(String user1, String user2) {
    var merge = "$user1$user2";
    var charList = merge.split('');
    charList.sort((a, b) => a.compareTo(b));
    return charList.join();
  }

  ScreenChat({
    required this.receiver,
  });
}
