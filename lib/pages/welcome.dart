import 'package:flutter/material.dart';
import 'package:voice_recorder/pages/login.dart';
import 'package:voice_recorder/pages/register.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> stateKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    void navigateToLogin() {
      var route = MaterialPageRoute(builder: (context) => const LoginPage());
      Navigator.of(context).push(route);
    }

    void navigateToRegister() {
      var route = MaterialPageRoute(builder: (context) => const RegisterPage());
      Navigator.of(context).push(route);
    }

    return Scaffold(
      key: stateKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'assets/images/background.png',
                        width: size.width,
                        height: size.height / 2,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      height: 27,
                    ),
                    const Text(
                      'Регистрируйтесь',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(70, 68, 68, 1)),
                    ),
                    const Text(
                      'Чтобы пользоваться',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(70, 68, 68, 1)),
                    ),
                    const SizedBox(height: 70),
                    Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                          ),
                          onPressed: navigateToLogin,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            child: Text('Войти',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                          ),
                        )),
                        Expanded(
                            child: ElevatedButton(
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromRGBO(243, 243, 243, 1))),
                          onPressed: navigateToRegister,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            child: Text('Регистрация',
                                style: TextStyle(
                                    color: Color.fromRGBO(70, 68, 68, 1),
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                          ),
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
