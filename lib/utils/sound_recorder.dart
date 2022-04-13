import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';
import 'package:voice_recorder/auth/auth.dart';

part 'sound_recorder.g.dart';

class SoundRecorder = SoundRecorderBase with _$SoundRecorder;

abstract class SoundRecorderBase with Store {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  String fileName = const Uuid().v4();

  FlutterSoundRecorder? _soundRecorder;
  bool isRecordInited = false;

  @observable
  bool isRecording = false;

  @observable
  bool isLoadingUpload = false;

  void init() async {
    _soundRecorder = FlutterSoundRecorder();
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone permission not granted");
    }

    await _soundRecorder!.openAudioSession();
    isRecordInited = true;
  }

  void dispose() async {
    if (!isRecordInited) return;

    _soundRecorder!.closeAudioSession();
    isRecordInited = false;
  }

  void _record(filename) async {
    if (!isRecordInited) return;
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String pathToSaveAudio = '${appDocDir.path}/$filename.wav';
    log(pathToSaveAudio);
    await _soundRecorder!.startRecorder(toFile: pathToSaveAudio);
  }

  Future<String> _stop(filename) async {
    await _soundRecorder!.stopRecorder();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.path}/$filename.wav';
    return filePath;
  }

  Future _upload(filePath, filename, chatRoomId, userId) async {
    File file = File(filePath);

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    CollectionReference chats = firebaseFirestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('chats');

    try {
      final refStorage = await firebase_storage.FirebaseStorage.instance
          .ref('uploads/$filename.wav')
          .putFile(file);
      String url = await refStorage.ref.getDownloadURL();

      Map<String, dynamic> message = {
        "sendby": userId,
        "url": url,
        "time": FieldValue.serverTimestamp()
      };

      await chats.add(message);
    } catch (e) {
      print(e);
    }
  }

  @action
  Future toggleRecorder(String chatRoomId, String userId) async {
    if (!isRecordInited) return;

    if (_soundRecorder!.isStopped) {
      _record(fileName);
      isRecording = true;
    } else {
      String filePath = await _stop(fileName);
      isRecording = false;
      isLoadingUpload = true;
      await _upload(filePath, fileName, chatRoomId, userId);
      isLoadingUpload = false;

      fileName = const Uuid().v4();
    }
  }
}
