import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_recorder/auth/auth.dart';
import 'package:voice_recorder/auth/models.dart';
import 'package:voice_recorder/pages/message/message_detail.dart';
import 'package:voice_recorder/utils/date_formatter.dart';

class Contacts extends StatelessWidget {
  Contacts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);

    Query<Map<String, dynamic>> users = FirebaseFirestore.instance
        .collection('users')
        .where('email', isNotEqualTo: auth.user!.email);

    return ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        child: Container(
            padding:
                const EdgeInsets.only(top: 44, left: 24, right: 24, bottom: 44),
            color: const Color.fromRGBO(244, 244, 244, 1),
            child: StreamBuilder<QuerySnapshot>(
              stream: users.snapshots(),
              builder: ((context, snapshot) {
                if (snapshot.data == null) {
                  return const Text('Нет данных');
                }

                return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (_, index) => ContactItem(
                          contact:
                              UserJson.fromJson(snapshot.data!.docs[index]),
                        ),
                    separatorBuilder: (_, index) => const SizedBox(
                          height: 24,
                        ),
                    itemCount: snapshot.data!.docs.length);
              }),
            )));
  }
}

class ContactItem extends StatelessWidget {
  const ContactItem({Key? key, required this.contact}) : super(key: key);

  final UserJson contact;

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);

    void navigateToDetail() {
      var route = MaterialPageRoute(
          builder: (_) => MessageDetailPage(
                chatRoomId: chatRoomId(auth.user!.uid, contact.uid),
                user: contact,
              ));
      Navigator.of(context).push(route);
    }

    var chats = FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId(auth.user!.uid, contact.uid))
        .collection('chats')
        .limit(1)
        .get()
        .asStream();

    DateFormatter dateFormatter = DateFormatter();

    Widget buildImage() {
      if (contact.photoURL.isNotEmpty || contact.photoURL != "") {
        return SizedBox(
            width: 60,
            height: 60,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ExtendedImage.network(
                  contact.photoURL,
                  fit: BoxFit.cover,
                  cache: true,
                )));
      } else {
        return SizedBox(
            width: 60,
            height: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey),
              ),
            ));
      }
    }

    return GestureDetector(
      onTap: navigateToDetail,
      child: Container(
          color: Colors.transparent,
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: chats,
              builder: (_, snapshot) {
                if (snapshot.data == null) {
                  return const Text('Пусто');
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Row(children: [
                    buildImage(),
                    const SizedBox(
                      width: 14,
                    ),
                    Text(
                      contact.email.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ]);
                }

                Timestamp time = snapshot.data!.docs[0].data()['time'];

                return Row(children: [
                  buildImage(),
                  const SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                contact.email.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                dateFormatter.getVerboseDateTimeRepresentation(
                                    time.toDate()),
                                style: const TextStyle(
                                    color: Color.fromRGBO(168, 168, 168, 1)),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text('Аудио запись')
                        ]),
                  ),
                ]);
              })),
    );
  }
}
