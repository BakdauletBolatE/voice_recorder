import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:voice_recorder/auth/auth.dart';
import 'package:voice_recorder/main.dart';
import 'package:voice_recorder/pages/home/home.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    void register() async {
      try {
        await auth.register(_email.text, _password.text);
        var route = MaterialPageRoute(builder: (_) => const MainPage());
        Navigator.of(context).pushAndRemoveUntil(route, (route) => false);
      } catch (e) {
        print(e);
      }
    }

    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 80,
            ),
            Observer(builder: (_) {
              if (auth.error.isNotEmpty) {
                Fluttertoast.showToast(
                    msg: auth.error,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: const Color.fromRGBO(231, 76, 60, 1),
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
              return const SizedBox.shrink();
            }),
            SizedBox(
              width: width,
              child: const Text(
                'Добро пожаловать',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(70, 68, 68, 1)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                width: width,
                child: const Text(
                  'Для пользования нужна регистрация',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Colors.black),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            TextField(
                controller: _email,
                decoration: InputDecoration(
                  labelText: 'Введите почту',
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                  filled: true,
                )),
            const SizedBox(
              height: 10,
            ),
            TextField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Введите пароль',
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                  filled: true,
                )),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                  ),
                  onPressed: register,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Observer(
                        builder: (_) => Text(
                            auth.isLoading ? 'Загрузка' : 'Регистрация',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold))),
                  ),
                )),
              ],
            )
          ]),
        ),
      ),
    ));
  }
}
