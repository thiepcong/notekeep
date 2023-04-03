import 'package:flutter/material.dart';
import 'package:note_project/controllers/authController.dart';
import 'package:note_project/view/autho/login.dart';
import 'package:note_project/view/home/home.dart';
import 'package:get/get.dart';

class Root extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (authController != null && authController.user?.uid != null) {
          return MyHomePage();
        } else {
          return Login();
        }
      },
    );
  }
}
