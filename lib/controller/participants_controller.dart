import 'package:get/get.dart';

import '../Models/Student.dart';
import '../helper/constants.dart';

class ParticipantsController extends GetxController {
  RxList<Student> studentsList = RxList([]);
  RxList<Student> selectedStudents = RxList([]);
  List<String> alreadySelected;

  @override
  void onInit() {
    initValues();
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

  void initValues() async {
    await usersRef.get().then((value) {
      studentsList.value = value.docs.map((e) => Student.fromMap(e.data() as Map<String, dynamic>)).toList();
      studentsList.removeWhere((element) => element.id == currentUser!.uid);
    });

    selectedStudents.value = studentsList.where((e) => alreadySelected.contains(e.id)).toList();
  }

  ParticipantsController({
    this.alreadySelected = const [],
  });
}
