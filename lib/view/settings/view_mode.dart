import 'package:flutter/material.dart';
import 'package:note_project/controllers/authController.dart';
import 'package:note_project/view/home/home.dart';
import 'package:get/get.dart';

class ViewMode extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chế độ xem",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                onTap: () {
                  authController.axisCount.value = 4;
                  Get.to(() => MyHomePage());
                },
                leading: Icon(
                  Icons.list,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text("Xem dưới chế độ danh sách"),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              Divider(),
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                onTap: () {
                  authController.axisCount.value = 2;
                  Get.to(() => MyHomePage());
                },
                leading: Icon(
                  Icons.grid_view_sharp,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text("Xem dưới chế độ lưới"),
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
