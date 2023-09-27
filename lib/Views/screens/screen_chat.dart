import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mondaytest/Models/message_model.dart';
import 'package:mondaytest/Views/screens/screen_image_view.dart';
import 'package:mondaytest/controller/chat_controller.dart';
import 'package:mondaytest/controller/grop_chat_controller.dart';
import 'package:mondaytest/helper/constants.dart';
import 'package:mondaytest/helper/firebase_helpers.dart';
import 'package:record/record.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../Models/Student.dart';
import '../../controller/RegistrationController.dart';

class ScreenChat extends StatefulWidget {
  Student receiver;


  @override
  State<ScreenChat> createState() => _ScreenChatState();





  ScreenChat({
  required this.receiver,
  });
}

class _ScreenChatState extends State<ScreenChat> {

   // GroupChatController groupChatController = Get.put(GroupChatController(group_id: ''));
  RecorderController controller = RecorderController(); // Initialise



  late AudioPlayer audioPlayer;
  late Record audioRecording;
  bool isRecording = false;
  String audioPath = '';
  Timer? recordingTimer;
  int secondsElapsed = 0;





  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioRecording = Record();
    super.initState();
  }


  @override
  void dispose() {
    audioPlayer.dispose();
    audioRecording.dispose();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    ChatController chatController =
    Get.put(ChatController(receiver_id: widget.receiver.id));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: ListTile(
          title: Text(
            widget.receiver.name,
            style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold),
          ),
          subtitle: GetBuilder<ChatController>(
              init: chatController,
              builder: (logic) {
                return Text(formatRelativeTime(
                    chatController.receiverObservable.value?.lastSeen ?? 0));
              }),
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        actions: [
          Container(
            width: Get.width * .3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.missed_video_call_rounded, color: Colors.black,
                  size: 32,),
                Icon(Icons.call, color: Colors.black,),
                Icon(Icons.more_vert, color: Colors.black,)
              ],
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        child: WillPopScope(
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder<DatabaseEvent>(
                      stream: chatsRef
                          .child(chatController.getRoomId(
                          widget.receiver.id, currentUser!.uid))
                          .child("messages")
                          .onValue,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                            .map((e) =>
                            MessageModel.fromMap(
                                Map<String, dynamic>.from(e.value as Map)))
                            .toList();

                        return messages.isNotEmpty
                            ? ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (BuildContext context, int index) {
                            var message = messages[index];

                            return Align(
                              alignment:
                              message.sender_id == currentUser!.uid
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                padding: EdgeInsets.only(
                                    bottom: 5,
                                    top: 5,
                                    left: 10,
                                    right: 5),
                                margin: EdgeInsets.only(bottom: 10),
                                width: Device.width * .67,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: message.sender_id ==
                                        currentUser!.uid
                                        ? Radius.circular(0)
                                        : Radius.circular(20),
                                    topLeft: message.sender_id ==
                                        currentUser!.uid
                                        ? Radius.circular(20)
                                        : Radius.circular(0),
                                    bottomLeft: message.sender_id ==
                                        currentUser!.uid
                                        ? Radius.circular(0)
                                        : Radius.circular(20),
                                    bottomRight: message.sender_id ==
                                        currentUser!.uid
                                        ? Radius.circular(20)
                                        : Radius.circular(0),
                                  ),
                                  color: message.sender_id ==
                                      currentUser!.uid
                                      ? Colors.greenAccent.withOpacity(.7)
                                      : Colors.grey.withOpacity(.3),
                                ),
                                child: ListTile(
                                  title: message.message_type == 'text'
                                      ? Text(message.text)
                                      : GestureDetector(
                                    onTap: () {
                                      Get.to(ScreenImageView(
                                          url: message.text));
                                    },
                                    child: Image.network(
                                      message.text,
                                    ),
                                  ),
                                  subtitle: Text(message.sender_id ==
                                      currentUser!.uid
                                      ? "You"
                                      : widget.receiver.name),
                                  trailing: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        DateFormat("hh:mm").format(DateTime
                                            .fromMillisecondsSinceEpoch(
                                            message.timestamp)),
                                      ),
                                    ],
                                  ),
                                ),
                              ).paddingOnly(
                                left: 15,
                                right: 15,
                              ),
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
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 0.1, color: Colors.black)),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              chatController.isEmojiVisible.value =
                              !chatController.isEmojiVisible.value;
                              chatController.focusNode.unfocus();
                              chatController.focusNode.canRequestFocus = true;
                            },
                            icon: Icon(Icons.emoji_emotions_rounded),
                            highlightColor: Colors.transparent,
                            // Set highlight color to transparent
                            splashColor: Colors
                                .transparent, // Set splash color to transparent
                          ),
                          Expanded(
                            child: TextFormField(
                              focusNode: chatController.focusNode,
                              decoration: InputDecoration(
                                hintText: "Write message here...",
                                border: InputBorder.none,
                              ),
                              maxLines: null,
                              controller: chatController.textEditingController,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              chatController.pickImage();
                            },
                            icon: Icon(Icons.camera_alt),
                            highlightColor: Colors.transparent,
                            // Set highlight color to transparent
                            splashColor: Colors
                                .transparent, // Set splash color to transparent
                          ),
                        ],
                      ),
                    ),
                  ),

                  GestureDetector(
                    // onLongPress: () {
                    //   showModalBottomSheet(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return StatefulBuilder(
                    //         builder: (BuildContext context, StateSetter setState) {
                    //           return Container(
                    //             padding: EdgeInsets.all(16.0),
                    //             height: 300.0, // Customize the height as needed
                    //             child: Column(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: [
                    //                 if(isRecording)
                    //                   Text('Recording in Progress'),
                    //                 SizedBox(height: 10,),
                    //                 Row(
                    //                   children: [
                    //                     Divider(
                    //                       color: Colors.grey,
                    //                       thickness: 4,
                    //                     ),
                    //                     FloatingActionButton(
                    //                         highlightElevation: 0,
                    //                         splashColor: Colors.transparent,
                    //                         mini: true,
                    //                         onPressed: () async {
                    //                           chatController.sendMessage(chatController.textEditingController.text);
                    //                         },
                    //                         child:  isRecording ? Icon(Icons.mic, size: 22): Icon(Icons.send, size: 22)
                    //                     ),
                    //                   ],
                    //                 ),
                    //                 Text('00:00')
                    //               ],
                    //             ),
                    //           );
                    //         },
                    //       );
                    //     },
                    //   );
                    // },
                    onLongPress: isRecording ? chatController.stopRecording : chatController.startRecording,
                    child: FloatingActionButton(
                      highlightElevation: 0,
                      splashColor: Colors.transparent,
                      mini: true,
                      onPressed: () async {
                        chatController.sendMessage(chatController.textEditingController.text);
                      },
                      child: Icon(Icons.send, size: 22)
                    ),
                  ),


                ],
              ).paddingOnly(left: 10, right: 10),
              Obx(() {
                return Offstage(
                  offstage: !chatController.isEmojiVisible.value,
                  child: SizedBox(
                    height: 42.h,
                    child: EmojiPicker(
                      onEmojiSelected: (Category? category, Emoji emoji) {
                        chatController.textEditingController.text =
                            chatController.textEditingController.text +
                                emoji.emoji;
                      },
                      // onBackspacePressed: () {},
                      config: Config(
                        columns: 8,
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        gridPadding: EdgeInsets.zero,
                        initCategory: Category.RECENT,
                        bgColor: Colors.white,
                        indicatorColor: Colors.blue,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue,
                        backspaceColor: Colors.blue,
                        skinToneDialogBgColor: Colors.white,
                        skinToneIndicatorColor: Colors.grey,
                        enableSkinTones: true,
                        recentTabBehavior: RecentTabBehavior.RECENT,
                        recentsLimit: 28,
                        noRecents: const Text(
                          'No Recent',
                          style: TextStyle(fontSize: 20, color: Colors.black26),
                          textAlign: TextAlign.center,
                        ),
                        // Needs to be const Widget
                        loadingIndicator: const SizedBox.shrink(),
                        // Needs to be const Widget
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: const CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL,
                      ),
                    ),
                  ),
                );
              })
            ],
          ),
          onWillPop: () {
            if (chatController.isEmojiVisible.value) {
              chatController.isEmojiVisible.value = false;
            } else {
              Navigator.canPop(context);
            }
            return Future.value(false);
          },
        ),
      ),
    );
  }

  String formatRelativeTime(int millisecondsSinceEpoch) {
    final now = DateTime.now();
    final timestamp =
    DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    final difference = now.difference(timestamp);

    if (millisecondsSinceEpoch == 0) {
      return 'loading...';
    }

    if (difference.inSeconds <= 10) {
      return "Online";
    }

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} sec ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months months ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years years ago';
    }
  }


}
