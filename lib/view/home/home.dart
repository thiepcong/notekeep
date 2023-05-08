import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_project/controllers/note_controler.dart';
import 'note_list.dart';
import 'add_note.dart';
import 'package:note_project/controllers/auth_controller.dart';
import 'app_drawer.dart';
import 'package:flutter/foundation.dart';

class MyHomePage extends GetWidget<AuthController> {
  final AuthController authController = Get.find<AuthController>();
  final NoteController noteController = Get.put(NoteController());
  final SearchController searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    // final platform = TargetPlatform.
    if (defaultTargetPlatform == TargetPlatform.android)
      return Scaffold(
        appBar: AppBar(
          title: Obx(() => searchController.isSearching.value
              ? _buildSearchField(context)
              : const Text("Ghi chú", style: TextStyle(fontSize: 30))),
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
            padding: const EdgeInsets.symmetric(
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
                              padding: const EdgeInsets.only(
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
                    const SizedBox(
                      height: 20,
                    ),
                    GetX<NoteController>(
                        builder: (NoteController noteController) {
                      if (noteController != null &&
                          noteController.notes != null) {
                        return NoteList();
                      } else {
                        print("khong co gi");
                        return Text("Không có ghi chú");
                      }
                    }),
                  ],
                )),
          ),
        ),
        floatingActionButton: FloatingActionButton(
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
      );
    else
      return Scaffold(
        appBar: AppBar(
          title: const Text("Ghi chú", style: TextStyle(fontSize: 30)),
          actions: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: TextField(
                        controller: TextEditingController(),
                        //controller: searchController.searchQueryController,
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 24,
                          ),
                          filled: true,
                          fillColor: Theme.of(context).indicatorColor,
                          contentPadding: EdgeInsets.all(8.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            // đổi viền khi ô input được focus
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 24,
                        ),
                        onChanged: (query) {
                          noteController.searchQuery.value = query;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          backgroundColor: Theme.of(context).primaryColor,
        ),
        drawer: AppDrawer(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
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
                              padding: const EdgeInsets.only(
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
                    const SizedBox(
                      height: 20,
                    ),
                    GetX<NoteController>(
                        builder: (NoteController noteController) {
                      if (noteController != null &&
                          noteController.notes != null) {
                        return NoteList();
                      } else {
                        print("khong co gi");
                        return Text("Không có ghi chú");
                      }
                    }),
                  ],
                )),
          ),
        ),
        floatingActionButton: FloatingActionButton(
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
      );
  }

  Widget _buildSearchField(BuildContext context) {
    return TextField(
      controller: TextEditingController(),
      //controller: searchController.searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Tìm theo tiêu đề',
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 24,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.onBackground,
        contentPadding: EdgeInsets.all(8.0),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          // đổi viền khi ô input được focus
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      style: TextStyle(
        // color: Theme.of(context).colorScheme.onPrimary,
        fontSize: 24,
      ),
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
