import 'package:ep_grn/models/user_profile.dart';
import 'package:ep_grn/modules/api.dart';
import 'package:dio/dio.dart';
import 'package:ep_grn/utils/error.dart';
import 'package:flutter/foundation.dart';

import 'package:ep_grn/modules/user_credential.dart';
import 'package:flutter/services.dart';

enum Status { Initializing, Authenticated, Unauthenticated }

class UserRepositoryNotifier with ChangeNotifier {
  Status _status = Status.Initializing;
  bool _isLoading = false;
  UserProfile _userProfile = UserProfile();
  UserCredentialModule _uc = UserCredentialModule();

  Status get status => _status;

  bool get isLoading => _isLoading;

  UserProfile get userProfile => _userProfile;

  Future<String> init() async {
    await _uc.init();
    String msg;

    if (_uc.basicAuth == null) {
      _status = Status.Unauthenticated;
    } else {
      try {
        await getUserProfile();
        _status = Status.Authenticated;
      } on DioError catch (e) {
        if (e.type == DioErrorType.RESPONSE) {
          if (e.response.statusCode >= 400 && e.response.statusCode < 500) {
            _status = Status.Unauthenticated;
            msg = e.toString();
          } else {
            msg = "Server Error, please try again later\n${e.toString()}";
          }
        } else {
          msg = "Network Error, please try again later\n${e.toString()}";
        }
      } catch (e) {
        msg = "Unexpected Error, please try again later\n${e.toString()}";
      }
    }
    await Future.delayed(Duration(seconds: 1));
    notifyListeners();
    return msg;
  }

  Future<String> signIn(String username, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await Future.delayed(Duration(seconds: 1));
      await _uc.setInfo(username, password);
      await (await Api().dio).get('', queryParameters: {'r': 'apiMobileAuth/loginV2'});
      await getUserProfile();
      _status = Status.Authenticated;
      return null;
    } catch (e) {
      _uc.clear();
      return formatApiErrorMsg(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getUserProfile() async {
    final response = await (await Api().dio).get('', queryParameters: {'r': 'apiMobileAuth/profile'});
    _userProfile = UserProfile.fromJson(response.data);
  }

  Future<void> signOut() async {
    await _uc.clear();
    _status = Status.Unauthenticated;
    notifyListeners();
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}
