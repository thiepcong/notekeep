import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_project/models/note.dart';
import 'package:note_project/models/user.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:typed_data';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String userCollection = "users";
  final String noteCollection = "notes";

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore
          .collection(userCollection)
          .doc(user.id)
          .set({"id": user.id, "name": user.name, "email": user.email});
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }

  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(userCollection).doc(uid).get();
      return UserModel.fromDocumentSnapshot(doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> addNote(String uid, String title, String body, File? image,
      File? audio, Uint8List? bytes) async {
    try {
      var uuid = const Uuid().v4();
      var noteData = {
        "id": uuid,
        "title": title,
        "body": body,
        "creationDate": Timestamp.now(),
      };
      if (image != null) {
        Reference ref = _storage.ref().child("images/$uid/$uuid.jpg");
        UploadTask uploadTask = ref.putFile(image);
        await uploadTask.whenComplete(() async {
          String imageUrl = await ref.getDownloadURL();
          noteData["imageUrl"] = imageUrl;
        });
      }
      if (audio != null) {
        Reference ref = _storage.ref().child('audio/$uid/$uuid.mp3');
        UploadTask uploadTask = ref.putFile(audio);
        await uploadTask.whenComplete(() async {
          String audioUrl = await ref.getDownloadURL();
          noteData["audioUrl"] = audioUrl;
        });
      }
      if (bytes != null) {
        Reference ref = _storage.ref().child('paint/$uid/$uuid.png');
        UploadTask uploadTask = ref.putData(bytes);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        String paintUrl = await taskSnapshot.ref.getDownloadURL();
        noteData["paintUrl"] = paintUrl;
      }
      await _firestore
          .collection(userCollection)
          .doc(uid)
          .collection(noteCollection)
          .doc(uuid)
          .set(noteData);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateNote(
      String uid,
      String title,
      String body,
      String id,
      File? image,
      File? audio,
      Uint8List? bytes,
      String imageUrl,
      String audioUrl,
      String paintUrl) async {
    var noteData = {
      "id": id,
      "title": title,
      "body": body,
      "creationDate": Timestamp.now(),
    };
    try {
      if (image != null) {
        Reference storageReference =
            FirebaseStorage.instance.ref().child('images/$uid/$id.jpg');
        UploadTask uploadTask = storageReference.putFile(image);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        noteData["imageUrl"] = imageUrl;
      } else {
        if (imageUrl != "") {
          noteData["imageUrl"] = imageUrl;
        }
      }
      if (audio != null) {
        Reference ref = _storage.ref().child('audio/$uid/$id.mp3');
        UploadTask uploadTask = ref.putFile(audio);
        await uploadTask.whenComplete(() async {
          String audioUrl = await ref.getDownloadURL();
          noteData["audioUrl"] = audioUrl;
        });
      } else {
        if (audioUrl != "") {
          noteData["audioUrl"] = audioUrl;
        }
      }
      if (bytes != null) {
        final FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref().child('paint/$uid/$id.png');
        UploadTask uploadTask = ref.putData(bytes);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        String paintUrl = await taskSnapshot.ref.getDownloadURL();
        noteData["paintUrl"] = paintUrl;
      } else {
        if (paintUrl != "") {
          noteData["paintUrl"] = paintUrl;
        }
      }
      await _firestore
          .collection(userCollection)
          .doc(uid)
          .collection(noteCollection)
          .doc(id)
          .set(noteData);
    } catch (e) {
      print(e); //e.masage
    }
  }

  Future<void> delete(String uid, String id) async {
    try {
      await _firestore
          .collection(userCollection)
          .doc(uid)
          .collection(noteCollection)
          .doc(id)
          .delete();
    } catch (e) {
      print(e); //.message);
    }
  }

  Stream<List<NoteModel>> noteStream(String uid) {
    return _firestore
        .collection(userCollection)
        .doc(uid)
        .collection(noteCollection)
        .orderBy("creationDate", descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<NoteModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(NoteModel.fromDocumentSnapshot(element));
      }
      return retVal;
    });
  }
}
