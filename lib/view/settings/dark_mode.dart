import 'package:flutter/material.dart';
import 'package:note_project/view/home/home.dart';
import 'package:get/get.dart';

class DarkMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.arrow_back_ios_outlined),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5,
                    ),
                    Text(
                      "Chủ đề sáng-tối",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                onTap: () {
                  Get.changeThemeMode(ThemeMode.system);
                  Get.to(() => MyHomePage());
                },
                leading: Icon(
                  Icons.settings_brightness_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text("Sử dụng cài đặt của hệ thống"),
                subtitle: Text(
                  "Tự động chuyển sang chủ đề mặc định với hệ thống",
                ),
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
                  Get.changeThemeMode(ThemeMode.light);
                  Get.to(() => MyHomePage());
                },
                leading: Icon(
                  Icons.brightness_5,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text("Chủ đề sáng"),
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
                  Get.changeThemeMode(ThemeMode.dark);
                  Get.to(() => MyHomePage());
                },
                leading: Icon(
                  Icons.brightness_4_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text("Chủ đề tối"),
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
