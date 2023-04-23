import 'package:flutter/material.dart';
import 'package:note_project/controllers/auth_controller.dart';
import 'package:note_project/controllers/user_controller.dart';
import 'package:note_project/view/autho/signup.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 40,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height:160,
                    child:Image.asset("assets/image/logo1.png"),
                  ),
                  Text(
                    'Đăng nhập',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: authController.email,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập email!';
                              } else
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)
                                    ? null
                                    : "Vui lòng nhập đúng định dạng email!";
                            },
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).buttonColor,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.grey,
                                ),
                                labelText: "Email"),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: authController.password,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập mật khẩu!';
                              } else if (value.length < 6) {
                                return "Vui lòng nhập mật khẩu tối thiểu 6 ký tự! ";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).buttonColor,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                labelText: "Mật khẩu"),
                            obscureText: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.orangeAccent.shade700,
                      ),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      minimumSize: MaterialStateProperty.all(
                        Size(
                          250,
                          50,
                        ),
                      ),
                    ),
                    child: Text(
                      "ĐĂNG NHẬP",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        authController.login();
                      }
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Bạn chưa có tài khoản?  ",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => SignUp());
                        },
                        child: Text(
                          "Đăng ký",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
