import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mondaytest/Views/screens/screen_chat.dart';
import 'package:video_player/video_player.dart';
import '../../Models/message_model.dart';

class ScreenVideoViewer extends StatelessWidget {
  MessageModel message;

  @override
  Widget build(BuildContext context) {
    var logic =
        Get.put(ControllerVideoPlayer(path: message.text), tag: message.id);

    return Scaffold(
      body: Obx(() {
        return Center(
          child: (logic.videoController.value != null)
              ? GestureDetector(
                  onTap: () {
                    logic.playOrPause();
                  },
                  child: AspectRatio(
                    aspectRatio: logic.videoController.value!.value.aspectRatio,
                    child: VideoPlayer(
                      logic.videoController.value!,
                      key: Key(message.id),
                    ),
                  ),
                )
              : CircularProgressIndicator(),
        );
      }),
    );
  }

  ScreenVideoViewer({
    required this.message,
  });
}
