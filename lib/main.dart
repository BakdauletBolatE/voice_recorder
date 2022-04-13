import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:voice_recorder/auth/auth.dart';
import 'package:voice_recorder/pages/home/home.dart';
import 'package:voice_recorder/pages/welcome.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

Map<int, Color> color = const {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      Provider<Auth>(create: (_) => Auth()),
    ],
    child: RecordMessage(),
  ));
}

// ignore: must_be_immutable
class RecordMessage extends StatelessWidget {
  RecordMessage({Key? key}) : super(key: key);

  MaterialColor colorCustom = MaterialColor(0xFF016FB9, color);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Voice Messenger',
        theme: ThemeData(
            primaryColor: const Color.fromRGBO(1, 111, 185, 1),
            primarySwatch: colorCustom,
            textTheme:
                GoogleFonts.outfitTextTheme(Theme.of(context).textTheme)),
        home: const MainPage());
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);

    return Observer(
      builder: (_) => auth.user != null ? const HomePage() : WelcomePage(),
    );
  }
}
