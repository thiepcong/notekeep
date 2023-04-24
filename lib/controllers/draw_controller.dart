import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:note_project/models/drawing_point.dart';
import 'dart:typed_data';

class DrawingController extends GetxController {
  RxList<List<DrawingPoint>> _points = <List<DrawingPoint>>[].obs;
  final _color = Colors.black.obs;
  final _thickness = 5.0.obs;
  RxString paintUrl = "".obs;
  Rx<Uint8List?> paint = Rx<Uint8List?>(null);

  RxList<List<DrawingPoint>> get drawingPoints {
    return _points;
  }

  Color get color => _color.value;
  double get thickness => _thickness.value;

  void addPoint(Offset point) {
    if (_points.isEmpty) {
      List<DrawingPoint> newDrawingPointList = []; // Tạo một danh sách mới
      _points.add(newDrawingPointList);
    }
    _points.last.add(DrawingPoint(point, DateTime.now()));
    update();
  }

  void setColor(Color color) {
    _color.value = color;
    update();
  }

  void setThickness(double thickness) {
    _thickness.value = thickness;
    update();
  }

  void undo() {
    for (int i = _points.length - 1; i >= 0; i--) {
      if (_points[i].isNotEmpty) {
        _points[i].clear();
        break;
      }
    }
    update();
  }

  void clear() {
    _points.clear();

    update();
  }
}
