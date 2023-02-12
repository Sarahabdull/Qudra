// import 'package:kodra/app/data/services/network_service.dart/logging_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qodra/app/data/services/network_service.dart/logging_interceptor.dart';
part 'dio_network_service.freezed.dart';


@freezed
class NetworkRequestBody with _$NetworkRequestBody {
  const factory NetworkRequestBody.empty() = Empty;
  const factory NetworkRequestBody.json(Map<String, dynamic> data) = Json;
  const factory NetworkRequestBody.text(String data) = Text;
}

enum NetworkRequestType { GET, POST, PUT, PATCH, DELETE }

class NetworkRequest {
  const NetworkRequest({
    required this.type,
    required this.path,
    required this.data,
    this.queryParams,
    this.headers,
  });

  final NetworkRequestType type;
  final String path;
  final NetworkRequestBody data;
  final Map<String, dynamic>? queryParams;
  final Map<String, String>? headers;
}

@freezed
class NetworkResponse<Model> with _$NetworkResponse {
  const factory NetworkResponse.ok(Model data) = Ok;
  const factory NetworkResponse.invalidParameters(String message) =
  InvalidParameters;
  const factory NetworkResponse.noAuth(String message) = NoAuth; //401
  const factory NetworkResponse.noAccess(String message) = NoAccess; //403
  const factory NetworkResponse.badRequest(String message) = BadRequest; //400
  const factory NetworkResponse.notFound(String message) = NotFound; //404
  const factory NetworkResponse.conflict(String message) = Conflict; //409
  const factory NetworkResponse.noData(String message) = NoData;//500
}

class _PreparedNetworkRequest<Model> {
  const _PreparedNetworkRequest(
      this.request,
      this.parser,
      this.dio,
      this.headers,
      this.onSendProgress,
      this.onReceiveProgress,
      );
  final NetworkRequest request;
  final Model Function(Map<String, dynamic>) parser;
  final Dio dio;
  final Map<String, dynamic> headers;
  final ProgressCallback? onSendProgress;
  final ProgressCallback? onReceiveProgress;
}

Future<NetworkResponse<Model>> executeRequest<Model>(
    _PreparedNetworkRequest request,
    ) async {
  try {
    dynamic body = request.request.data.whenOrNull(
      json: (data) => data,
      text: (data) => data,
    );
    final response = await request.dio.request(
      request.request.path,
      data: body,
      queryParameters: request.request.queryParams,
      options: Options(
        method: request.request.type.name,
        headers: request.headers,
      ),
      onSendProgress: request.onSendProgress,
      onReceiveProgress: request.onReceiveProgress,
    );
    return NetworkResponse.ok(request.parser(response.data));
  } on DioError catch (error) {
    final errorText = error.toString();
    if (error.requestOptions.cancelToken?.isCancelled ?? false) {
      return NetworkResponse.noData(errorText);
    }
    switch (error.response?.statusCode) {
      case 400:
        return NetworkResponse.badRequest(errorText);
      case 401:
        return NetworkResponse.noAuth(errorText);
      case 403:
        return NetworkResponse.noAccess(errorText);
      case 404:
        return NetworkResponse.notFound(errorText);
      case 409:
        return NetworkResponse.conflict(errorText);
      default:
        return NetworkResponse.noData(errorText);
    }
  } catch (error) {
    return NetworkResponse.noData(error.toString());
  }
}

class NetworkService {
  NetworkService({
    required this.baseUrl,
    dioClient,
    httpHeaders,
  })  : _dio = dioClient,
        _headers = httpHeaders ?? {};
  Dio? _dio;
  final String baseUrl;
  final Map<String, String> _headers;
  Future<Dio> _getDefaultDioClient() async {
    _headers['content-type'] = 'application/json; charset=utf-8';
    final dio = Dio()
      ..interceptors.add(dioLoggerInterceptor)
      ..options.baseUrl = baseUrl
      ..options.headers = _headers
      ..options.connectTimeout = 15000 // 15 seconds
      ..options.receiveTimeout = 15000; // 15 seconds
    return dio;
  }

  void addBasicAuth(String accessToken) {
    _headers['Authorization'] = 'Bearer $accessToken';
  }

  Future<NetworkResponse<T>> execute<T>(
      NetworkRequest request,
      T Function(Map<String, dynamic>) parser, {
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    _dio ??= await _getDefaultDioClient();
    final req = _PreparedNetworkRequest<T>(
      request,
      parser,
      _dio!,
      {..._headers, ...(request.headers ?? {})},
      onSendProgress,
      onReceiveProgress,
    );
    final result = await compute(
      executeRequest<T>,
      req,
    );
    return result;
  }
}
