// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound_recorder.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SoundRecorder on SoundRecorderBase, Store {
  final _$isRecordingAtom = Atom(name: 'SoundRecorderBase.isRecording');

  @override
  bool get isRecording {
    _$isRecordingAtom.reportRead();
    return super.isRecording;
  }

  @override
  set isRecording(bool value) {
    _$isRecordingAtom.reportWrite(value, super.isRecording, () {
      super.isRecording = value;
    });
  }

  final _$isLoadingUploadAtom = Atom(name: 'SoundRecorderBase.isLoadingUpload');

  @override
  bool get isLoadingUpload {
    _$isLoadingUploadAtom.reportRead();
    return super.isLoadingUpload;
  }

  @override
  set isLoadingUpload(bool value) {
    _$isLoadingUploadAtom.reportWrite(value, super.isLoadingUpload, () {
      super.isLoadingUpload = value;
    });
  }

  final _$toggleRecorderAsyncAction =
      AsyncAction('SoundRecorderBase.toggleRecorder');

  @override
  Future<dynamic> toggleRecorder(String chatRoomId, String userId) {
    return _$toggleRecorderAsyncAction
        .run(() => super.toggleRecorder(chatRoomId, userId));
  }

  @override
  String toString() {
    return '''
isRecording: ${isRecording},
isLoadingUpload: ${isLoadingUpload}
    ''';
  }
}
