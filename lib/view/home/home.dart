import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_project/controllers/note_controler.dart';
import 'note_list.dart';
import 'add_note.dart';
import 'package:note_project/controllers/auth_controller.dart';
import 'app_drawer.dart';
import 'add_category.dart';
import 'package:note_project/controllers/draw_controller.dart';
import 'add_draw.dart';

class MyHomePage extends GetWidget<AuthController> {
  final AuthController authController = Get.find<AuthController>();
  final NoteController noteController =
      Get.put<NoteController>(NoteController());
  final DrawingController drawController = Get.put(DrawingController());
  final SearchController searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => searchController.isSearching.value
            ? _buildSearchField()
            : Text("Ghi chú", style: TextStyle(fontSize: 30))),
        actions: <Widget>[
          IconButton(
            icon: Obx(() => Icon(searchController.isSearching.value
                ? Icons.close
                : Icons.search)),
            onPressed: () {
              searchController.isSearching.toggle();
              if (!searchController.isSearching.value)
                noteController.searchQuery.value = "";
            },
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          child: Obx(() => Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            noteController.sortCheck.value = true;
                            noteController.sortByTitle.toggle();
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                              bottom: 5,
                              left: 10,
                              right: 10,
                              top: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Row(
                              children: [
                                Text('Tên',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary)),

                                Icon(
                                    noteController.sortByTitle.value
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary), // Icon
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            noteController.sortCheck.value = false;
                            noteController.sortByDate.toggle();
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                              bottom: 5,
                              left: 10,
                              right: 10,
                              top: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Row(
                              children: [
                                Text('Ngày',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary)),

                                Icon(
                                    noteController.sortByDate.value
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary), // Icon
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GetX<NoteController>(
                      builder: (NoteController noteController) {
                    if (noteController != null &&
                        noteController.notes != null) {
                      return NoteList();
                    } else {
                      print("khong co gi");
                      return Text("No notes, create some ");
                    }
                  }),
                ],
              )),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            tooltip: 'thêm ghi chú',
            heroTag: "thêm ghi chú",
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              Get.to(() => AddNotePage());
            },
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 30,
            ),
          ),
          // SizedBox(height: 10),
          // FloatingActionButton(
          //   tooltip: "thêm danh sách",
          //   heroTag: "thêm danh sách",
          //   backgroundColor: Theme.of(context).primaryColor,
          //   onPressed: () {
          //     Get.to(() => AddListPage());
          //   },
          //   child: Icon(
          //     Icons.playlist_add,
          //     color: Theme.of(context).colorScheme.onPrimary,
          //     size: 30,
          //   ),
          // ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "vẽ",
            tooltip: 'vẽ',
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              Get.to(() => AddDrawPage());
              // Thêm mã để chuyển sang trang vẽ
            },
            child: Icon(
              Icons.brush,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: TextEditingController(),
      //controller: searchController.searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Tìm theo tiêu đề',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white),
      ),
      style: TextStyle(color: Colors.white),
      onChanged: (query) {
        noteController.searchQuery.value = query;
      },
    );
  }
}

class SearchController extends GetxController {
  final TextEditingController searchQueryController = TextEditingController();
  var isSearching = false.obs;

  void toggleIsSearching() {
    isSearching.value = !isSearching.value;
  }
}
