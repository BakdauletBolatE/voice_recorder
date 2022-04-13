import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:voice_recorder/auth/auth.dart';
import 'package:voice_recorder/auth/models.dart';
import 'package:voice_recorder/pages/message/messages.dart';
import 'package:voice_recorder/utils/sound_player.dart';
import 'package:voice_recorder/utils/sound_recorder.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class MessageDetailPage extends StatefulWidget {
  MessageDetailPage({Key? key, required this.chatRoomId, required this.user})
      : super(key: key);

  final String chatRoomId;
  final UserJson user;

  @override
  State<MessageDetailPage> createState() => _MessageDetailPageState();
}

class _MessageDetailPageState extends State<MessageDetailPage> {
  SoundRecorder recorder = SoundRecorder();

  @override
  void initState() {
    recorder.init();
    super.initState();
  }

  @override
  void dispose() {
    recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void toggleVoice() {
      Auth auth = Provider.of<Auth>(context, listen: false);

      recorder.toggleRecorder(widget.chatRoomId, auth.user!.uid);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user.email.toString(),
          style: (const TextStyle(fontSize: 16)),
        ),
      ),
      body: Stack(alignment: Alignment.center, children: [
        Messages(chatRoomId: widget.chatRoomId, recorder: recorder),
        Positioned(
          bottom: 20,
          child: GestureDetector(
            onTap: toggleVoice,
            child: Observer(
              builder: (_) => RippleAnimation(
                color: Theme.of(context).primaryColor,
                minRadius: recorder.isRecording ? 30 : 0,
                repeat: true,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: DecoratedBox(
                    decoration:
                        BoxDecoration(color: Theme.of(context).primaryColor),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Icon(
                        recorder.isRecording ? Icons.pause : Icons.mic,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
