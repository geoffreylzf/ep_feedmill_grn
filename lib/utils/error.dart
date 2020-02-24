import 'package:dio/dio.dart';

String formatApiErrorMsg(dynamic e) {
  if (e is DioError) {
    return e.type == DioErrorType.RESPONSE ? e.response.toString() : e.toString();
  }

  return e.toString();
}
