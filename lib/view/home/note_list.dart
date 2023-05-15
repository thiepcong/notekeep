import 'dart:math';
import 'package:flutter/material.dart';
import 'package:note_project/controllers/auth_controller.dart';
import 'package:note_project/controllers/note_controler.dart';
import 'package:note_project/view/home/edit_note.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class NoteList extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final NoteController noteController = Get.find<NoteController>();
  final lightColors = [
    Colors.amber.shade300,
    Colors.lightGreen.shade300,
    Colors.lightBlue.shade300,
    Colors.orange.shade300,
    Colors.pinkAccent.shade100,
    Colors.tealAccent.shade100,
    Colors.purpleAccent,
    Colors.greenAccent.shade400,
    Colors.cyanAccent,
  ];

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return Expanded(
        child: StaggeredGridView.countBuilder(
          itemCount: noteController.notes.length,
          staggeredTileBuilder: (index) =>
              StaggeredTile.fit(authController.axisCount.value),
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemBuilder: (context, index) {
            var formattedDate = DateFormat.yMMMd()
                .format(noteController.notes[index].creationDate.toDate());
            Random random = new Random();
            Color bg = lightColors[random.nextInt(8)];
            return GestureDetector(
              onTap: () {
                Get.to(() => ShowNote(
                    index: index, noteData: noteController.notes[index]));
              },
              child: Container(
                padding: const EdgeInsets.only(
                  bottom: 10,
                  left: 10,
                  right: 10,
                ),
                decoration: BoxDecoration(
                  color: bg,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Obx(() {
                      final imageUrl = noteController.notes[index].imageUrl;
                      return imageUrl != null && imageUrl.isNotEmpty
                          ? CachedNetworkImage(imageUrl: imageUrl)
                          : const SizedBox();
                    }),
                    Obx(() => (noteController.notes[index].paintUrl != null &&
                            noteController.notes[index].paintUrl != "")
                        ? Image.network(
                            noteController.notes[index].paintUrl!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) =>
                                loadingProgress == null
                                    ? child
                                    : const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                          )
                        : const SizedBox()),
                    ListTile(
                      contentPadding: const EdgeInsets.only(
                        top: 5,
                        right: 8,
                        left: 8,
                        bottom: 0,
                      ),
                      title: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: Text(
                          noteController.notes[index].title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      subtitle: Text(
                        noteController.notes[index].body,
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          formattedDate,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Expanded(
        child: StaggeredGridView.countBuilder(
          itemCount: noteController.notes.length,
          staggeredTileBuilder: (index) =>
              StaggeredTile.fit(authController.axisCount.value),
          crossAxisCount: 8,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemBuilder: (context, index) {
            var formattedDate = DateFormat.yMMMd()
                .format(noteController.notes[index].creationDate.toDate());
            Random random = new Random();
            Color bg = lightColors[random.nextInt(8)];
            return GestureDetector(
              onTap: () {
                Get.to(() => ShowNote(
                    index: index, noteData: noteController.notes[index]));
              },
              child: Container(
                padding: const EdgeInsets.only(
                  bottom: 10,
                  left: 10,
                  right: 10,
                ),
                decoration: BoxDecoration(
                  color: bg,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Obx(() => (noteController.notes[index].imageUrl != null &&
                            noteController.notes[index].imageUrl != "")
                        ? Image.network(
                            noteController.notes[index].imageUrl!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) =>
                                loadingProgress == null
                                    ? child
                                    : const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                          )
                        : const SizedBox()),
                    Obx(() => (noteController.notes[index].paintUrl != null &&
                            noteController.notes[index].paintUrl != "")
                        ? Image.network(
                            noteController.notes[index].paintUrl!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) =>
                                loadingProgress == null
                                    ? child
                                    : const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                          )
                        : const SizedBox()),
                    ListTile(
                      contentPadding: const EdgeInsets.only(
                        top: 5,
                        right: 8,
                        left: 8,
                        bottom: 0,
                      ),
                      title: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: Text(
                          noteController.notes[index].title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      subtitle: Text(
                        noteController.notes[index].body,
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          formattedDate,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
}

Future<Image> image(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode == 200) {
    final bytes = response.bodyBytes;
    // hiển thị hình ảnh bằng Image.memory
    return Image.memory(bytes);
  } else {
    throw Exception('Failed to load image');
  }
}
