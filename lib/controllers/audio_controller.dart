import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class AudioController extends GetxController {
  Rx<File?> audioFile = Rx<File?>(null);
  RxString urlAudioTmp = "".obs;
  final progress = 0.0.obs;
  bool isRecoderReady = false;
  RxBool isRecording = false.obs;
  RxBool isPlaying = false.obs;
  Rx<Duration> duration = Duration.zero.obs;
  final recorder = FlutterSoundRecorder();
  final player = FlutterSoundPlayer();
  @override
  Future<void> onInit() async {
    super.onInit();
    initRecorder();
  }

  bool get isrecording => isRecording.value;
  Future<void> initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw "Microphone chưa cấp quyền";
    }
    await recorder.openRecorder();
    isRecoderReady = true;
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
    //theo doi su thay doi cua am thanh
    await recorder.onProgress?.first.then((event) {
      duration.value = event.duration;
    });
    //theo doi su thay doi cua isrecording
    ever(isRecording, (bool isRecording) {
      if (!isRecording) {
        duration.value = Duration.zero;
      }
    });
  }

  Future<void> startRecording() async {
    try {
      if (!isRecoderReady) {
        await initRecorder();
      }
      final startTime = DateTime.now();
      await recorder.startRecorder(toFile: 'audio');
      isRecording.value = true;
      while (isRecording.value) {
        final elapsed = DateTime.now().difference(startTime);
        duration.value = Duration(milliseconds: elapsed.inMilliseconds);
        await Future.delayed(Duration(milliseconds: 100));
      }
    } catch (err) {
      isRecording.value = false;
      rethrow;
    }
  }

  // Future<File?>
  Future<void> stopRecording() async {
    if (!isRecording.value) return null;
    final path = await recorder.stopRecorder();
    audioFile.value = File(path!);
    duration.value = Duration.zero;
    isRecording.value = false;
    print("audio file" + audioFile.toString());
  }

  Future<void> startPlayerFromURL(String url) async {
    await player.openPlayer();
    player.setSubscriptionDuration(Duration(milliseconds: 100));
    player.onProgress!.listen((event) {
      progress.value = event.position.inMilliseconds.toDouble() /
          event.duration.inMilliseconds.toDouble();
    });
    await player.startPlayer(
      fromURI: url,
    );
  }

  void stopPlayer() {
    player.stopPlayer();
    progress.value = 0.0;
  }

  @override
  void onClose() {
    player.dispositionStream();
    super.onClose();
  }
}
