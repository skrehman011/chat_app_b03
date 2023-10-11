import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mondaytest/controller/network_connectivity.dart';

class DependencyInjection {

  static void init(){
    Get.put<NetworkConnectivity>(NetworkConnectivity(), permanent: true);
  }
}