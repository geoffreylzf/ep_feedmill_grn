import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ep_grn/modules/local.dart';
import 'package:ep_grn/modules/user_credential.dart';
import 'package:flutter/foundation.dart';

const BASE_LOCAL_URL = "http://192.168.8.1:8833/eperp/index.php";
const BASE_GLOBAL_URL = "http://epgroup.dyndns.org:8833/eperp/index.php";
const CONNECT_TIMEOUT = 5000;
const RECEIVE_TIMEOUT = 3000;

_parseAndDecode(String response) {
  return jsonDecode(response);
}

_parseJson(String text) {
  return compute(_parseAndDecode, text);
}

class Api {
  Dio _dioLocal, _dioGlobal;

  static final _instance = Api._internal();

  factory Api() => _instance;

  Api._internal() {
    _dioLocal = Dio();
    _dioLocal.options.baseUrl = BASE_LOCAL_URL;
    _dioLocal.options.connectTimeout = CONNECT_TIMEOUT;
    _dioLocal.options.receiveTimeout = RECEIVE_TIMEOUT;
    (_dioLocal.transformer as DefaultTransformer).jsonDecodeCallback = _parseJson;
    _dioLocal.interceptors.add(
      InterceptorsWrapper(onRequest: (RequestOptions options) async {
        final basicAuth = UserCredentialModule().basicAuth;
        if (basicAuth != null) {
          options.headers["Authorization"] = basicAuth;
        }
        return options;
      }, onError: (DioError error) async {
        return error;
      }),
    );
    // _dioLocal.interceptors.add(LogInterceptor());


    _dioGlobal = Dio();
    _dioGlobal.options.baseUrl = BASE_GLOBAL_URL;
    _dioGlobal.options.connectTimeout = CONNECT_TIMEOUT;
    _dioGlobal.options.receiveTimeout = RECEIVE_TIMEOUT;
    (_dioGlobal.transformer as DefaultTransformer).jsonDecodeCallback = _parseJson;
    _dioGlobal.interceptors.add(
      InterceptorsWrapper(onRequest: (RequestOptions options) async {
        final basicAuth = UserCredentialModule().basicAuth;
        if (basicAuth != null) {
          options.headers["Authorization"] = basicAuth;
        }
        return options;
      }, onError: (DioError error) async {
        return error;
      }),
    );
    // _dioGlobal.interceptors.add(LogInterceptor());
  }

  Future<Dio> get dio async {
    final isLocal = await LocalModule().getLocalCheck() ?? false;
    if (isLocal) {
      return _dioLocal;
    }
    return _dioGlobal;
  }
}
