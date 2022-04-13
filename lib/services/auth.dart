import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<UserCredential> login(email, password) async {
    return await auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<User> register(email, password) async {
    User? user = (await auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    await users.doc(user!.uid).set({"email": email});
    return user;
  }

  Future updatePhotoToUserWithFile(User user, File file) async {
    try {
      Uuid uuid = Uuid();
      String fileName = basename(file.path);
      final refStorage = await firebase_storage.FirebaseStorage.instance
          .ref('users-photos/${uuid.v4()}$fileName')
          .putFile(file);
      String url = await refStorage.ref.getDownloadURL();
      user.updatePhotoURL(url);
      await users.doc(user.uid).update({"photoURL": url});
    } catch (e) {
      print(e);
    }
  }

  Future logout() async {
    return await auth.signOut();
  }
}
