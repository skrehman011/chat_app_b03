import 'package:get/get.dart';
import 'package:mondaytest/Models/group_info.dart';
import 'package:mondaytest/helper/constants.dart';

import '../Models/Student.dart';

class NewGroupController extends GetxController {
  RxList<Student> studentsList = RxList([]);
  RxList<Student> selectedStudents = RxList([]);
  RxBool createGroupLoading = false.obs;

  @override
  void onInit() {
    usersRef.get().then((value) {
      studentsList.value = value.docs
          .map((e) => Student.fromMap(e.data() as Map<String, dynamic>))
          .toList();
      studentsList.removeWhere((element) => element.id == currentUser!.uid);
    });
    super.onInit();
  }

  void addToSelected(Student student) {
    if (selectedStudents.contains(student)) {
      selectedStudents.remove(student);
    } else {
      selectedStudents.add(student);
    }
  }

  void removeSelected(Student student) {
    selectedStudents.remove(student);
  }

  Future<void> createGroup(String name) async {
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
