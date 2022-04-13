import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:voice_recorder/auth/models.dart';
import 'package:voice_recorder/utils/date_formatter.dart';
import 'package:voice_recorder/utils/sound_player.dart';
import 'package:voice_recorder/utils/sound_recorder.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key, required this.chatRoomId, required this.recorder})
      : super(key: key);

  final String chatRoomId;
  final SoundRecorder recorder;

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  ScrollController scrollController = ScrollController();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    onJumpTo();
  }

  void onJumpTo() async {
    log('1');
    await Future.delayed(const Duration(seconds: 1));
    log('2');
    if (scrollController.hasClients) {
      await scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 30),
          curve: Curves.linear);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firebaseFirestore
          .collection('chatrooms')
          .doc(widget.chatRoomId)
          .collection('chats')
          .orderBy('time')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Text('Нет данных');
        }
        return ListView.separated(
          controller: scrollController,
          padding:
              const EdgeInsets.only(right: 24, left: 24, top: 30, bottom: 100),
          shrinkWrap: true,
          separatorBuilder: (_, index) => const SizedBox(
            height: 20,
          ),
          itemBuilder: (_, index) => MessageItem(
            message: VoiceMessage.fromJson(snapshot.data!.docs[index]),
          ),
          itemCount: snapshot.data!.docs.length,
        );
      },
    );
  }
}

class MessageItem extends StatefulWidget {
  const MessageItem({Key? key, required this.message}) : super(key: key);

  final VoiceMessage message;

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  late SoundPlayer player;

  FirebaseAuth auth = FirebaseAuth.instance;

  DateFormatter dateFormatter = DateFormatter();

  @override
  void initState() {
    player = SoundPlayer(widget.message.url);
    player.init();
    super.initState();
  }

  void togglePlay() async {
    player.toggle();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return auth.currentUser!.uid == widget.message.sendby
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                  width: 40,
                  height: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: DecoratedBox(
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor),
                      child: StreamBuilder(
                          stream: player.playing,
                          builder: (context, asyncSnapshot) {
                            if (asyncSnapshot.data == null) {
                              return const CircularProgressIndicator();
                            }

                            final bool isPlaying = asyncSnapshot.data as bool;

                            return GestureDetector(
                              onTap: togglePlay,
                              child: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                size: 30,
                                color: Colors.white,
                              ),
                            );
                          }),
                    ),
                  )),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                  child: DecoratedBox(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(208, 208, 208, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(0),
                        topRight: Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: StreamBuilder(
                      stream: player.position,
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.data == null) {
                          return const SizedBox.shrink();
                        }

                        final Duration? duration =
                            asyncSnapshot.data as Duration;

                        return Row(children: [
                          StreamBuilder(
                              stream: player.current,
                              builder: (_, snapshot) {
                                if (snapshot.data == null) {
                                  return const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: CircularProgressIndicator());
                                }

                                final Playing? playing =
                                    snapshot.data as Playing;

                                return Stack(children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: SizedBox(
                                      width: 200,
                                      child: SliderTheme(
                                        data: const SliderThemeData(
                                          trackHeight: 3,
                                        ),
                                        child: Slider(
                                            max: playing!.audio.duration
                                                    .inMilliseconds /
                                                1000,
                                            min: 0,
                                            value:
                                                duration!.inMilliseconds / 1000,
                                            onChanged: (duration) {}),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      bottom: 2,
                                      left: 2,
                                      child: Text(dateFormatter
                                          .getVerboseDateTimeRepresentation(
                                              widget.message.time.toDate()))),
                                  StreamBuilder(
                                      stream: player.playing,
                                      builder: (_, isPlaying) => Positioned(
                                            bottom: 2,
                                            right: 2,
                                            child: Text(
                                              isPlaying.data == false
                                                  ? playing.audio.duration
                                                      .toString()
                                                      .split('.')
                                                      .first
                                                  : duration
                                                      .toString()
                                                      .split('.')
                                                      .first,
                                              textAlign: TextAlign.right,
                                            ),
                                          ))
                                ]);
                              })
                        ]);
                      }),
                ),
              )),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: 40,
                  height: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: DecoratedBox(
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor),
                      child: StreamBuilder(
                          stream: player.playing,
                          builder: (context, asyncSnapshot) {
                            if (asyncSnapshot.data == null) {
                              return const CircularProgressIndicator();
                            }

                            final bool isPlaying = asyncSnapshot.data as bool;

                            return GestureDetector(
                              onTap: togglePlay,
                              child: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                size: 30,
                                color: Colors.white,
                              ),
                            );
                          }),
                    ),
                  )),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                  child: DecoratedBox(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(208, 208, 208, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(0),
                        topRight: Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: StreamBuilder(
                      stream: player.position,
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.data == null) {
                          return const SizedBox.shrink();
                        }

                        final Duration? duration =
                            asyncSnapshot.data as Duration;

                        return Row(children: [
                          StreamBuilder(
                              stream: player.current,
                              builder: (_, snapshot) {
                                if (snapshot.data == null) {
                                  return const CircularProgressIndicator();
                                }

                                final Playing? playing =
                                    snapshot.data as Playing;

                                return Stack(children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: SizedBox(
                                      width: 200,
                                      child: SliderTheme(
                                        data: const SliderThemeData(
                                          trackHeight: 3,
                                        ),
                                        child: Slider(
                                            max: playing!.audio.duration
                                                    .inMilliseconds /
                                                1000,
                                            min: 0,
                                            value:
                                                duration!.inMilliseconds / 1000,
                                            onChanged: (duration) {}),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      bottom: 2,
                                      left: 2,
                                      child: Text(dateFormatter
                                          .getVerboseDateTimeRepresentation(
                                              widget.message.time.toDate()))),
                                  StreamBuilder(
                                      stream: player.playing,
                                      builder: (_, isPlaying) => Positioned(
                                            bottom: 2,
                                            right: 2,
                                            child: Text(
                                              isPlaying.data == false
                                                  ? playing.audio.duration
                                                      .toString()
                                                      .split('.')
                                                      .first
                                                  : duration
                                                      .toString()
                                                      .split('.')
                                                      .first,
                                              textAlign: TextAlign.right,
                                            ),
                                          ))
                                ]);
                              })
                        ]);
                      }),
                ),
              )),
            ],
          );
  }
}
