import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:yolo_movies_app/constants/app_constants.dart';

part 'api_response.dart';

// ApiService Singleton for making api calls throughout the app
class ApiService {
  late final Dio _client;

  static ApiService? _instance;
  factory ApiService() => _instance ??= ApiService._();

  ApiService._() {
    _client = Dio();
    _client.options.baseUrl = AppConstants.baseUrl;
    _client.options.headers['Authorization'] =
        'Bearer ${AppConstants.authToken}';
  }

  Future<ApiResponse> get({required String urlPath}) async {
    try {
      final response = await _client.get(urlPath);
      return _parseResponse(response);
    } catch (e) {
      return _parseException(e);
    }
  }

  // Load binary for the given image
  Future<Uint8List?> loadImageBinary(String? imageUrl) async {
    try {
      if (imageUrl == null || imageUrl.isEmpty) return null;
      final response = await _client.get(
        AppConstants.imageBaseUrl + imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final apiResponse = _parseResponse(response);

      if (apiResponse is SuccessResponse && apiResponse.data is Uint8List) {
        return apiResponse.data;
      } else {
        throw 'Error occured while loading image';
      }
    } catch (e) {
      return null;
    }
  }

  ApiResponse _parseException(dynamic e) {
    if (e is DioError && e.response != null) {
      return _parseResponse(e.response!);
    }
    return ErrorResponse(e.toString());
  }

  ApiResponse _parseResponse(Response response) {
    int? statusCode = response.statusCode;

    if (statusCode == null) {
      return ErrorResponse('Error occured while communicating with server');
    }

    if (statusCode >= 200 && statusCode < 300) {
      return SuccessResponse(response.data);
    }

    switch (statusCode) {
      case 400:
        return ErrorResponse('Bad request');
      case 401:
        return ErrorResponse('Unauthorized');
      case 403:
        return ErrorResponse('Forbidden');
      case 404:
        return ErrorResponse('Not found');
      case 500:
      default:
        return ErrorResponse('Error occured while communicating with server');
    }
  }
}
