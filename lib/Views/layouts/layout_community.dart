import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mondaytest/Views/screens/screen_all_users.dart';

class LayoutCommunity extends StatelessWidget {
  const LayoutCommunity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No Community'),
            ElevatedButton(
              onPressed: (){
                Get.to(ScreenAllUsers());
              },
              child: Text('Create Community'),

            )
          ],
        )
      ),
    );
  }
}
