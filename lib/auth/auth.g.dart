// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Auth on AuthBase, Store {
  final _$userAtom = Atom(name: 'AuthBase.user');

  @override
  User? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  final _$isLoadingAtom = Atom(name: 'AuthBase.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$errorAtom = Atom(name: 'AuthBase.error');

  @override
  String get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  final _$loginAsyncAction = AsyncAction('AuthBase.login');

  @override
  Future<dynamic> login(dynamic email, dynamic password) {
    return _$loginAsyncAction.run(() => super.login(email, password));
  }

  final _$registerAsyncAction = AsyncAction('AuthBase.register');

  @override
  Future<dynamic> register(dynamic email, dynamic password) {
    return _$registerAsyncAction.run(() => super.register(email, password));
  }

  final _$logoutAsyncAction = AsyncAction('AuthBase.logout');

  @override
  Future<dynamic> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  @override
  String toString() {
    return '''
user: ${user},
isLoading: ${isLoading},
error: ${error}
    ''';
  }
}
