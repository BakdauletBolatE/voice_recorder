import 'package:firebase_auth/firebase_auth.dart';
import 'package:voice_recorder/services/auth.dart';

import 'package:mobx/mobx.dart';

part 'auth.g.dart';

class Auth = AuthBase with _$Auth;

abstract class AuthBase with Store {
  @observable
  User? user = FirebaseAuth.instance.currentUser;

  @observable
  bool isLoading = false;

  @observable
  String error = '';

  @action
  Future login(email, password) async {
    isLoading = true;

    AuthService service = AuthService();

    try {
      UserCredential userCredential = await service.login(email, password);
      isLoading = false;
      error = '';
      return user = userCredential.user;
    } catch (e) {
      isLoading = false;
      error = e.toString();
      print(e);
      throw Exception('ошибка');
    }
  }

  @action
  Future register(email, password) async {
    isLoading = true;

    AuthService service = AuthService();

    try {
      User userCredential = await service.register(email, password);
      isLoading = false;
      error = '';
      return user = userCredential;
    } catch (e) {
      isLoading = false;
      error = e.toString();
      print(e);
      throw Exception('ошибка');
    }
  }

  @action
  Future logout() async {
    isLoading = true;

    AuthService service = AuthService();

    try {
      await service.logout();
      isLoading = false;
      print('what');
      user = null;
    } catch (e) {
      isLoading = false;
      user = null;
      error = 'Что то пошло не так!';
      print(e);
    }
  }
}
