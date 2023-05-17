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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ignore: must_be_immutable
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
  DrawingController drawController = Get.put(DrawingController());
  DateTimePickerController datecontroller = Get.put(DateTimePickerController());
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
    if (noteData.paintUrl != null && noteData.paintUrl != "") {
      paintUrl.value = noteData.paintUrl!;
      drawController.paintUrl.value = noteData.paintUrl!;
    }

    if (noteData.audioUrl != null && noteData.audioUrl != "") {
      audioUrl.value = noteData.audioUrl!;
      audioController.urlAudioTmp.value = noteData.audioUrl!;
    }

    var formattedDate =
        DateFormat.yMMMd().format(noteData.creationDate.toDate());
    var time = DateFormat.jm().format(noteData.creationDate.toDate());
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Sửa ghi chú",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  // DateTime selectedDate = datecontroller.selectedDate.value;
                  // TimeOfDay selectedTime = datecontroller.selectedTime.value;
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Chọn ngày giờ"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Chọn ngày
                              InkWell(
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        datecontroller.selectedDate.value,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null) {
                                    datecontroller.updateSelectedDate(picked);
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.date_range),
                                    SizedBox(width: 10),
                                    Obx(() => Text(
                                          DateFormat("dd/MM/yyyy").format(
                                              datecontroller
                                                  .selectedDate.value),
                                          style: const TextStyle(fontSize: 16),
                                        )),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Chọn giờ
                              InkWell(
                                onTap: () async {
                                  final TimeOfDay? picked =
                                      await showTimePicker(
                                    context: context,
                                    initialTime:
                                        datecontroller.selectedTime.value,
                                  );
                                  if (picked != null) {
                                    datecontroller.updateSelectedTime(picked);
                                  }
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.access_time),
                                    const SizedBox(width: 10),
                                    Obx(() => Text(
                                          datecontroller.selectedTime.value
                                              .format(Get.context!),
                                          style: const TextStyle(fontSize: 16),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text("Hủy"),
                            ),
                            TextButton(
                              onPressed: () async {
                                final FlutterLocalNotificationsPlugin
                                    flutterLocalNotificationsPlugin =
                                    FlutterLocalNotificationsPlugin();
                                // Khởi tạo cài đặt cho thông báo
                                final AndroidInitializationSettings
                                    initializationSettingsAndroid =
                                    AndroidInitializationSettings(
                                        '@mipmap/ic_launcher');
                                final InitializationSettings
                                    initializationSettings =
                                    InitializationSettings(
                                        android: initializationSettingsAndroid);

                                // Khởi tạo plugin
                                await flutterLocalNotificationsPlugin
                                    .initialize(initializationSettings);
                                // Tạo thông báo
                                final DateTime now = DateTime.now();
                                final DateTime scheduledDate = DateTime(
                                    datecontroller.selectedDate.value.year,
                                    datecontroller.selectedDate.value.month,
                                    datecontroller.selectedDate.value.day,
                                    datecontroller.selectedTime.value.hour,
                                    datecontroller.selectedTime.value.minute);

                                if (scheduledDate.isAfter(now)) {
                                  final AndroidNotificationDetails
                                      androidPlatformChannelSpecifics =
                                      AndroidNotificationDetails(
                                    'note_chanel_id',
                                    'note_chanel_name',
                                    channelDescription:
                                        'note_chanel_description',
                                    importance: Importance.max,
                                    priority: Priority.high,
                                    showWhen: false,
                                  );

                                  final NotificationDetails
                                      platformChannelSpecifics =
                                      NotificationDetails(
                                          android:
                                              androidPlatformChannelSpecifics);

                                  // Đặt thông báo
                                  await flutterLocalNotificationsPlugin
                                      .schedule(
                                          0,
                                          titleController.text,
                                          bodyController.text,
                                          scheduledDate,
                                          platformChannelSpecifics);
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Thông báo sẽ hiển thị lúc \n $scheduledDate'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                                Get.back();
                              },
                              child: const Text("Đồng ý"),
                            ),
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.notifications)),
            IconButton(
                onPressed: () {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  Share.share('${noteData.title}\n${noteData.body}',
                      subject: noteData.title,
                      sharePositionOrigin:
                          box.localToGlobal(Offset.zero) & box.size);
                },
                icon: const Icon(Icons.share)),
            IconButton(
              onPressed: () {
                showDeleteDialog(context, noteData);
              },
              icon: const Icon(Icons.delete),
            ),
          ],
          backgroundColor: Theme.of(context).primaryColor,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: 'Chụp ảnh',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.image),
              label: 'Thêm ảnh',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              label: 'Ghi âm',
            ),
            const BottomNavigationBarItem(
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
            padding: const EdgeInsets.all(
              16.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text("$formattedDate at $time"),
                        const SizedBox(
                          height: 10,
                        ),
                        Stack(
                          children: [
                            Obx(() {
                              if (checkIn) {
                                return Image.file(File(imageUrl.value));
                              } else if (imageUrl.value != "") {
                                return Image.network(
                                  imageUrl.value,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) =>
                                          loadingProgress == null
                                              ? child
                                              : const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                );
                              } else {
                                return const SizedBox();
                              }
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
                                          title: const Text("Xóa?"),
                                          content: const Text(
                                              "Bạn có chắc chắn muốn xóa?"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: const Text("Không"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                imageUrl.value = "";
                                                checkIn = false;
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
                            Obx(() => (drawController.paintUrl.value != "")
                                ? Image.network(
                                    (drawController.paintUrl.value == "")
                                        ? paintUrl.value
                                        : drawController.paintUrl.value,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) =>
                                            loadingProgress == null
                                                ? child
                                                : const Center(
                                                    child:
                                                        CircularProgressIndicator(),
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
                                          content: const Text(
                                              "Bạn có chắc chắn muốn xóa?"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: const Text("Không"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                isDeletepaint = true;
                                                paintUrl.value = "";
                                                drawController.paintUrl.value =
                                                    "";
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
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: titleController,
                          maxLines: null,
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
                          autofocus: true,
                          controller: bodyController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration.collapsed(
                            hintText: "Nhập nội dung nào đó ...",
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () async {
                                              if (!audioController
                                                  .isPlaying.value) {
                                                await audioController
                                                    .startPlayerFromURL(
                                                        audioController
                                                            .urlAudioTmp.value);
                                              } else {
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
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(false),
                                                          child: const Text(
                                                              "Không"),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            isDeleteaudio =
                                                                true;
                                                            audioUrl.value = "";
                                                            audioController
                                                                .urlAudioTmp
                                                                .value = "";
                                                            Navigator.of(
                                                                    context)
                                                                .pop(true);
                                                          },
                                                          child:
                                                              const Text("Có"),
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
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            saveNote(context);
          },
          label: const Text("Lưu"),
          icon: const Icon(Icons.save),
        ));
  }

  void saveNote(BuildContext context) async {
    if (titleController.text == noteData.title &&
        bodyController.text == noteData.body &&
        imageUrl.value == noteData.imageUrl &&
        paintUrl.value == noteData.paintUrl &&
        audioUrl.value == noteData.audioUrl &&
        paintUrl.value == drawController.paintUrl.value &&
        audioUrl.value == audioController.urlAudioTmp.value) {
      showSameContentDialog(context);
    } else {
      if (isDeletepaint) drawController.paint.value = null;
      if (isDeleteaudio) audioController.audioFile.value = null;
      if (checkIn) {
        Database().updateNote(
            authController.user!.uid,
            titleController.text,
            bodyController.text,
            noteData.id,
            File(imageUrl.value),
            audioController.audioFile.value,
            drawController.paint.value,
            imageUrl.value,
            audioUrl.value,
            paintUrl.value);
        print("da co anh");
      } else {
        Database().updateNote(
            authController.user!.uid,
            titleController.text,
            bodyController.text,
            noteData.id,
            null,
            audioController.audioFile.value,
            drawController.paint.value,
            imageUrl.value,
            audioUrl.value,
            paintUrl.value);
        print("khong co anh");
      }
      Get.back();
    }
  }

  Future<void> selectImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageUrl.value = pickedFile.path;
      checkIn = true;
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
        shape: const RoundedRectangleBorder(
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
        shape: const RoundedRectangleBorder(
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

class DateTimePickerController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var selectedTime = TimeOfDay.now().obs;

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  void updateSelectedTime(TimeOfDay time) {
    selectedTime.value = time;
  }
}
