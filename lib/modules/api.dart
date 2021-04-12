import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ep_grn/modules/user_credential.dart';
import 'package:flutter/foundation.dart';

const BASE_URL = "http://192.168.8.1:8833/eperp/index.php";
//const BASE_URL = "http://192.168.8.30:8833/eperp/index.php";
const CONNECT_TIMEOUT = 5000;
const RECEIVE_TIMEOUT = 3000;

_parseAndDecode(String response) {
  return jsonDecode(response);
}

_parseJson(String text) {
  return compute(_parseAndDecode, text);
}

class Api {
  Dio _dio;

  static final _instance = Api._internal();

  factory Api() => _instance;

  Api._internal() {
    _dio = Dio();
    _dio.options.baseUrl = BASE_URL;
    _dio.options.connectTimeout = CONNECT_TIMEOUT;
    _dio.options.receiveTimeout = RECEIVE_TIMEOUT;
    (_dio.transformer as DefaultTransformer).jsonDecodeCallback = _parseJson;
    _dio.interceptors.add(
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
    _dio.interceptors.add(LogInterceptor());
  }

  Dio get dio => _dio;
}
