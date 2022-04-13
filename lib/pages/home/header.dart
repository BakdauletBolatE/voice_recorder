import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:voice_recorder/auth/auth.dart';
import 'package:voice_recorder/auth/models.dart';
import 'package:voice_recorder/pages/message/message_detail.dart';
import 'package:voice_recorder/services/auth.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);

    AuthService service = AuthService();

    FirebaseAuth authUser = FirebaseAuth.instance;

    Future<void> _showSearch() async {
      log('hello');
      await showSearch(
        context: context,
        delegate: TheSearch(),
        query: "",
      );
    }

    void logout() async {
      await auth.logout();
      Navigator.of(context).pop();
    }

    Future showModal() async {
      void updateUserPhotoUrl() async {
        final ImagePicker _picker = ImagePicker();
        final XFile? image =
            await _picker.pickImage(source: ImageSource.gallery);
        try {
          await service.updatePhotoToUserWithFile(
              authUser.currentUser!, File(image!.path));
        } catch (e) {
          print(e);
        }
      }

      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(auth.user!.email.toString()),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextButton(
                    onPressed: updateUserPhotoUrl,
                    child: StreamBuilder(
                        stream: authUser.authStateChanges(),
                        builder: (_, snapshot) {
                          if (snapshot.data == null) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                color: Colors.grey,
                                child: const Padding(
                                  padding: EdgeInsets.all(40),
                                  child: Icon(Icons.edit, color: Colors.white),
                                ) /* add child content here */,
                              ),
                            );
                          }

                          User user = snapshot.data as User;

                          if (user.photoURL == null) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                color: Colors.grey,
                                child: const Padding(
                                  padding: EdgeInsets.all(40),
                                  child: Icon(Icons.edit, color: Colors.white),
                                ) /* add child content here */,
                              ),
                            );
                          }

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: ExtendedNetworkImageProvider(
                                      user.photoURL!,
                                      cache: true),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(40),
                                child: Icon(Icons.edit, color: Colors.white),
                              ) /* add child content here */,
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Готово'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future showModalToExit() async {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Вы точно хотите выйти?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Нет'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Да'),
                onPressed: logout,
              ),
            ],
          );
        },
      );
    }

    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Контакты',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                SizedBox(
                  width: 40,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerRight),
                    onPressed: showModal,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor),
                        child: const Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerRight),
                    onPressed: showModalToExit,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor),
                        child: const Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.logout,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 22),
        TextField(
          onTap: _showSearch,
          decoration: InputDecoration(
              filled: true,
              label: const Text('Искать'),
              prefixIcon: const Icon(Icons.search),
              border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none)),
        )
      ],
    );
  }
}

class TheSearch extends SearchDelegate<String> {
  final suggestions1 = ["Bakdaulet@gmail.com"];

  @override
  String get searchFieldLabel => "Искайте друзей";

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(elevation: 0, color: Colors.white),
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
          color: Theme.of(context).primaryColor),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // final suggestions = query.isEmpty ? suggestions1 : [];

    Auth auth = Provider.of<Auth>(context);

    Query<Map<String, dynamic>> users = FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: query);

    String chatRoomId(String user1, String user2) {
      if (user1[0].toLowerCase().codeUnits[0] >
          user2.toLowerCase().codeUnits[0]) {
        return "$user1$user2";
      } else {
        return "$user2$user1";
      }
    }

    void navigateToMessage(UserJson user2) {
      var route = MaterialPageRoute(
          builder: (_) => MessageDetailPage(
              chatRoomId: chatRoomId(auth.user!.uid, user2.uid), user: user2));
      Navigator.of(context).push(route);
    }

    return StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (_, snapshot) {
          if (snapshot.data == null) {
            return const Text('Нет совпадений');
          }

          List<QueryDocumentSnapshot<Object?>> users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (content, index) => ListTile(
                leading: const Icon(Icons.arrow_left),
                title: GestureDetector(
                    onTap: () {
                      navigateToMessage(UserJson.fromJson(users[index]));
                    },
                    child: Text(UserJson.fromJson(users[index]).email))),
          );
        });
  }
}
