import 'package:flutter/material.dart';
import 'package:note_project/controllers/auth_controller.dart';
import 'package:note_project/controllers/note_controler.dart';
import 'package:note_project/services/database.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:note_project/view/home/add_draw.dart';
import 'package:note_project/controllers/draw_controller.dart';
import 'package:note_project/controllers/audio_controller.dart';
import 'add_audio.dart';

class AddNotePage extends StatelessWidget {
  AudioController audioController = Get.put(AudioController());
  DrawingController drawController = Get.put(DrawingController());
  final AuthController authController = Get.find<AuthController>();
  final NoteController noteController = Get.find<NoteController>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final Rx<File?> image = Rx<File?>(null);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Thêm ghi chú",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Chụp ảnh',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Thêm ảnh',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Ghi âm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.brush),
            label: 'Vẽ',
          ),
        ],
        onTap: (int index) async {
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
              Get.to(() => AddDrawPage());
              break;
          }
        },
      ),
      body: SafeArea(
        child: Container(
          height: size.height,
          padding: const EdgeInsets.all(
            16.0,
          ),
          child: Column(children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Obx(() => (image.value != null)
                            ? Image.file(image.value!)
                            : const SizedBox()),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Xóa?"),
                                      content:
                                          const Text("Bạn có chắc chắn muốn xóa?"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text("Không"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            image.value = null;
                                            Navigator.of(context).pop(true);
                                          },
                                          child: const Text("Có"),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: const Icon(Icons.clear),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Obx(() => (drawController.paintUrl.value != null &&
                                drawController.paintUrl.value != "")
                            ? Image.network(
                                drawController.paintUrl.value,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child,
                                        loadingProgress) =>
                                    loadingProgress == null
                                        ? child
                                        : const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                              )
                            : const SizedBox()),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Xóa?"),
                                      content:
                                          const Text("Bạn có chắc chắn muốn xóa?"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text("Không"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            drawController.paintUrl.value = "";
                                            drawController.clear();
                                            Navigator.of(context).pop(true);
                                          },
                                          child: const Text("Có"),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: const Icon(Icons.clear),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      maxLines: null,
                      autofocus: true,
                      controller: titleController,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration.collapsed(
                        hintText: "Tiêu đề ghi chú",
                      ),
                      style: const TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: bodyController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration.collapsed(
                        hintText: "Nhập nội dung nào đó ... ",
                      ),
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Obx(() => (audioController.urlAudioTmp.value != "")
                        ? Container(
                            color: Colors.green,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                LinearProgressIndicator(
                                  value: audioController.progress.value,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          if (!audioController.isPlaying.value) {
                                            await audioController
                                                .startPlayerFromURL(
                                                    audioController
                                                        .urlAudioTmp.value);
                                          } else {
                                            await audioController.pausePlayer();
                                            await audioController
                                                .seekToPlayer(500);
                                          }
                                        },
                                        icon: Icon(
                                            (!audioController.isPlaying.value)
                                                ? Icons.play_arrow
                                                : Icons.pause)),
                                    IconButton(
                                        onPressed: () {
                                          audioController.stopPlayer();
                                        },
                                        icon: const Icon(Icons.stop)),
                                    IconButton(
                                        onPressed: () async {
                                          await showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text("Xóa?"),
                                                  content: const Text(
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
                                                        audioController
                                                            .urlAudioTmp
                                                            .value = "";
                                                        audioController
                                                            .audioFile
                                                            .value = null;
                                                        Navigator.of(context)
                                                            .pop(true);
                                                      },
                                                      child: const Text("Có"),
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        icon: const Icon(Icons.close)),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : const SizedBox())
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "Lưu",
        onPressed: () async {
          saveNote(context);
        },
        tooltip: "Lưu",
        child: const Icon(
          Icons.save,
          size: 30,
        ),
      ),
    );
  }

  void saveNote(BuildContext context) {
    if (titleController.text.isEmpty && bodyController.text.isEmpty) {
      showEmptyTitleDialog(context);
      return;
    }

    Database().addNote(
        authController.user!.uid,
        titleController.value.text.trim(),
        bodyController.value.text.trim(),
        image.value,
        audioController.audioFile.value,
        drawController.paint.value);
    Get.back();
  }

  Future<void> selectImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
    }
  }

  Future<void> captureImage(BuildContext context) async {
    final ImagePicker imagePicker = ImagePicker();

    final pickedFile = await imagePicker.getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
    }
  }
}

void showEmptyTitleDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).backgroundColor,
        shape: const RoundedRectangleBorder(
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
