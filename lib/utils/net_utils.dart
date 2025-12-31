///网络请求工具类
import 'package:dio/dio.dart';

var dio = Dio(
  BaseOptions(
    connectTimeout: 5000,
    receiveTimeout: 3000,
    headers: {
      "User-Agent": "PostmanRuntime/7.29.0",
      "Accept": "*/*",
    },
  ),
);

class NetUtils {
  static init() {
    //不请求日志
    dio.interceptors.add(
      LogInterceptor(
        responseBody: false,
        request: false,
        requestHeader: false,
        responseHeader: false,
      ),
    );
  }

  //get
  static get(String url,
      {Map<String, dynamic>? params, Function? success, Function? fail}) async {
    try {
      Response response;
      if (params != null) {
        response = await dio.get(url, queryParameters: params);
      } else {
        response = await dio.get(url);
      }
      success!(response.data);
    } catch (exception) {
      fail!(exception);
    }
  }

  //post
  static post(String url, Map<String, dynamic> params,
      {Function? success, Function? fail}) async {
    try {
      Response response;
      dio.options.headers
          .addAll({'Content-Type': 'application/x-www-form-urlencoded'});
      response = await dio.post(url, data: params);
      success!(response.data);
    } catch (exception) {
      fail!(exception);
    }
  }
}
