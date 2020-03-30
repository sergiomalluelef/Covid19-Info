import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpUtils {
  static HttpUtils _instance = new HttpUtils.internal();

  HttpUtils.internal();

  factory HttpUtils() => _instance;

  Future<dynamic> get(String url, {Map headers, body, encoding}) {
    return http.get(url, headers: headers).then((http.Response response) {
      String res = response.body;
      final int statusCode = response.statusCode;
      print("Respuesta get: "+res.toString());
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error al recuperar datos");
      }
      return json.decode(res);
    });
  }

  Future<dynamic> post(String url, {Map headers, body, encoding}) {
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      print("Respuesta post: "+res.toString());

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error al recuperar datos");
      }
      return json.decode(res);
    });
  }

  Future<dynamic> patch(String url, {Map headers, body, encoding}) {
    return http
        .patch(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      print(res.toString());
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error al enviar datos");
      }
      return json.decode(res);
    });
  }


}
