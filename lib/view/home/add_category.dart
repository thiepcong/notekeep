import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_project/controllers/auth_controller.dart';
import 'package:note_project/controllers/note_controler.dart';
import 'package:note_project/models/note.dart';
import 'package:note_project/services/database.dart';

class AddListPage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final NoteController noteController = Get.find<NoteController>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final List<Widget> categoryFields = [];
  final ScrollController scrollController = ScrollController();

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
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
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
              Column(
                children: [
                  TextFormField(
                    controller: categoryController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration.collapsed(
                      hintText: "Nhập danh mục",
                    ),
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                    onFieldSubmitted: (value) {
                      if (value.isNotEmpty) {
                        addCategoryField();
                      }
                    },
                  ),
                  Column(
                    children: categoryFields,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "Lưu",
        onPressed: () async {
          saveNote(context);
        },
        tooltip: "Lưu",
        child: Icon(
          Icons.save,
          size: 30,
        ),
      ),
    );
  }

  void addCategoryField() {
    final TextEditingController newCategoryController = TextEditingController();
    categoryFields.add(
      TextFormField(
        controller: newCategoryController,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration.collapsed(
          hintText: "Nhập danh mục",
        ),
        style: TextStyle(
          fontSize: 20.0,
        ),
        onFieldSubmitted: (value) {
          if (value.isNotEmpty) {
            addCategoryField();
          }
        },
      ),
    );
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void saveNote(BuildContext context) {
    if (titleController.text.isEmpty) {
      showEmptyTitleDialog(context);
      return;
    }
    Database().addNote(authController.user!.uid,
        titleController.value.text.trim(), "", null, null, null);
    Get.back();
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
