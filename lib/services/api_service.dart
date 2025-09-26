import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../config/api_config.dart';

class ApiService {
  static final Dio _dio = Dio();
  
  static void initialize() {
    _dio.options.baseUrl = ApiConfig.baseUrl;
    _dio.options.connectTimeout = Duration(milliseconds: ApiConfig.timeout);
    _dio.options.receiveTimeout = Duration(milliseconds: ApiConfig.timeout);
    _dio.options.headers = ApiConfig.defaultHeaders;
    
    // 인터셉터 추가
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print(obj),
    ));
    
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        print('API Error: ${error.message}');
        handler.next(error);
      },
    ));
  }
  
  // GET 요청
  static Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }
  
  // POST 요청
  static Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
      );
      
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }
  
  // PUT 요청
  static Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
      );
      
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }
  
  // DELETE 요청
  static Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(endpoint);
      
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }
  
  // 응답 처리
  static ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    try {
      final data = response.data as Map<String, dynamic>;
      
      if (data['success'] == true) {
        final responseData = data['data'];
        
        if (fromJson != null && responseData != null) {
          // responseData가 List인 경우와 Map인 경우를 구분하여 처리
          if (responseData is List) {
            // List인 경우 빈 리스트이면 null 반환, 아니면 리스트 그대로 반환
            if (responseData.isEmpty) {
              return ApiResponse.success(
                null as T,
                message: data['message'] as String?,
              );
            } else {
              return ApiResponse.success(
                responseData as T,
                message: data['message'] as String?,
              );
            }
          } else if (responseData is Map<String, dynamic>) {
            return ApiResponse.success(
              fromJson(responseData),
              message: data['message'] as String?,
            );
          } else {
            // 기타 타입인 경우 그대로 반환
            return ApiResponse.success(
              responseData as T,
              message: data['message'] as String?,
            );
          }
        } else {
          return ApiResponse.success(
            responseData as T,
            message: data['message'] as String?,
          );
        }
      } else {
        final error = data['error'] as Map<String, dynamic>?;
        return ApiResponse.error(
          error?['code'] as String? ?? 'UNKNOWN_ERROR',
          error?['message'] as String? ?? '알 수 없는 오류가 발생했습니다.',
          details: error?['details'] as List<dynamic>?,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        'PARSE_ERROR',
        '응답 데이터를 파싱하는 중 오류가 발생했습니다: $e',
      );
    }
  }
  
  // 에러 처리
  static ApiResponse<T> _handleError<T>(DioException error) {
    String code = ApiConfig.serverError;
    String message = '서버 오류가 발생했습니다.';
    
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        code = 'TIMEOUT_ERROR';
        message = '요청 시간이 초과되었습니다.';
        break;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        switch (statusCode) {
          case 400:
            code = ApiConfig.validationError;
            message = '잘못된 요청입니다.';
            break;
          case 401:
            code = ApiConfig.unauthorizedError;
            message = '인증이 필요합니다.';
            break;
          case 403:
            code = ApiConfig.forbiddenError;
            message = '접근 권한이 없습니다.';
            break;
          case 404:
            code = ApiConfig.notFoundError;
            message = '요청한 리소스를 찾을 수 없습니다.';
            break;
          case 500:
            code = ApiConfig.serverError;
            message = '서버 내부 오류가 발생했습니다.';
            break;
        }
        break;
      case DioExceptionType.cancel:
        code = 'CANCELLED';
        message = '요청이 취소되었습니다.';
        break;
      case DioExceptionType.connectionError:
        code = 'CONNECTION_ERROR';
        message = '네트워크 연결을 확인해주세요.';
        break;
      default:
        code = 'UNKNOWN_ERROR';
        message = '알 수 없는 오류가 발생했습니다.';
    }
    
    return ApiResponse.error(code, message);
  }
}

// API 응답 래퍼 클래스
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? errorCode;
  final String? errorMessage;
  final List<dynamic>? errorDetails;
  
  ApiResponse._({
    required this.success,
    this.data,
    this.message,
    this.errorCode,
    this.errorMessage,
    this.errorDetails,
  });
  
  factory ApiResponse.success(T data, {String? message}) {
    return ApiResponse._(
      success: true,
      data: data,
      message: message,
    );
  }
  
  factory ApiResponse.error(String errorCode, String errorMessage, {List<dynamic>? details}) {
    return ApiResponse._(
      success: false,
      errorCode: errorCode,
      errorMessage: errorMessage,
      errorDetails: details,
    );
  }
  
  bool get isSuccess => success;
  bool get isError => !success;
}
