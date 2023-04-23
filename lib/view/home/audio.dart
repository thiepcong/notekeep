import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_sound/flutter_sound.dart';

class AudioPlayerDialog extends StatelessWidget {
  final String url;

  AudioPlayerDialog({required this.url});

  final SoundPlayerController playerController =
      Get.put(SoundPlayerController());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(
                value: playerController.progress.value,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () async {
                        await playerController.startPlayerFromURL(url);
                      },
                      icon: Icon(Icons.play_arrow)),
                  IconButton(
                      onPressed: () {
                        playerController.stopPlayer();
                      },
                      icon: Icon(Icons.stop)),
                  IconButton(
                      onPressed: () {
                        playerController.stopPlayer();
                        Get.back();
                      },
                      icon: Icon(Icons.close)),
                ],
              ),
            ],
          )),
    );
  }
}

class SoundPlayerController extends GetxController {
  final progress = 0.0.obs;
  late final FlutterSoundPlayer player;

  @override
  void onInit() {
    super.onInit();
    player = FlutterSoundPlayer();
    player.setSubscriptionDuration(Duration(milliseconds: 100));
    // player.onProgress?.listen((e) {
    //   progress.value = e.position / e.duration;
    // });
  }

  Future<void> startPlayerFromURL(String url) async {
    await player.startPlayer(
      fromURI: url,
      codec: Codec.mp3,
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
