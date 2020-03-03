import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const USERNAME = "UC_USERNAME";
const PASSWORD = "UC_PASSWORD";

class UserCredentialModule {
  String _username;
  String _password;
  SharedPreferences _sp;

  String get username => _username;

  static final _instance = UserCredentialModule._internal();

  factory UserCredentialModule() => _instance;

  UserCredentialModule._internal();

  init() async {
    _sp = await SharedPreferences.getInstance();
    _username = _sp.getString(USERNAME) ?? null;
    _password = _sp.getString(PASSWORD) ?? null;
  }

  String get basicAuth {
    if (_username == null && _password == null) {
      return null;
    }
    return 'Basic ' + base64.encode(utf8.encode('$_username:$_password'));
  }

  Future<void> setInfo(String username, String password) async {
    _username = username;
    _password = password;
    await _sp.setString(USERNAME, username);
    await _sp.setString(PASSWORD, password);
  }

  Future<void> clear() async {
    _username = null;
    _password = null;
    await _sp.setString(USERNAME, null);
    await _sp.setString(PASSWORD, null);
  }
}
