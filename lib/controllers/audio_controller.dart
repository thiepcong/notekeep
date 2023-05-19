
import 'package:get/get.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class AudioController extends GetxController {
  Rx<File?> audioFile = Rx<File?>(null);
  RxString urlAudioTmp = "".obs;
  final progress = 0.0.obs;
  var position = 0.0.obs;
  final volume = 3.0.obs;
  RxDouble handle = 0.0.obs;
  bool isRecoderReady = false;
  RxBool isRecording = false.obs;
  RxBool isPlaying = false.obs;
  Rx<Duration> duration = Duration.zero.obs;
  Rx<Duration> durationPlayer = Duration.zero.obs;
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
        await Future.delayed(const Duration(milliseconds: 100));
      }
    } catch (err) {
      isRecording.value = false;
      rethrow;
    }
  }

  void setVolume(double volumeValue) {
    player.setVolume(volumeValue);
    volume.value = volumeValue;
  }

  // Future<File?>
  Future<void> stopRecording() async {
    if (!isRecording.value) return;
    final path = await recorder.stopRecorder();
    audioFile.value = File(path!);
    duration.value = Duration.zero;
    isRecording.value = false;
  }

  Future<void> startPlayerFromURL(String url) async {
    await player.openPlayer();

    player.setSubscriptionDuration(const Duration(milliseconds: 100));
    player.onProgress!.listen((event) {
      progress.value = event.position.inMilliseconds.toDouble() /
          event.duration.inMilliseconds.toDouble();
      handle.value = event.position.inMilliseconds.toDouble() / 1000;
    });
    await player.startPlayer(
      fromURI: url,
    );
    isPlaying.value = true;
  }

  Future<double> getAudioDurationFromURL(String url) async {
    final player = FlutterSoundPlayer();
    await player.openPlayer();
    final info = await player.startPlayer(fromURI: url);
    await player.stopPlayer();
    return info!.inMilliseconds.toDouble();
  }

  Future<void> pausePlayer() async {
    await player.pausePlayer();
    isPlaying.value = false;
  }

  void stopPlayer() {
    player.stopPlayer();
    isPlaying.value = false;
    progress.value = 0.0;
    handle.value = 0;
  }

  @override
  void onClose() {
    player.dispositionStream();
    super.onClose();
  }
}
