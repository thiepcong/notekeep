import 'package:flutter/material.dart';
import 'package:note_project/controllers/authController.dart';
import 'package:note_project/controllers/userController.dart';
import 'package:get/get.dart';

class Account extends StatelessWidget {

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      width: MediaQuery.of(context).size.width / 4,
                    ),
                    Text(
                      "Account",
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
              Obx(() {
                String name = Get.find<UserController>().user.name ;
                if (name.isNotEmpty) {
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    onTap: () {},
                    title: Text("Chào ${name}"),
                    leading: Icon(
                      Icons.account_box_sharp,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  );
                } else {
                  // hiển thị khối lệnh này nếu dữ liệu chưa được load thành công
                  return CircularProgressIndicator();
                }
              }),
              Divider(),
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                onTap: () {
                  showSignOutDialog(context);
                },
                title: Text("Đăng xuất"),
                leading: Icon(
                  Icons.power_settings_new_outlined,
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

void showSignOutDialog(BuildContext context) async {
  final AuthController authController = Get.find<AuthController>();
  print("in dialog ");
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.all(20),
        actionsPadding: EdgeInsets.only(right: 60),
        backgroundColor: Theme.of(context).backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        title: Text(
          "Bạn có chắc muốn đăng xuất?",
          style: TextStyle(
            color: Theme.of(context).buttonColor,
            fontSize: 20,
          ),
          textAlign: TextAlign.start,
        ),
        content: Text(
          'Các ghi chú của bạn đã được lưu lại.',
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Đăng xuất",
                style: TextStyle(
                  color: Theme.of(context).backgroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            onPressed: () {
              Get.back();
              authController.signout();
              Get.close(2);
            },
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).buttonColor,
            ),
          ),
          TextButton(
            child: Text("Quay lại",
                style: TextStyle(
                  color: Theme.of(context).buttonColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
