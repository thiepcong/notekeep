import 'package:flutter/material.dart';
import 'package:note_project/controllers/authController.dart';
import 'package:note_project/controllers/userController.dart';
import 'package:note_project/services/database.dart';
import 'package:get/get.dart';
import 'package:note_project/view/home/home.dart';

class AddNotePage extends StatelessWidget {
  final UserController userController = Get.find<UserController>();
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thêm ghi chú",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Container(
          height: size.height,
          padding: EdgeInsets.all(
            16.0,
          ),
          child: Column(children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      maxLines: null,
                      autofocus: true,
                      controller: titleController,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
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
                      controller: bodyController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration.collapsed(
                        hintText: "Nhập nội dung nào đó ... ",
                      ),
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "Lưu",
        onPressed: () {
          if (titleController.text.length == 0 &&
              bodyController.text.length == 0) {
            showEmptyTitleDialog(context);
          } else {
            Database().addNote(authController.user!.uid, titleController.text,
                bodyController.text);
            Get.back();
          }
        },
        tooltip: "Lưu",
        child: Icon(
          Icons.save,
          size: 30,
        ),
      ),
    );
  }
}

void showEmptyTitleDialog(BuildContext context) {
  print("in dialog ");
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        title: Text(
          "Ghi chú trống!",
          style: Theme.of(context).textTheme.headline6,
        ),
        content: Text(
          'Nội dung ghi chú không được trống.',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Okay",
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
