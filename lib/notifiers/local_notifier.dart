import 'package:ep_grn/modules/local.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class LocalNotifier with ChangeNotifier {
  final _localCheckedSubject = BehaviorSubject<bool>();

  Stream<bool> get localCheckedStream => _localCheckedSubject.stream;


  @override
  void dispose() {
    _localCheckedSubject.close();
    super.dispose();
  }

  LocalNotifier(){
    _init();
  }

  _init() async {
    _localCheckedSubject.add(await LocalModule().getLocalCheck() ?? false);
  }

  setLocalChecked(bool b) async {
    await LocalModule().saveLocalCheck(b);
    _localCheckedSubject.add(b);
  }
}