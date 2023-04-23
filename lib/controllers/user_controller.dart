import 'package:note_project/models/user.dart';
import 'package:note_project/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  Rx<UserModel> _userModel = UserModel().obs;

  UserModel get user => _userModel.value;

  set user(UserModel value) => this._userModel.value = value;

  void onInit() {
    print("UserController onInit");
    User? user = Get.find<AuthController>().user;
    if (user != null) {
      print("User id: ${user.uid}");
      
    } else {
      print("User not logged in");
    }
    super.onInit();
  }

  void clear() {
    _userModel.value = UserModel();
  }
}
