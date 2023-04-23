import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  late String id;
  late String title;
  late String body;
  late Timestamp creationDate;
  String? imageUrl;
  String? recordingUrl;
  String? paintUrl;

  NoteModel(
      {this.id = '',
      this.title = '',
      this.body = '',
      this.imageUrl,
      this.recordingUrl,
      this.paintUrl,
      required this.creationDate});

  NoteModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot["id"];
    title = documentSnapshot["title"];
    body = documentSnapshot["body"];
    creationDate = documentSnapshot["creationDate"];
    Map<String, dynamic>? data =
        documentSnapshot.data() as Map<String, dynamic>?;
    if (data != null && data.containsKey("imageUrl")) {
      imageUrl = data["imageUrl"];
    }
    if (data != null && data.containsKey("recordingUrl")) {
      recordingUrl = data["recordingUrl"];
    }
    if (data != null && data.containsKey("paintUrl")) {
      paintUrl = data["paintUrl"];
    }
  }
}
