import 'dart:convert';
import 'dart:io';
import 'package:gemini/services/log_service.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../core/constants/constants.dart';
import '../models/text_and_image_input_req.dart';
import '../models/text_only_image_input_req.dart';
import 'http_helper.dart';

class Network {
  static bool isTester = true;
  static String SERVER_DEV = "generativelanguage.googleapis.com";
  static String SERVER_PROD = "generativelanguage.googleapis.com";

  static final client = InterceptedClient.build(
    interceptors: [HttpInterceptor()],
    retryPolicy: HttpRetryPolicy(),
  );

  static String getServer() {
    if (isTester) return SERVER_DEV;
    return SERVER_PROD;
  }

  /* Http Requests */
  static Future<String?> GET(String api, Map<String, String> params) async {
    try {
      var uri = Uri.https(getServer(), api, params);
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        _throwException(response);
      }
    } on SocketException catch (_) {
      // if the network connection fails
      rethrow;
    }
  }

  static Future<String?> POST(String api, Map<String, dynamic> body) async {
    try {
      var uri = Uri.https(getServer(), api, paramsApiKey());
      var response = await client.post(uri, body: jsonEncode(body));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        _throwException(response);
      }
    } on SocketException catch (_) {
      // if the network connection fails
      rethrow;
    }
  }

  static _throwException(Response response) {
    String reason = response.reasonPhrase!;
    switch (response.statusCode) {
      case 400:
        throw BadRequestException(reason);
      case 401:
        throw InvalidInputException(reason);
      case 403:
        throw UnauthorisedException(reason);
      case 404:
        throw FetchDataException(reason);
      case 500:
      default:
        throw FetchDataException(reason);
    }
  }

  /* Http Apis*/
  static String API_TEXT_ONLY_INPUT =
      "/v1beta/models/gemini-1.5-flash:generateContent";
  static String API_TEXT_AND_IMAGE =
      "/v1beta/models/gemini-1.5-flash:generateContent";

  /* Http Params */
  static Map<String, String> paramsEmpty() {
    Map<String, String> params = {};
    return params;
  }

  static Map<String, String> paramsApiKey() {
    Map<String, String> params = {};
    params.addAll({
      'key': GEMINI_API_KEY
    });
    return params;
  }

  static Map<String, dynamic> paramsTextOnly(String text) {
    List<Part> parts = [Part(text: text)];
    List<Content> contents = [Content(parts: parts)];
    TextOnlyInputReq textOnlyInputReq = TextOnlyInputReq(contents: contents);
    return textOnlyInputReq.toJson();
  }

  static Map<String, dynamic> paramsTextAndImage(String text, String imageBase64) {
    String body = '';
    InlineData inlineData = InlineData(mime_type: 'image/jpg', data: imageBase64);
    List<Part2> parts = [Part2(inline_data: inlineData, text: 'What is this picture?')];
    List<Content2> contents = [Content2(parts: parts)];
    TextAndImageInputReq textOnlyInputReq = TextAndImageInputReq(contents: contents);

    LogService.i(textOnlyInputReq.toJson().toString());
    return textOnlyInputReq.toJson();
  }
}
