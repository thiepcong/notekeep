import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:note_project/controllers/draw_controller.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:note_project/models/drawing_point.dart';
import 'package:note_project/controllers/note_controler.dart';
import 'package:note_project/controllers/auth_controller.dart';

class EditDrawPage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final NoteController noteController = Get.find<NoteController>();
  final DrawingController drawController = Get.find<DrawingController>();
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Vẽ",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).primaryColor),
      body: RepaintBoundary(
        key: _globalKey,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(drawController.paintUrl.value == ""
                  ? "https://firebasestorage.googleapis.com/v0/b/noteapp-9c63e.appspot.com/o/paint%2Fpaint1.png?alt=media&token=9b548c72-5be7-4bcf-a669-ad82e775a254"
                  : drawController.paintUrl.value),
              fit: BoxFit.cover,
            ),
          ),
          height: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              kBottomNavigationBarHeight,
          width: MediaQuery.of(context).size.width,
          child: LayoutBuilder(builder: (context, constraints) {
            return GestureDetector(
              onPanDown: (details) {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                Offset localPosition =
                    renderBox.globalToLocal(details.globalPosition);
                drawController.addPoint(localPosition);
              },
              onPanUpdate: (details) {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                Offset localPosition =
                    renderBox.globalToLocal(details.globalPosition);
                drawController.addPoint(localPosition);
              },
              onPanEnd: (details) {
                List<DrawingPoint> newDrawingPointList = [];
                drawController.drawingPoints.add(newDrawingPointList);
              },
              child: GetBuilder<DrawingController>(builder: (_) {
                return CustomPaint(
                  painter: DrawPainter(drawController.drawingPoints,
                      drawController.color, drawController.thickness),
                );
              }),
            );
          }),
        ),
      ),
      bottomNavigationBar: Obx(() => Container(
            height: 160,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Divider(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        drawController.clear();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Icon(
                          Icons.clear,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        drawController.undo();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amber,
                        ),
                        child: Icon(
                          Icons.undo_rounded,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        final color = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Chọn một màu'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: drawController.color,
                                onColorChanged: (color) {
                                  drawController.setColor(color);
                                },
                                // ignore: deprecated_member_use
                                showLabel: true,
                                pickerAreaHeightPercent: 0.8,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(
                                      context, drawController.color.value);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                        drawController.setColor(color ?? drawController.color);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: drawController.color,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        drawController.paint.value =
                            (await _captureScreenshot())!;
                        Reference ref = FirebaseStorage.instance
                            .ref()
                            .child('paint/paint.png');
                        UploadTask uploadTask =
                            ref.putData(drawController.paint.value!);
                        TaskSnapshot taskSnapshot =
                            await uploadTask.whenComplete(() async {
                          drawController.paintUrl.value =
                              await ref.getDownloadURL();
                        });

                        Get.back();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        child: Icon(
                          Icons.save,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: drawController.thickness,
                  min: 1,
                  max: 50,
                  onChanged: (value) {
                    drawController.setThickness(value);
                  },
                ),
              ],
            ),
          )),
    );
  }

  Future<Uint8List?> _captureScreenshot() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print(e);
    }
    return null;
  }
}

class DrawPainter extends CustomPainter {
  final List<List<DrawingPoint>> points;
  final Color color;
  final double thickness;
  DrawPainter(this.points, this.color, this.thickness);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;
    for (List<DrawingPoint> pointList in points)
      // ignore: curly_braces_in_flow_control_structures
      for (int i = 0; i < pointList.length - 1; i++) {
        if (pointList[i] != null && pointList[i + 1] != null) {
          canvas.drawLine(pointList[i].point, pointList[i + 1].point, paint);
        }
      }
  }

  @override
  bool shouldRepaint(DrawPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.thickness != thickness ||
        oldDelegate.color != color;
  }
}
