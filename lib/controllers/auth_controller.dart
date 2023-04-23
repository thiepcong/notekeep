import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_project/controllers/user_controller.dart';
import 'package:note_project/models/user.dart';
import 'package:note_project/services/database.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Rx<User?> _firebaseUser;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String usersCollection = "users";
  Rx<UserModel> userModel = UserModel().obs;
  Rx<int> axisCount = 4.obs;

  User? get user => _firebaseUser.value;

  @override
  void onInit() {
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    super.onInit();
  }

  void createUser() async {
    try {
      print("Creating user");
      await _auth
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((value) {
        UserModel _user = UserModel(
          id: value.user!.uid,
          name: name.text,
          email: email.text,
        );
        Database().createNewUser(_user).then((value) {
          if (value) {
            Get.find<UserController>().user = _user;
            Get.back();
            _clearControllers();
          }
        });
      });
    } catch (e) {
      //print(e);
      Get.snackbar(
        'Error creating account',
        '${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void login() async {
    try {
      print("IN logging in email ${email.text} password ${password.text}");
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email.text, password: password.text);

      Get.find<UserController>().user =
          await Database().getUser(userCredential.user!.uid);
      _clearControllers();
    } catch (e) {print(e);
      Get.snackbar(
        'Error logging in',
        '${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void signout() async {
    try {
      await _auth.signOut();
      Get.find<UserController>().user = UserModel();
    } catch (e) {//print(e);
      Get.snackbar(
        'Error signing out',
        '${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  _clearControllers() {
    name.clear();
    email.clear();
    password.clear();
  }
}
