import 'package:flutter/material.dart';
import 'package:note_project/view/home/app_drawer.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text(
          "Ghi chú",
          style: TextStyle(fontSize: 30),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
          child: Container(
              child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
        child: Column(children: <Widget>[
          Container(
            height: 160,
            child: Image.asset("assets/image/logo1.png"),
          ),
          Container(
            height: 160,
            child: Image.asset("assets/image/logo.jpg"),
          ),
          const SizedBox(
            height: 40,
          ),
          const Text(
            "Ứng dụng này được xây dựng nhằm mục đích học tập\nĐược xây dựng bởi Phạm Công Thiệp",
            style: TextStyle(
              fontSize: 20,
            ),textAlign: TextAlign.center,
          )
        ]),
      ))),
    );
  }
}
