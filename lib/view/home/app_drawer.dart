import 'package:flutter/material.dart';
import 'package:note_project/view/settings/setting.dart';
import 'package:note_project/view/home/add_note.dart';
import 'package:note_project/view/home/home.dart';
import 'package:note_project/view/home/app_info.dart';
import 'package:get/get.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          AppBar(
            title: const Text("Note PCT",style: TextStyle(fontSize: 30)),
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          ListTile(
            iconColor: Theme.of(context).primaryColor,
            leading: const Icon(Icons.lightbulb),
            title: const Text('Ghi chú'),
            onTap: () {
              Get.to(() => MyHomePage());
            },
          ),
          const Divider(),
          ListTile(
            iconColor: Theme.of(context).primaryColor,
            leading: const Icon(Icons.note_add),
            title: const Text('Tạo ghi chú mới'),
            onTap: () {
              Get.to(() => AddNotePage());
            },
          ),
          const Divider(),
          ListTile(
            iconColor: Theme.of(context).primaryColor,
            leading: const Icon(Icons.settings),
            title: const Text('Cài đặt'),
            onTap: () {
              Get.to(() => Setting());
            },
          ),
          const Divider(),
          ListTile(
            iconColor: Theme.of(context).primaryColor,
            leading: const Icon(Icons.info),
            title: const Text('Thông tin ứng dụng'),
            onTap: () {
              Get.to(() =>const Info());
            },
          ),
        ],
      ),
    );
  }
}
