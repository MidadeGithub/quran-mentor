import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import '../../injection_container.dart' as di;
import '../error/exceptions.dart';
import '../utils/app_strings.dart';
import 'api_consumer.dart';
import 'app_interceptors.dart';
import 'cache_helper.dart';
import 'end_points.dart';
import 'status_code.dart';

class DioConsumer extends ApiConsumer {
  final Dio client;

  DioConsumer({required this.client}) {
    // ignore: deprecated_member_use
    (client.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    client.options
      ..baseUrl = EndPoints.baseUrl
      ..responseType = ResponseType.plain
      ..followRedirects = false
      ..validateStatus = (status) {
        return status! < StatusCode.internalServerError;
      };
    client.interceptors.add(di.sl<AppIntercepters>());
    if (kDebugMode) {
      client.interceptors.add(di.sl<LogInterceptor>());
    }
  }

  @override
  Future<dynamic> get(String path,
      {Map<String, dynamic>? queryParameters,
      Map<String, String>? headers}) async {
    try {
      final response = await client.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers
            // {
            // AppStrings.authorization: CacheHelper.getDataFromSharedPreference(
            //     key: AppStrings.accessToken),
            // ...headers ?? {}
            // }
            ),
      );

      return response;
    } on DioError catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future<dynamic> post(String path,
      {Map<String, dynamic>? body,
      bool formDataIsEnabled = false,
      Map<String, String>? headers,
      Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await client.post(path,
          data: formDataIsEnabled ? FormData.fromMap(body!) : body,
          options: Options(headers: headers
              // {
              //   AppStrings.authorization: CacheHelper.getDataFromSharedPreference(
              //       key: AppStrings.accessToken),
              //   ...headers ?? {}
              // }
              ),
          queryParameters: queryParameters);

      return response;
    } on DioError catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future<dynamic> put(String path,
      {Map<String, dynamic>? body,
      Map<String, String>? headers,
      bool responseIsParsing = true,
      Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await client.put(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );

      return response;
    } on DioError catch (error) {
      _handleDioError(error);
    }
  }

  dynamic _handleDioError(DioException error) {
    if (error.error is SocketException) {
      throw const NoInternetConnectionException();
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw const FetchDataException();

      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case StatusCode.badRequest:
            throw const BadRequestException();
          case StatusCode.forbidden:
            throw const UnauthorizedException();
          case StatusCode.notFound:
            throw const NotFoundException();
          case StatusCode.conflict:
            throw const ConflictException();
          case StatusCode.internalServerError:
            throw const InternalServerErrorException();
        }
        break;
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.unknown:
        throw const NoInternetConnectionException();
      default:
        throw Exception('Unhandled Dio Error: ${error.type}');
    }
  }

  Future postFormData(String path,
      {Object? body,
      Map<String, dynamic>? queryParameters,
      Map<String, String>? headers}) async {
    try {
      final response = await client.post(path,
          data: body,
          options: Options(
            headers: {
              AppStrings.authorization:
                  "${CacheHelper.getData(key: AppStrings.accessToken)}",
              AppStrings.contentType: AppStrings.multipartFile,
              ...headers ?? {}
            },
          ),
          queryParameters: queryParameters);

      return response;
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future download({required String fileUrl, required String filePath}) async {
    try {
      final response = await client.download(fileUrl, filePath);

      return response;
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }
}
