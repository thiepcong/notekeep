import 'package:flutter/material.dart';
import 'package:note_project/view/home/home.dart';
import 'package:note_project/view/home/add_note.dart';
import 'package:note_project/view/autho/login.dart';
import 'package:note_project/view/autho/signup.dart';
import 'package:note_project/view/settings/setting.dart';
import 'package:get/get.dart';
import 'package:note_project/view/home/app_info.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(255, 152, 0, 1),
      ),
      home: MyHomePage(),
    );
  }
}
