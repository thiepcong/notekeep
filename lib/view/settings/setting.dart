import 'package:flutter/material.dart';
import 'package:note_project/controllers/auth_controller.dart';
import 'package:note_project/view/home/home.dart';
import 'package:note_project/view/settings/account.dart';
import 'package:note_project/view/settings/dark_mode.dart';
import 'package:note_project/view/home/add_note.dart';
import 'package:note_project/view/home/app_drawer.dart';
import 'package:note_project/view/settings/view_mode.dart';
import 'package:get/get.dart';

class Setting extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cài đặt",
          style: TextStyle(fontSize: 30),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          child: Column(
            children: [
              // Container(
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       // Container(
              //       //   decoration: BoxDecoration(
              //       //       color: Theme.of(context).backgroundColor,
              //       //       shape: BoxShape.rectangle,
              //       //       borderRadius: BorderRadius.circular(10)),
              //       //   child: IconButton(
              //       //     onPressed: () {
              //       //       Get.back();
              //       //     },
              //       //     icon: Icon(Icons.arrow_back_ios_outlined),
              //       //   ),
              //       // ),
              //       SizedBox(
              //         width: MediaQuery.of(context).size.width / 4,
              //       ),
              //       Text(
              //         "Settings",
              //         style: TextStyle(
              //           fontSize: 24,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                onTap: () {
                  Get.to(() => Account());
                },
                leading: Icon(
                  Icons.person,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text("Tài khoản"),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                onTap: () {
                  Get.to(() => DarkMode());
                },
                leading: Icon(
                  Icons.nights_stay,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text("Chủ đề sáng-tối"),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(
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
                title: Text("Chế độ xem"),
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
