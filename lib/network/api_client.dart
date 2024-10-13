import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ask_qx/firebase/remote_config_service.dart';
import 'package:ask_qx/global/app_data_provider.dart';
import 'package:ask_qx/network/error_handler.dart';
import 'package:ask_qx/services/method_channel_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../global/app_config.dart';
import '../global/app_storage.dart';

enum ServerType { user, askQx, subscription }

class ApiClient {
  //Singleton Pattern
  ApiClient._() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (AppConfig.appId.isEmpty) {
            await RemoteConfigService.instance.fetch();
            options.headers.addAll(_header(_serverType));
            return handler.next(options);
          } else {
            return handler.next(options);
          }
        },
        onError: (e, handler) async {
          if (e.response != null &&
              e.response?.statusCode == 401 &&
              e.response!.realUri.toString().contains("refresh-token")) {
            streamSubscription?.cancel();
            AppStorage.logout();
            ErrorHandle.error("Session expired");
          } else if (e.response != null &&
              e.response?.statusCode == 401 &&
              !e.response!.realUri.toString().contains("refresh-token")) {
            final result = await accessToken();
            if (result) {
              e.requestOptions.headers["x-access-token"] =
                  AppStorage.getToken(); //App Storage;
              return handler.resolve(await _dio.fetch(e.requestOptions));
            } else {
              return handler.next(e);
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  static final ApiClient _client = ApiClient._();

  static ApiClient get client => _client;
  ServerType _serverType = ServerType.user;

  //Dio
  final Dio _dio = Dio();

  //BASE URL's
  String BASE_URL = "";
  String CHAT_BASE_URL = "";
  String SUBSCRIPTION_BASE_URL = "";
  String WEB_URL = "";

  //Headers
  Map<String, String> _header(ServerType type) {
    Map<String, String> map = {};

    map['x-app-id'] = AppConfig.appId;
    map['x-app-key'] = AppStorage.getAppKey();
    map['x-user-id'] = AppStorage.getUserId();
    map['content-type'] = "application/json";
    if (AppStorage.isLoggedIn()) {
      map['x-access-token'] = AppStorage.getToken();
    }

    switch (type) {
      case ServerType.user:
        map['x-api-key'] = AppConfig.apiKey;
      case ServerType.askQx:
        map['x-api-key'] = AppConfig.chatApiKey;
      case ServerType.subscription:
        map['x-api-key'] = AppConfig.subscriptionApiKey;
    }

    return map;
  }

  //Timeout Duration
  //This is for api request timeout
  Duration get timeout {
    return const Duration(seconds: 60);
  }

  //Request ID
  //Note: This request id is mandatory for all api call's
  //This is for error tracking
  Map<String, String> get requestId {
    return {
      "requestId":
          "${Platform.isAndroid ? "ANDROID" : "IOS"}_${DateTime.now().millisecondsSinceEpoch}"
    };
  }

  BaseOptions _getOption(ServerType serverType) {
    switch (serverType) {
      case ServerType.user:
        return BaseOptions(
          baseUrl: BASE_URL,
          headers: _header(serverType),
          connectTimeout: timeout,
          responseType: ResponseType.json,
        );

      case ServerType.askQx:
        return BaseOptions(
          baseUrl: CHAT_BASE_URL,
          headers: _header(serverType),
          connectTimeout: timeout,
          responseType: ResponseType.json,
        );
      case ServerType.subscription:
        return BaseOptions(
          baseUrl: SUBSCRIPTION_BASE_URL,
          headers: _header(serverType),
          connectTimeout: timeout,
          responseType: ResponseType.json,
        );
    }
  }

  //Init
  Future<void> init() async {
    MethodChannelService.instance.buildFlavor().then((value) {
      if (value == "dev") {
        BASE_URL = "https://askqx-user-service-dev.qxlabai.tech/v1/";
        CHAT_BASE_URL = "https://askqx-service-dev.qxlabai.tech/v1/";
        SUBSCRIPTION_BASE_URL =
            "https://askqx-subscription-service-dev.qxlabai.tech/v1/";
        WEB_URL = "https://askqx-dev.qxlabai.tech/";
      } else {
        BASE_URL = "https://askqx-user-service.qxlabai.com/v1/";
        CHAT_BASE_URL = "https://askqx-service.qxlabai.com/v1/";
        SUBSCRIPTION_BASE_URL =
            "https://askqx-subscription-service.qxlabai.com/v1/";
        WEB_URL = "https://askqx.qxlabai.com/";
      }
    });
  }

  //GET
  // Need to pass endpoints
  //eg. login, register, user
  Future<dynamic> getRequest(String endpoint,
      {ServerType serverType = ServerType.user,
      List<String> excludeHeader = const []}) async {
    try {
      _serverType = serverType;
      _dio.options = _getOption(serverType);
      _dio.options.headers
          .removeWhere((key, value) => excludeHeader.contains(key));
      final response = await _dio.get(endpoint, queryParameters: requestId);

      _log(response.requestOptions.uri.toString());
      _log(response.statusCode);
      _log(jsonEncode(response.data));

      // Map body  =  jsonDecode(response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        return Future.error(
            "${response.data['error']['code'] - response.data['error']['message']}");
      }
    } catch (e) {
      _log(e);
      return await _handleError(e);
    }
  }

  //Post
  // Need to pass endpoints & Body(Request)
  //eg.endpoint: login, request: {"name":"Deepak"}
  Future<dynamic> postRequest(String endpoint,
      {Map<String, dynamic> request = const {},
      ServerType serverType = ServerType.user}) async {
    try {
      _serverType = serverType;
      _dio.options = _getOption(serverType);
      final response = await _dio.post(endpoint,
          data: jsonEncode(request), queryParameters: requestId);

      _log(request.toString());
      _log(response.realUri.toString());
      _log(response.statusCode);
      _log(jsonEncode(response.data));

      Map body = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return body;
      } else {
        return Future.error(
            "${body['error']['code'] - body['error']['message']}");
      }
    } catch (e) {
      _log(request.toString());
      _log(e);
      return await _handleError(e);
    }
  }

  //Put
  // Need to pass endpoints & Body(Request)
  //eg.endpoint: login, request: {"name":"Deepak"}
  Future<dynamic> putRequest(String endpoint,
      {Map<String, dynamic> request = const {},
      ServerType serverType = ServerType.user}) async {
    try {
      _serverType = serverType;
      _dio.options = _getOption(serverType);
      final response = await _dio.put(endpoint,
          data: jsonEncode(request), queryParameters: requestId);

      _log(request.toString());
      _log(response.realUri.toString());
      _log(response.statusCode);
      _log(jsonEncode(response.data));

      Map body = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return body;
      } else {
        return Future.error(
            "${body['error']['code'] - body['error']['message']}");
      }
    } catch (e) {
      _log(request.toString());
      _log(e);
      return await _handleError(e);
    }
  }

  //Patch
  // Need to pass endpoints & Body(Request)
  //eg.endpoint: login, request: {"name":"Deepak"}
  Future<dynamic> patchRequest(String endpoint,
      {Map<String, dynamic> request = const {},
      ServerType serverType = ServerType.user}) async {
    try {
      _serverType = serverType;
      _dio.options = _getOption(serverType);

      final response = await _dio.patch(endpoint,
          data: jsonEncode(request), queryParameters: requestId);

      _log(response.realUri.toString());
      _log(response.statusCode);
      _log(jsonEncode(response.data));

      Map body = (response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return body;
      } else {
        return Future.error(
            "${body['error']['code'] - body['error']['message']}");
      }
    } catch (e) {
      _log(e);
      return await _handleError(e);
    }
  }

  //DELETE
  // Need to pass endpoints
  //eg. login, register, user
  Future<dynamic> deleteRequest(String endpoint,
      {Map<String, dynamic> request = const {},
      ServerType serverType = ServerType.user}) async {
    try {
      _serverType = serverType;
      _dio.options = _getOption(serverType);

      final response = await _dio.delete(endpoint,
          data: jsonEncode(request), queryParameters: requestId);

      _log(response.realUri.toString());
      _log(response.statusCode);
      _log(jsonEncode(response.data));

      Map body = (response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return body;
      } else {
        return Future.error(
            "${body['error']['code'] - body['error']['message']}");
      }
    } catch (e) {
      _log(e);
      return await _handleError(e);
    }
  }

  //Multipart
  // Need to pass endpoints
  // Need to pass body or request if any
  // Need to pass files in map if any
  Future<dynamic> multipart(String endpoint,
      {Map<String, dynamic> request = const {},
      Map<String, String> files = const {},
      ServerType serverType = ServerType.user}) async {
    try {
      _serverType = serverType;
      _dio.options = _getOption(serverType);

      var multipartFile = {};

      for (var item in files.entries) {
        multipartFile[item.key] = await MultipartFile.fromFile(item.value,
            filename: item.value.split("/").last);
      }

      FormData formData = FormData.fromMap({...request, ...multipartFile});
      final response = await _dio.patch(endpoint,
          data: formData, queryParameters: requestId);

      _log(response.realUri.toString());
      _log(response.statusCode);
      _log(jsonEncode(response.data));

      Map body = (response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return body;
      } else {
        return Future.error(
            "${body['error']['code'] - body['error']['message']}");
      }
    } catch (e) {
      _log(e);
      return await _handleError(e);
    }
  }

  //PUBLIC
  // Need to pass endpoints
  //eg. login, register, user
  Future<dynamic> request(
    String endpoint, {
    Map<String, dynamic> request = const {},
    Map<String, dynamic> header = const {},
    ServerType serverType = ServerType.user,
    String method = "POST",
  }) async {
    try {
      _serverType = serverType;
      _dio.options = _getOption(serverType);
      _dio.options.method = method;
      _dio.options.headers = header;

      final response = await _dio.request(endpoint,
          data: jsonEncode(request), queryParameters: requestId);

      _log(response.realUri.toString());
      _log(response.statusCode);
      _log(jsonEncode(response.data));

      Map body = (response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return body;
      } else {
        return Future.error(
            "${body['error']['code'] - body['error']['message']}");
      }
    } catch (e) {
      _log(e);
      return await _handleError(e);
    }
  }

  //Steam Request
  // Need to pass endpoints
  // Need to pass body or request if any
  StreamSubscription? streamSubscription;
  CancelToken? cancelToken;
  void stream(String endpoint,
      {required StreamController stream,
      Map<String, dynamic> request = const {},
      ServerType serverType = ServerType.user}) async {
    try {
      _serverType = serverType;
      _dio.options = _getOption(serverType);
      _dio.options.responseType = ResponseType.stream;

      Response<ResponseBody> streamResponse = await _dio.post(endpoint,
          data: request, queryParameters: requestId, cancelToken: cancelToken);

      streamSubscription = streamResponse.data?.stream.listen((event) {
        var message = utf8.decode(event);
        stream.add(message);
      }, onDone: () {
        streamSubscription?.cancel();
        cancelToken?.cancel();
        stream.close();
      }, onError: (s, s1) {
        debugPrint("s:$s,S1:$s1");
        stream.addError(AppDataProvider.serverError);
        stream.close();
        streamSubscription?.cancel();
        cancelToken?.cancel();
      });
    } catch (e) {
      _log(e);
      stream.addError(e.toString());
      stream.close();
      streamSubscription?.cancel();
      cancelToken?.cancel();
    }
  }

  //This is only for stream request
  void stopStream() {
    try {
      streamSubscription?.cancel();
      cancelToken?.cancel();
    } catch (_) {}
  }

  //This function is responsible for fetching new access token
  Future<bool>  accessToken() async {
    try {
      if (!AppConfig.isApiKeyAvailable()) {
        await RemoteConfigService.instance.fetch();
      }

      Map<String, dynamic> body = {
        "data": {
          "refreshToken": AppStorage.getRefreshToken(),
        }
      };
      _serverType = ServerType.user;
      _dio.options = _getOption(ServerType.user);
      final response = await _dio.post("/user/refresh-token",
          queryParameters: requestId, data: jsonEncode(body));

      if (response.statusCode == 200 || response.statusCode == 201) {
        bool isSuccess = response.data['success'];
        if (isSuccess) {
          AppStorage.setToken(response.data['data']['tokens']['accessToken']);
          AppStorage.setRefreshToken(
              response.data['data']['tokens']['refreshToken']);
        }
        return isSuccess;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  //This method only accessible within class
  //This will print log only in DEBUG mode
  //Fill free to change based on your requirement
  void _log(dynamic message) {
    if (kDebugMode) {
      log("Network Log => $message");
    }
  }

  Future<dynamic> _handleError(dynamic error) async {
    if (error is DioException) {
      if (error.response == null) {
        return Future.error(AppDataProvider.serverError);
      }
      switch (error.response?.statusCode) {
        case 422:
          return error.response!.data;
        case 502:
        case 503:
        case 504:
        case 404:
        case 400:
          return Future.error(AppDataProvider.serverError);
      }
    }
    return Future.error(error);
  }
}
