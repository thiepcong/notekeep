import 'package:flutter/material.dart';
import 'package:note_project/controllers/auth_controller.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:note_project/models/note.dart';
import 'package:note_project/services/database.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:note_project/controllers/draw_controller.dart';
import 'edit_draw.dart';

class ShowNote extends StatelessWidget {
  final NoteModel noteData;
  final int index;
  ShowNote({required this.noteData, required this.index});
  final AuthController authController = Get.find<AuthController>();
  final RxString imageUrl = "".obs;
  final RxString paintUrl = "".obs;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final DrawingController drawController = Get.find<DrawingController>();
  bool check = false;

  @override
  Widget build(BuildContext context) {
    titleController.text = noteData.title;
    bodyController.text = noteData.body;
    if (noteData.imageUrl != null && noteData.imageUrl != "") {
      imageUrl.value = noteData.imageUrl!;
    }
    if (noteData.paintUrl != null && noteData.paintUrl != "") {
      paintUrl.value = noteData.paintUrl!;
      drawController.paintUrl.value = noteData.paintUrl!;
    } else
      drawController.paintUrl.value = "";

    var formattedDate =
        DateFormat.yMMMd().format(noteData.creationDate.toDate());
    var time = DateFormat.jm().format(noteData.creationDate.toDate());
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Chỉnh sửa ghi chú",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  Share.share('${noteData.title}\n${noteData.body}',
                      subject: noteData.title,
                      sharePositionOrigin:
                          box.localToGlobal(Offset.zero) & box.size);
                },
                icon: Icon(Icons.share)),
            IconButton(
              onPressed: () {
                showDeleteDialog(context, noteData);
              },
              icon: Icon(Icons.delete),
            ),
          ],
          backgroundColor: Theme.of(context).primaryColor,
        ),
        bottomNavigationBar: BottomNavigationBar(
          // backgroundColor: Them,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: 'Chụp hình ảnh',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.image),
              label: 'Thêm hình ảnh',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              label: 'Thêm âm thanh',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.brush),
              label: 'Vẽ',
            ),
          ],
          onTap: (int index) {
            switch (index) {
              case 0:
                captureImage(context);
                break;
              case 1:
                selectImage(context);
                break;
              case 2:
                // Xử lý khi người dùng chọn thêm âm thanh
                break;
              case 3:
                drawController.drawingPoints.clear();
                Get.to(() => EditDrawPage());
                break;
            }
          },
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(
              16.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Obx(() => (check)
                                ? (Image.file(File(imageUrl.value)))
                                : (((imageUrl.value != "")
                                    ? Image.network(
                                        imageUrl.value,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) =>
                                                loadingProgress == null
                                                    ? child
                                                    : Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                      )
                                    : (paintUrl.value != "")
                                        ? Image.network(
                                            paintUrl.value,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                    loadingProgress) =>
                                                loadingProgress == null
                                                    ? child
                                                    : Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                          )
                                        : SizedBox()))),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Xóa?"),
                                          content: Text(
                                              "Bạn có chắc chắn muốn xóa?"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: Text("Không"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                if (check) {
                                                  check = !check;
                                                  imageUrl.value = "";
                                                } else if (imageUrl.value !=
                                                    "") {
                                                  imageUrl.value == "";
                                                } else if (paintUrl.value !=
                                                    "") {
                                                  paintUrl.value == "";
                                                }
                                                Navigator.of(context).pop(true);
                                              },
                                              child: Text("Có"),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: Icon(Icons.clear),
                              ),
                            ),
                          ],
                        ),
                        Text("$formattedDate at $time"),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: titleController,
                          maxLines: null,
                          decoration: InputDecoration.collapsed(
                            hintText: "Tiêu đề ghi chú",
                          ),
                          style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          autofocus: true,
                          controller: bodyController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration.collapsed(
                            hintText: "Nhập nội dung nào đó ...",
                          ),
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            saveNote(context);
          },
          label: Text("Lưu"),
          icon: Icon(Icons.save),
        ));
  }

  void saveNote(BuildContext context) async {
    if (titleController.text == noteData.title &&
        bodyController.text == noteData.body &&
        imageUrl.value == noteData.imageUrl) {
      showSameContentDialog(context);
    } else {
      if (check)
        Database().updateNote(
            authController.user!.uid,
            titleController.text,
            bodyController.text,
            noteData.id,
            File(imageUrl.value),
            null,
            drawController.paint);
      else
        Database().updateNote(authController.user!.uid, titleController.text,
            bodyController.text, noteData.id, null, null, drawController.paint);
      // Get.off(() => BottomBar(), transition: Transition.fadeIn);
      Get.back();
      titleController.clear();
      bodyController.clear();
      imageUrl.value = "";
    }
  }

  Future<void> selectImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageUrl.value = pickedFile.path;
      check = true;
      print(imageUrl.value);
    }
  }

  Future<void> captureImage(BuildContext context) async {
    final ImagePicker imagePicker = ImagePicker();

    final pickedFile = await imagePicker.getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      imageUrl.value = pickedFile.path;
      check = true;
    }
  }
}

void showDeleteDialog(BuildContext context, noteData) {
  final AuthController authController = Get.find<AuthController>();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(
          "Xóa ghi chú?",
          style: Theme.of(context).textTheme.headline6,
        ),
        content: Text("Bạn có chắc muốn xóa ghi chú này?",
            style: Theme.of(context).textTheme.subtitle1),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Xóa",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            onPressed: () {
              Get.back();
              Database().delete(authController.user!.uid, noteData.id);
              Get.back(closeOverlays: true);
            },
          ),
          TextButton(
            child: Text(
              "Quay lại",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showSameContentDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(
          "Không có gì thay đổi!",
          style: Theme.of(context).textTheme.headline6,
        ),
        content: Text("Nội dung chưa thay đổi gì.",
            style: Theme.of(context).textTheme.subtitle1),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Quay lại",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      );
    },
  );
}
