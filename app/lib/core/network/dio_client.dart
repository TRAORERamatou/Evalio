import 'package:dio/dio.dart';
import '../config.dart';
import '../error/failure.dart';
import '../storage/secure_storage.dart';

/// Exception encapsulant une [Failure] retournée par l'API.
class ApiException implements Exception {
  final Failure failure;
  ApiException(this.failure);
}

/// Client HTTP centralisé avec gestion automatique de l'authentification.
class DioClient {
  static Dio? _dio;
  static SecureStorage? _storage;

  DioClient._internal();

  /// Initialise le stockage sécurisé avant toute utilisation.
  static void init(SecureStorage storage) {
    _storage = storage;
  }

  /// Retourne l'instance de Dio configurée (base URL, headers, intercepteurs).
  static Future<Dio> get instance async {
    if (_dio != null) return _dio!;
    if (_storage == null) {
      throw StateError(
        'SecureStorage not initialized. Call DioClient.init(storage) first.',
      );
    }

    _dio = Dio(
      BaseOptions(
        baseUrl: apiUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Intercepteur de requête : ajoute le Bearer token s'il existe.
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage!.readAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },

        // Intercepteur de réponse d'erreur : mappe vers des Failure typées.
        onError: (DioException error, handler) async {
          final failure = DioClient.mapError(error);
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: ApiException(failure),
              response: error.response,
              type: error.type,
            ),
          );
        },
      ),
    );

    return _dio!;
  }

  /// Mappe une [DioException] vers une [Failure] typée selon le contrat API
  /// (docs/06-api-contract.md §1).
  ///
  /// Erreurs réseau / timeouts → [NetworkFailure].
  /// 401/403 → [UnauthorizedFailure], 404 → [NotFoundFailure],
  /// 422 → [ValidationFailure] avec détails par champ,
  /// autre → [ServerFailure].
  static Failure mapError(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;
    final dynamic data = response?.data;

    String message;
    Map<String, List<String>>? fieldErrors;

    if (data is Map && data.containsKey('error')) {
      final errorObj = data['error'];
      if (errorObj is Map) {
        message =
            errorObj['message']?.toString() ??
            error.message ??
            'Erreur inconnue';
        final rawDetails = errorObj['details'];
        if (rawDetails is List) {
          fieldErrors = {};
          for (final detail in rawDetails) {
            if (detail is Map) {
              final field = detail['field']?.toString();
              final msg = detail['message']?.toString();
              if (field != null && msg != null) {
                fieldErrors.putIfAbsent(field, () => []).add(msg);
              }
            }
          }
        }
      } else {
        message = error.message ?? 'Erreur inconnue';
      }
    } else {
      message = error.message ?? 'Erreur inconnue';
    }

    // Erreurs réseau / timeouts → NetworkFailure avant tout code HTTP.
    final isNetworkError =
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.unknown;

    Failure failure;
    if (isNetworkError) {
      failure = NetworkFailure(message: message);
    } else {
      switch (statusCode) {
        case 401:
          failure = UnauthorizedFailure(message: message, statusCode: 401);
          break;
        case 403:
          failure = UnauthorizedFailure(message: message, statusCode: 403);
          break;
        case 404:
          failure = NotFoundFailure(message: message, statusCode: 404);
          break;
        case 422:
          failure = ValidationFailure(
            message: message,
            fieldErrors: fieldErrors,
            statusCode: 422,
          );
          break;
        default:
          failure = ServerFailure(message: message, statusCode: statusCode);
      }
    }

    return failure;
  }

  static void dispose() {
    _dio?.close();
    _dio = null;
  }
}
