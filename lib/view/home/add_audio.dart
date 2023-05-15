import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_project/controllers/audio_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddAudio extends StatelessWidget {
  AudioController audioController = Get.find<AudioController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ghi âm"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
                  '${audioController.duration.value.inSeconds} s',
                  style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
                )),
            const SizedBox(
              height: 24,
            ),
            GestureDetector(
              onTap: () async {
                if (audioController.isRecording.value) {
                  audioController.stopRecording();
                } else {
                  audioController.startRecording();
                }
              },
              child: Ink(
                decoration:const  ShapeDecoration(
                  color: Colors.grey,
                  shape: CircleBorder(),
                ),
                child: Padding(
                  padding:const  EdgeInsets.all(16),
                  child: Obx(() => Icon(
                        (audioController.isRecording.value)
                            ? Icons.stop
                            : Icons.mic,
                        size: 80,
                        color: Colors.white,
                      )),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            Reference ref =
                FirebaseStorage.instance.ref().child('audio/audio.3gpp');
            UploadTask uploadTask =
                ref.putFile(audioController.audioFile.value!);
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
        child: const Icon(Icons.save),
      ),
    );
  }
}
