import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_project/controllers/authController.dart';
import 'package:note_project/controllers/userController.dart';
import 'package:note_project/start_widgets/root.dart';
import 'package:note_project/start_widgets/theme.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBJVPMF3HRsS1hshMqdfdmQj4cYyrAVVGA",
        authDomain: "noteapp-9c63e.firebaseapp.com",
        projectId: "noteapp-9c63e",
        storageBucket: "noteapp-9c63e.appspot.com",
        messagingSenderId: "421639866087",
        appId: "1:421639866087:web:b8021400691168dfa80442",
        measurementId: "G-FBYGY7VXGP"),
  ).then((value) {
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
