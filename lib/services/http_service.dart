import 'dart:io';
import 'dart:convert';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:marketsapce_app/services/auth_service.dart';
import 'package:marketsapce_app/@exceptions/api_exceptions.dart';

class HttpService {
  final String _baseUrl =
      'https://careful-previously-opossum.ngrok-free.app/api';

  final Map<String, String> _headers = <String, String>{};

  Future<GETResponse> get({
    required String endpoint,
    Map<String, String>? headers,
  }) async {
    _headers.clear();

    final token = await AuthService().getToken();

    _headers['Authorization'] = 'Bearer $token';

    if (headers != null) {
      headers.forEach((key, value) {
        _headers.addAll({key: value});
      });
    }

    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/$endpoint"),
        headers: _headers,
      );

      return _handleGETResponse(response);
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    _headers.clear();

    final token = await AuthService().getToken();

    _headers['Authorization'] = 'Bearer $token';
    _headers['Content-Type'] = "application/json";

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/$endpoint"),
        headers: _headers,
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    _headers.clear();

    final token = await AuthService().getToken();

    _headers['Authorization'] = 'Bearer $token';
    _headers['Content-Type'] = "application/json";

    try {
      final response = await http.put(
        Uri.parse("$_baseUrl/$endpoint"),
        headers: _headers,
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> patch(String endpoint, [Map<String, dynamic>? data]) async {
    final token = await AuthService().getToken();

    try {
      final request = http.Request('PATCH', Uri.parse("$_baseUrl/$endpoint"));

      request.headers.addAll({"Authorization": 'Bearer $token'});

      if (data != null) {
        request.headers.addAll({"Content-Type": 'application/json'});
        request.body = jsonEncode(data);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> delete(String endpoint) async {
    _headers.clear();

    final token = await AuthService().getToken();

    _headers['Authorization'] = 'Bearer $token';

    try {
      final response = await http.delete(
        Uri.parse("$_baseUrl/$endpoint"),
        headers: _headers,
      );

      return _handleResponse(response);
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> multiPartRequest(String endpoint, List<File> files) async {
    final token = await AuthService().getToken();

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("$_baseUrl/$endpoint"),
      );

      for (var file in files) {
        final mimeType = lookupMimeType(file.path);

        final [type, subtype] = mimeType!.split('/');

        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            file.path,
            contentType: MediaType(type, subtype),
          ),
        );
      }

      request.headers.addAll({"Authorization": 'Bearer $token'});

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (error) {
      print('multipart error: $error');
      rethrow;
    }
  }

  /// Controla o cache. Valida a inclusão do ETag nos headers e o tipo resposta 304
  GETResponse _handleGETResponse(http.Response response) {
    // parse Cache-Control: ex: "public, max-age=900, must-revalidate"
    int? maxAge;
    final cacheControl = response.headers['cache-control'];

    if (cacheControl != null) {
      final m = RegExp(r'max-age=(\d+)').firstMatch(cacheControl);
      if (m != null) maxAge = int.tryParse(m.group(1)!);
    }

    if (response.statusCode == 401) {
      final data = jsonDecode(response.body);

      if (data['code'] == 'AUTH_EXPIRED_TOKEN') {
        refreshToken().then((value) {}).catchError((error) {
          throw ApiExceptions(code: data['code'], message: data['message']);
        });

        throw ApiExceptions(code: data['code'], message: data['message']);
      }

      throw ApiExceptions(code: data['code'], message: data['message']);
    } else if (response.statusCode == 304) {
      final toResponse = GETResponse(
        headers: response.headers,
        body: null,
        notModified: true,
        maxAge: null,
      );

      return toResponse;
    } else if (response.statusCode >= 200 && response.statusCode < 300) {
      final toResponse = GETResponse(
        headers: response.headers,
        body: jsonDecode(response.body),
        notModified: false,
        maxAge: maxAge,
      );

      return toResponse;
    } else {
      final data = jsonDecode(response.body);

      throw ApiExceptions(code: data['code'], message: data['message']);
    }
  }

  dynamic _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);

    if (response.statusCode == 401) {
      if (data['code'] == 'AUTH_EXPIRED_TOKEN') {
        refreshToken().then((value) {}).catchError((error) {
          throw ApiExceptions(code: data['code'], message: data['message']);
        });

        throw ApiExceptions(code: data['code'], message: data['message']);
      }
      throw ApiExceptions(code: data['code'], message: data['message']);
    } else if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw ApiExceptions(code: data['code'], message: data['message']);
    }
  }

  Future<void> refreshToken() async {
    final token = await AuthService().getToken();

    final response = await http.patch(
      Uri.parse("$_baseUrl/auth/refresh-token"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await AuthService().saveToken(data['token']);
    } else {
      await AuthService().removeToken();
      throw Exception("Sessão expirada. Faça login novamente.");
    }
  }
}

class GETResponse {
  final Map<String, String> headers;
  final dynamic body;
  final bool notModified;
  final int? maxAge;

  const GETResponse({
    required this.headers,
    required this.body,
    this.notModified = false,
    this.maxAge,
  });
}
