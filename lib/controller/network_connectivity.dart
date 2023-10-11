import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkConnectivity extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;


  @override
  void onInit() {
    super.onInit();

   _connectivitySubscription =
       _connectivity.onConnectivityChanged.listen(_updateNetwork);
  }

  void _updateNetwork(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      Get.defaultDialog(
          barrierDismissible: false,
          title: 'Check Your Connection',
          titleStyle: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black),
          content: Center(
              child: Text(
            'Check your connection \n       '
                '   and refresh',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: Colors.black,
            ),
          )),
          actions: [
            Container(
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(0),
              width: Get.width,
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Refresh',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  )),
            )
          ]);
    } else {
      return Get.back();
    }
  }

  
  
  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
  
  
  // @override
  // void onClose() {
  //   super.onClose();
  // }
}


