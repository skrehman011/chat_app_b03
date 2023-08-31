import 'package:get/get.dart';
import 'package:mondaytest/Models/group_info.dart';
import 'package:mondaytest/helper/constants.dart';

import '../Models/Student.dart';

class NewGroupController extends GetxController {
  RxBool createGroupLoading = false.obs;


  Future<void> createGroup(String name, List<Student> selectedStudents) async {
    if (name.isEmpty) {
      return;
    }

    String id = "group_${DateTime.now().microsecondsSinceEpoch}";
    createGroupLoading.value = true;
    await chatsRef.child(id).set(RoomInfo(
            id: id,
            name: name,
            participants: [
              ...selectedStudents.map((element) => element.id).toList(),
              currentUser!.uid
            ],
            groupAdmin: currentUser!.uid,
            roomType: 'group')
        .toMap());
    createGroupLoading.value = false;
  }
}
