part of 'api_service.dart';

abstract class ApiResponse {}

class SuccessResponse extends ApiResponse {
  final dynamic data;
  SuccessResponse(this.data);
}

class ErrorResponse extends ApiResponse {
  final String errorMessage;
  ErrorResponse(this.errorMessage);
}
