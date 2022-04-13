import 'package:cloud_firestore/cloud_firestore.dart';

class UserJson {
  late String uid;
  late String email;
  late String photoURL;

  UserJson.fromJson(snapshot) {
    uid = snapshot.id;
    photoURL = snapshot.data()['photoURL'] ?? "";
    email = snapshot.data()['email'];
  }
}

class VoiceMessage {
  late Timestamp time;
  late String url;
  late String sendby;

  VoiceMessage.fromJson(snapshot) {
    time = snapshot.data()['time'] ?? Timestamp.now();
    url = snapshot.data()['url'];
    sendby = snapshot.data()['sendby'] ?? '';
  }
}
