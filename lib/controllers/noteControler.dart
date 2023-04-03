import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_project/models/note.dart';
import 'package:note_project/services/database.dart';
import 'package:note_project/controllers/authController.dart';

class NoteController extends GetxController {
  RxList<NoteModel> noteList = RxList<NoteModel>();
  Rx<TextEditingController> titleController = TextEditingController().obs;
  Rx<TextEditingController> bodyController = TextEditingController().obs;
  RxString searchQuery = "".obs;
  List<NoteModel> get notes {
    if (searchQuery.value.isNotEmpty) {
      return getSortedNotes()
          .where((note) => note.title
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()))
          .toList();
    } else {
      return getSortedNotes();
    }
  }
  //xu ly sap xep
  List<NoteModel> getSortedNotes() {
    var sortedNotes = noteList.value;
    if (sortCheck.value) {
      if (sortByTitle.value) {
        sortedNotes.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      } else {
        sortedNotes.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
      }
    } else {
      if (sortByDate.value) {
        sortedNotes.sort((a, b) => a.creationDate.compareTo(b.creationDate));
      } else {
        sortedNotes.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      }
    }
    return sortedNotes;
  }

  var sortByTitle = false.obs;
  var sortByDate = false.obs;
  var sortCheck = false.obs;
  void toggleSortByTitle() {
    sortByTitle.value = !sortByTitle.value;
  }

  void toggleSortByDate() {
    sortByTitle.value = !sortByTitle.value;
  }
  //end xu ly sap xep

  @override
  void onInit() {
    String? uid = Get.find<AuthController>().user?.uid;
    print("NoteController onit :: $uid");
    noteList.bindStream(Database().noteStream(uid!));
    super.onInit();
  }
}
