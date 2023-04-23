import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:note_project/controllers/audio_controller.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AddAudio extends StatelessWidget {
  AudioController audioController = Get.find<AudioController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ghi âm"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
                  '${audioController.duration.value.inSeconds} s',
                  style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
                )),
            SizedBox(
              height: 32,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (audioController.isRecording.value) {
                    audioController.stopRecording();
                  } else {
                    audioController.startRecording();
                  }
                },
                child: Obx(() => Icon(
                      (audioController.isRecording.value)
                          ? Icons.stop
                          : Icons.mic,
                      size: 80,
                    ))),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            Reference ref =
                FirebaseStorage.instance.ref().child('audio/audio.3gpp');
            UploadTask uploadTask = ref.putFile(audioController.audioFile!);
            await uploadTask.whenComplete(() async {
              String audioUrl = await ref.getDownloadURL();
              audioController.urlAudioTmp.value = audioUrl;
              print(audioUrl);
            });
            print('Uploaded audio successfully.');
            Get.back();
          } catch (e) {
            print('Error uploading audio: $e');
          }
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
