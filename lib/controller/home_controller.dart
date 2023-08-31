import 'package:get/get.dart';

import '../Models/group_info.dart';
import '../helper/constants.dart';

class HomeController extends GetxController {
  RxList<RoomInfo> chatsList = RxList([]);
  RxString _selectedId = ''.obs;
  Rx<RoomInfo?> selectedRoomInfo = Rx(null);

  @override
  void onInit() {
    startChatStream();
    _selectedId.listen((latestId) {
      chatsList.forEach((e) {
        if (e.id == latestId){
          selectedRoomInfo.value = e;
        }
      });
    });
    super.onInit();
  }

  void startChatStream() async {
    chatsRef.onValue.listen((event) {
      chatsList.value = event.snapshot.children.map((e) => RoomInfo.fromMap(Map<String, dynamic>.from(e.value as Map))).toList();
      chatsList.removeWhere(
              (element) => !element.participants.contains(currentUser!.uid));
      chatsList.forEach((element) {
        if (element.id == _selectedId.value){
          selectedRoomInfo.value = element;
        }
      });
    });
  }


  void setSelectedId(String id) {
    _selectedId.value = id;
  }
}
