import 'package:flutter/material.dart';
import 'package:note_project/controllers/authController.dart';
import 'package:note_project/models/note.dart';
import 'package:note_project/services/database.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'dart:ui';

class ShowNote extends StatelessWidget {
  final NoteModel noteData;
  final int index;
  ShowNote({required this.noteData, required this.index});
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = noteData.title;
    bodyController.text = noteData.body;
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
            if (titleController.text != noteData.title ||
                bodyController.text != noteData.body) {
              Database().updateNote(authController.user!.uid,
                  titleController.text, bodyController.text, noteData.id);
              Get.back();
              titleController.clear();
              bodyController.clear();
            } else {
              showSameContentDialog(context);
            }
          },
          label: Text("Lưu"),
          icon: Icon(Icons.save),
        ));
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
