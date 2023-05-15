import 'package:flutter/material.dart';
import 'package:note_project/controllers/auth_controller.dart';
import 'package:note_project/view/settings/account.dart';
import 'package:note_project/view/settings/dark_mode.dart';
import 'package:note_project/view/home/app_drawer.dart';
import 'package:note_project/view/settings/view_mode.dart';
import 'package:get/get.dart';

class Setting extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cài đặt",
          style: TextStyle(fontSize: 30),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                onTap: () {
                  Get.to(() => Account());
                },
                leading: Icon(
                  Icons.person,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: const Text("Tài khoản"),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                onTap: () {
                  Get.to(() => DarkMode());
                },
                leading: Icon(
                  Icons.nights_stay,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: const Text("Chủ đề sáng-tối"),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                onTap: () {
                  Get.to(() => ViewMode());
                },
                leading: Obx(()=>Icon(
                  authController.axisCount.value == 4
                    ? Icons.list
                    : Icons.grid_view_sharp,
                  color: Theme.of(context).iconTheme.color,
                )),
                title: const Text("Chế độ xem"),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
