
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:record/record.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mondaytest/helper/constants.dart';
import 'package:mondaytest/helper/firebase_helpers.dart';
import 'package:video_player/video_player.dart';

import '../Models/Student.dart';
import '../Models/message_model.dart';
import '../helper/Fcm.dart';

class ChatController extends GetxController {

  var isEmojiVisible = false.obs;
  FocusNode focusNode = FocusNode();
  var textEditingController = TextEditingController();
  String receiver_id;
  Rx<Student?> receiverObservable = Rx(null);
  RxString videoPath = "".obs;

  @override
  void onInit() {
    super.onInit();
    audioPlayer = AudioPlayer();
    audioRecording = Record();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isEmojiVisible.value = false;
      }
    });
    updateParticipants();
    startReceiverStream();
    startOnlineStatusStream();
  }

  @override
  void onClose() {
    super.onClose();
    // audioPlayer.dispose();
    // audioRecording.dispose();
    textEditingController.dispose();
  }


  ChatController({
    required this.receiver_id,

  });

  void startReceiverStream() {
    usersRef.doc(receiver_id).snapshots().listen((event) {
      receiverObservable.value = Student.fromMap(event.data() as Map<String, dynamic>);
    });
  }

  void startOnlineStatusStream () {
    Timer.periodic(Duration(seconds: 1), (timer) {
      update();
    });
  }

  void sendMessage(String text, {String type = 'text'}) async {
    if (text.isNotEmpty) {
      FCM.sendMessageSingle(
        currentUser!.displayName ?? "New Message",
        type == 'text' ? text : (type == 'image' ? 'image' : 'video'),
        receiverObservable.value?.token ?? "",
        {},
      );

      var timestamp = DateTime.now().millisecondsSinceEpoch;

      var message = MessageModel(
          id: timestamp.toString(),
          text: text,
          sender_id: currentUser!.uid,
          timestamp: timestamp,
          receiver_id: receiver_id,
          message_type: type
      );

      var roomPath = chatsRef.child(getRoomId(receiver_id, currentUser!.uid));

      roomPath.update({
        'lastMessage': jsonEncode(message.toMap())
      });
      roomPath.child("messages").child(timestamp.toString()).set(message.toMap());
      textEditingController.clear();
    }

  }

  String getRoomId(String user1, String user2) {
    var merge = "$user1$user2";
    var charList = merge.split('');
    charList.sort((a, b) => a.compareTo(b));
    return charList.join();
  }

  void pickImage() async {
    var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null){
      var file = File(pickedFile.path);
      var url = await FirebaseStorageUtils.uploadImage(file, 'chats/${getRoomId(receiver_id, currentUser!.uid)}', DateTime.now().millisecondsSinceEpoch.toString());
      sendMessage(url, type: 'image');
    }
  }



  Future<void> pickVideo( ImageSource type) async {
    final picker = ImagePicker();
    final pickedVideo = await picker.pickVideo(source: type );
    videoPath.value = pickedVideo!.path;
    // if (pickedVideo != null) {
    //   // videoController = VideoPlayerController.file(File(pickedVideo.path))
    //   // ..initialize().then((_){
    //   // });
    // }

  }








  void updateParticipants() async {
    var id = getRoomId(currentUser!.uid, receiver_id);
    chatsRef.child(id).update({
      'participants': [currentUser!.uid, receiver_id],
      'id': id,
      'name': 'Name',
      'roomType': 'chat'
    });
  }








  // audio work


  late AudioPlayer audioPlayer;
  late Record audioRecording;
  RxBool isRecording = false.obs;
  String audioPath = '';
  Timer? recordingTimer;
  int secondsElapsed = 0;


  Future<void> startRecording() async {
    try {
      if (await audioRecording.hasPermission()) {
        await audioRecording.start();
        update();
        isRecording.value = true;

        // Start the recording timer
        recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
          update();
          secondsElapsed += 1;
        });
      }
    } catch (e) {
      print('Error in recording audio, $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecording.stop();
      update();
      isRecording.value = false;
      audioPath = path!;
      recordingTimer?.cancel();
      secondsElapsed = 0;
      var url=await FirebaseStorageUtils.uploadImage(File(path.toString()), path, "");
      sendMessage(url,type: "voice");


    } catch (e) {
      print('error in stop recording, $e');
    }
  }

  Future<void> playRecording(String url) async {
    try {
      Source sourceUrl = UrlSource(url);
      await audioPlayer.play(sourceUrl);
    }
    catch (e) {
      print('error in play recording, $e');
    }
  }
}
