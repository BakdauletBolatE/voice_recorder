import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_recorder/auth/auth.dart';
import 'package:voice_recorder/auth/models.dart';
import 'package:voice_recorder/pages/message/message_detail.dart';

class LastContacts extends StatelessWidget {
  LastContacts({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);

    Query<Map<String, dynamic>> users = FirebaseFirestore.instance
        .collection('users')
        .where('email', isNotEqualTo: auth.user!.email);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Последние контакты',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        SizedBox(
            height: 59,
            child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: StreamBuilder<QuerySnapshot>(
                  stream: users.snapshots(),
                  builder: ((context, snapshot) {
                    if (snapshot.data == null) {
                      return const Text('Нет данных');
                    }

                    return ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 16,
                      ),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) => ListContactItem(
                          contact:
                              UserJson.fromJson(snapshot.data!.docs[index])),
                    );
                  }),
                )))
      ],
    );
  }
}

class ListContactItem extends StatelessWidget {
  const ListContactItem({Key? key, required this.contact}) : super(key: key);

  final UserJson contact;

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);

    String chatRoomId(String user1, String user2) {
      if (user1[0].toLowerCase().codeUnits[0] >
          user2.toLowerCase().codeUnits[0]) {
        return "$user1$user2";
      } else {
        return "$user2$user1";
      }
    }

    void navigateToMessage() {
      var route = MaterialPageRoute(
          builder: (_) => MessageDetailPage(
                chatRoomId: chatRoomId(contact.uid, auth.user!.uid),
                user: contact,
              ));

      Navigator.of(context).push(route);
    }

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
        onTap: navigateToMessage,
        child: Container(color: Colors.transparent, child: buildImage()));
  }
}
