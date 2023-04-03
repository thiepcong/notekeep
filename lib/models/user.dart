import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String id;
  late String name;
  late String email;

  UserModel({this.id='', this.name='', this.email=''});

  UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc["id"];
    name = doc["name"];
    email = doc["email"];
  }
}
