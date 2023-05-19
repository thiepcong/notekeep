import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_project/controllers/auth_controller.dart';
import 'package:note_project/controllers/user_controller.dart';
import 'package:note_project/start_widgets/root.dart';
import 'package:note_project/start_widgets/theme.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    Get.put<AuthController>(AuthController());
    Get.put<UserController>(UserController());
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note PCT',
      theme: Themes().lightTheme,
      darkTheme: Themes().dartTheme,
      themeMode: ThemeMode.system,
      home: Root(),
    );
  }
}
