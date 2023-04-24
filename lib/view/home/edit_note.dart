import 'package:flutter/material.dart';
import 'package:note_project/controllers/auth_controller.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:note_project/models/note.dart';
import 'package:note_project/services/database.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:note_project/view/home/add_audio.dart';
import 'package:note_project/controllers/draw_controller.dart';
import 'package:note_project/controllers/audio_controller.dart';
import 'edit_draw.dart';

class ShowNote extends StatelessWidget {
  final NoteModel noteData;
  final int index;
  ShowNote({required this.noteData, required this.index});
  final AuthController authController = Get.find<AuthController>();
  final RxString imageUrl = "".obs;
  final RxString paintUrl = "".obs;
  final RxString audioUrl = "".obs;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  AudioController audioController = Get.put(AudioController());
  final DrawingController drawController = Get.put(DrawingController());
  bool checkIn = false;
  bool isDeletepaint = false;
  bool isDeleteaudio = false;

  @override
  Widget build(BuildContext context) {
    titleController.text = noteData.title;
    bodyController.text = noteData.body;
    if (noteData.imageUrl != null && noteData.imageUrl != "") {
      imageUrl.value = noteData.imageUrl!;
    }
    if (drawController.paintUrl.value != null &&
        drawController.paintUrl.value != "")
      paintUrl.value = drawController.paintUrl.value;
    else if (noteData.paintUrl != null && noteData.paintUrl != "") {
      paintUrl.value = noteData.paintUrl!;
      drawController.paintUrl.value = noteData.paintUrl!;
    }

    if (noteData.audioUrl != null && noteData.audioUrl != "") {
      audioUrl.value = noteData.audioUrl!;
      print("audio file: " + noteData.audioUrl!);
      audioController.urlAudioTmp.value = noteData.audioUrl!;
    }

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
          type: BottomNavigationBarType.fixed,
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
                Get.to(() => AddAudio());
                break;
              case 3:
                drawController.clear();
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
                        Text("$formattedDate at $time"),
                        SizedBox(
                          height: 10,
                        ),
                        Stack(
                          children: [
                            Obx(() {
                              if (checkIn)
                                return Image.file(File(imageUrl.value));
                              else if (imageUrl.value != "")
                                return Image.network(
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
                                );
                              else
                                return SizedBox();
                            }),
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
                                                imageUrl.value = "";
                                                checkIn = false;
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
                        Stack(
                          children: [
                            Obx(() => (paintUrl.value != "")
                                ? Image.network(
                                    (drawController.paintUrl.value == "")
                                        ? paintUrl.value
                                        : drawController.paintUrl.value,
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
                                : SizedBox()),
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
                                                isDeletepaint = true;
                                                paintUrl.value = "";
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
                        SizedBox(
                          height: 32,
                        ),
                        Obx(() => (audioUrl.value != "")
                            ? Container(
                                color: Colors.green,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    LinearProgressIndicator(
                                      value: audioController.progress.value,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () async {
                                              if (!audioController
                                                  .isPlaying.value)
                                                await audioController
                                                    .startPlayerFromURL(
                                                        audioController
                                                            .urlAudioTmp.value);
                                              else {
                                                await audioController
                                                    .pausePlayer();
                                              }
                                            },
                                            icon: Icon((!audioController
                                                    .isPlaying.value)
                                                ? Icons.play_arrow
                                                : Icons.pause)),
                                        IconButton(
                                            onPressed: () {
                                              audioController.stopPlayer();
                                            },
                                            icon: Icon(Icons.stop)),
                                        IconButton(
                                            onPressed: () async {
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
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(false),
                                                          child: Text("Không"),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            isDeleteaudio =
                                                                true;
                                                            audioUrl.value = "";
                                                            Navigator.of(
                                                                    context)
                                                                .pop(true);
                                                          },
                                                          child: Text("Có"),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                            icon: Icon(Icons.close)),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox())
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
      if (isDeletepaint) drawController.paint.value = null;
      if (isDeleteaudio) audioController.audioFile.value = null;
      if (checkIn || imageUrl.value != "")
        Database().updateNote(
            authController.user!.uid,
            titleController.text,
            bodyController.text,
            noteData.id,
            File(imageUrl.value),
            audioController.audioFile.value,
            drawController.paint.value);
      else
        Database().updateNote(
            authController.user!.uid,
            titleController.text,
            bodyController.text,
            noteData.id,
            null,
            audioController.audioFile.value,
            drawController.paint.value);
      Get.back();
      titleController.clear();
      bodyController.clear();
      imageUrl.value = "";
      paintUrl.value = "";
      audioUrl.value = "";
    }
  }

  Future<void> selectImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageUrl.value = pickedFile.path;
      checkIn = true;
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
      checkIn = true;
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
