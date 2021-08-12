import 'package:shared_preferences/shared_preferences.dart';

const IS_LOCAL = "IS_LOCAL";

class LocalModule {
  static final _instance = LocalModule._internal();

  factory LocalModule() => _instance;

  LocalModule._internal();

  static SharedPreferences _sp;

  Future<SharedPreferences> get sp async {
    if (_sp != null) return _sp;
    _sp = await SharedPreferences.getInstance();
    return _sp;
  }

  saveLocalCheck(bool b) async {
    final prefs = await sp;
    await prefs.setBool(IS_LOCAL, b);
  }

  Future<bool> getLocalCheck() async {
    final prefs = await sp;
    return prefs.getBool(IS_LOCAL);
  }
}
