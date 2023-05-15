import 'package:flutter/material.dart';
import 'package:note_project/view/home/home.dart';

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
        primaryColor: const Color.fromRGBO(255, 152, 0, 1),
      ),
      home: MyHomePage(),
    );
  }
}
