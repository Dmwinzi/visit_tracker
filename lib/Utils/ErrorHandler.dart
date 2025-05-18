import 'package:dio/dio.dart';

Exception handleDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return Exception('Connection timed out. Please check your internet.');

    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode ?? 0;
      if (statusCode == 401) {
        return Exception('Unauthorized. Please login again.');
      } else if (statusCode == 404) {
        return Exception('Resource not found.');
      } else if (statusCode >= 500) {
        return Exception('Server error. Please try later.');
      } else {
        return Exception('Received invalid status code: $statusCode');
      }

    case DioExceptionType.cancel:
      return Exception('Request was cancelled.');

    case DioExceptionType.unknown:
      return Exception('Unexpected error occurred: ${error.message}');

    case DioExceptionType.badCertificate:
      return Exception('Bad certificate.');

    case DioExceptionType.connectionError:
      return Exception('Connection error. Please check your network.');

    default:
      return Exception('Something went wrong: ${error.message}');
  }
}
