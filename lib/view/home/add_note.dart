import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:note_project/controllers/auth_controller.dart';
import 'package:note_project/controllers/note_controler.dart';
import 'package:note_project/services/database.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:note_project/view/home/add_draw.dart';
import 'package:note_project/controllers/draw_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:note_project/controllers/audio_controller.dart';
import 'add_audio.dart';

class AddNotePage extends StatelessWidget {
  AudioController audioController = Get.put(AudioController());
  final AuthController authController = Get.find<AuthController>();
  final NoteController noteController = Get.find<NoteController>();
  final DrawingController drawController = Get.find<DrawingController>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final Rx<File?> image = Rx<File?>(null);
  late String mp3Path;
  bool isRecording = false;
  int checkAdd = -1;
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();

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
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Them,
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
              isRecording = false;
              // await initRecorder();
              // recording(context);
              Get.to(() => AddAudio());
              // print('mp3: ' + );
              break;
            case 3:
              drawController.drawingPoints.clear();
              Get.to(() => AddDrawPage());
              break;
          }
        },
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
                    Obx(() => (image.value != null)
                        ? Image.file(image.value!)
                        : SizedBox()),
                    // Obx(() => (drawController.paintUrl.value != null &&
                    //         drawController.paintUrl.value != "")
                    //     ? Image.network(
                    //         drawController.paintUrl.value,
                    //         fit: BoxFit.cover,
                    //         loadingBuilder: (context, child, loadingProgress) =>
                    //             loadingProgress == null
                    //                 ? child
                    //                 : Center(
                    //                     child: CircularProgressIndicator(),
                    //                   ),
                    //       )
                    //     : SizedBox()),
                    SizedBox(height: 20),
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
                    SizedBox(
                      height: 32,
                    ),
                    Obx(() => (audioController.urlAudioTmp.value != "")
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          if (!audioController.isPlaying.value)
                                            await audioController
                                                .startPlayerFromURL(
                                                    audioController
                                                        .urlAudioTmp.value);
                                        },
                                        icon: Icon(
                                            (!audioController.isPlaying.value)
                                                ? Icons.play_arrow
                                                : Icons.pause)),
                                    IconButton(
                                        onPressed: () {
                                          audioController.stopPlayer();
                                        },
                                        icon: Icon(Icons.stop)),
                                    IconButton(
                                        onPressed: () {
                                          audioController.stopPlayer();
                                          Get.back();
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
          ]),
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
        null,
        drawController.paint);
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
