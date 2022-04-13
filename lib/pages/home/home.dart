import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_recorder/auth/auth.dart';
import 'package:voice_recorder/pages/home/contacts.dart';
import 'package:voice_recorder/pages/home/header.dart';
import 'package:voice_recorder/pages/home/last_contacts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: () async {
          log('hello');
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: HomeHeader()),
            const SizedBox(
              height: 30,
            ),
            LastContacts(),
            const SizedBox(
              height: 30,
            ),
            Contacts(),
            const SizedBox(
              height: 100,
            ),
          ]),
        ),
      )),
    );
  }
}
