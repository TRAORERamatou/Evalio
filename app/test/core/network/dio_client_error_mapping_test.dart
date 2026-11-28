import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:evalio/core/network/dio_client.dart';
import 'package:evalio/core/error/failure.dart';

void main() {
  group('DioClient.mapError', () {
    test('401 avec contrat {error: {message}} → UnauthorizedFailure', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
          data: {
            'error': {'message': 'Token expiré'},
          },
        ),
      );

      final failure = DioClient.mapError(error);

      expect(failure, isA<UnauthorizedFailure>());
      expect(failure.message, 'Token expiré');
      expect(failure.statusCode, 401);
    });

    test('403 → UnauthorizedFailure', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 403,
          data: {
            'error': {'message': 'Interdit'},
          },
        ),
      );

      final failure = DioClient.mapError(error);

      expect(failure, isA<UnauthorizedFailure>());
      expect(failure.statusCode, 403);
    });

    test('404 → NotFoundFailure', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 404,
          data: {
            'error': {'message': 'Cours introuvable'},
          },
        ),
      );

      final failure = DioClient.mapError(error);

      expect(failure, isA<NotFoundFailure>());
      expect(failure.statusCode, 404);
    });

    test('422 avec details → ValidationFailure avec fieldErrors', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 422,
          data: {
            'error': {
              'message': 'Champs invalides',
              'details': [
                {'field': 'email', 'message': 'Email invalide'},
                {'field': 'password', 'message': 'Trop court'},
                {'field': 'email', 'message': 'Déjà utilisé'},
              ],
            },
          },
        ),
      );

      final failure = DioClient.mapError(error);

      expect(failure, isA<ValidationFailure>());
      expect(failure.statusCode, 422);
      final vf = failure as ValidationFailure;
      expect(vf.fieldErrors, {
        'email': ['Email invalide', 'Déjà utilisé'],
        'password': ['Trop court'],
      });
    });

    test('connectTimeout → NetworkFailure', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      final failure = DioClient.mapError(error);

      expect(failure, isA<NetworkFailure>());
    });

    test('receiveTimeout → NetworkFailure', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.receiveTimeout,
      );

      final failure = DioClient.mapError(error);

      expect(failure, isA<NetworkFailure>());
    });

    test('pas de réponse (unknown) → NetworkFailure', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.unknown,
      );

      final failure = DioClient.mapError(error);

      expect(failure, isA<NetworkFailure>());
    });

    test('500 sans body → ServerFailure', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 500,
          data: {
            'error': {'message': 'Erreur serveur'},
          },
        ),
      );

      final failure = DioClient.mapError(error);

      expect(failure, isA<ServerFailure>());
      expect(failure.statusCode, 500);
    });

    test('409 → ServerFailure', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 409,
          data: {
            'error': {'message': 'Conflit d\'état'},
          },
        ),
      );

      final failure = DioClient.mapError(error);

      expect(failure, isA<ServerFailure>());
      expect(failure.statusCode, 409);
    });
  });
}
