import 'dart:convert';

import 'package:ep_grn/modules/local.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

const BASE_LOCAL_URL = "http://192.168.8.6";
const BASE_GLOBAL_URL = "http://epgroup.dyndns.org:5031";

class UpdateAppVerNotifier with ChangeNotifier {
  final _verCodeSubject = BehaviorSubject<int>();
  final _verNameSubject = BehaviorSubject<String>();
  final _appCodeSubject = BehaviorSubject<String>();

  Stream<int> get verCodeStream => _verCodeSubject.stream;

  Stream<String> get verNameStream => _verNameSubject.stream;

  Stream<String> get appCodeStream => _appCodeSubject.stream;

  final _errMsgSubject = BehaviorSubject<String>.seeded(null);

  Stream<String> get errMsgStream => _errMsgSubject.stream;

  @override
  void dispose() {
    _verCodeSubject.close();
    _verNameSubject.close();
    _appCodeSubject.close();
    _errMsgSubject.close();
    super.dispose();
  }

  UpdateAppVerNotifier() {
    _init();
  }

  _init() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    _verCodeSubject.add(int.tryParse(info.buildNumber));
    _verNameSubject.add(info.version);
    _appCodeSubject.add(info.packageName);
  }

  void updateApp() async {
    String url = "/api/info/mobile/apps/${_appCodeSubject.value}/latest";

    try {
      final isLocal = await LocalModule().getLocalCheck() ?? false;
      if (isLocal) {
        url = BASE_LOCAL_URL + url;
      } else {
        url = BASE_GLOBAL_URL + url;
      }

      final response = await http.get(url);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final res = jsonDecode(response.body);
        final latestVerCode = int.tryParse(res['version_code'].toString());
        final latestVerDownloadLink = res['download_link'].toString();

        if (latestVerCode > _verCodeSubject.value) {
          if (await canLaunch(latestVerDownloadLink)) {
            await launch(latestVerDownloadLink);
          } else {
            _errMsgSubject.add("Cannot launch download apk url");
            _errMsgSubject.add(null);
          }
        } else if (latestVerCode == _verCodeSubject.value) {
          _errMsgSubject.add("Current app is the latest version");
          _errMsgSubject.add(null);
        } else {
          _errMsgSubject
              .add("Current Ver : ${_verCodeSubject.value} \nLatest Ver : $latestVerCode");
          _errMsgSubject.add(null);
        }
      } else {
        _errMsgSubject.add(response.body);
        _errMsgSubject.add(null);
      }
    } catch (e) {
      _errMsgSubject.add(e.toString());
      _errMsgSubject.add(null);
    }
  }
}
