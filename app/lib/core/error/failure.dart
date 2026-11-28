import 'package:equatable/equatable.dart';

/// Classe de base des erreurs métier de l'application.
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// Erreur serveur (5xx ou inattendue).
class ServerFailure extends Failure {
  const ServerFailure({required String message, int? statusCode})
      : super(message: message, statusCode: statusCode);
}

/// L'utilisateur n'est pas authentifié ou sa session a expiré (401/403).
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({String? message, int? statusCode})
      : super(
            message: message ?? 'Non autorisé', statusCode: statusCode ?? 401);
}

/// Ressource introuvable (404).
class NotFoundFailure extends Failure {
  const NotFoundFailure({String? message, int? statusCode})
      : super(
          message: message ?? 'Ressource introuvable',
          statusCode: statusCode ?? 404,
        );
}

/// Erreur de validation (422) avec détails par champ.
class ValidationFailure extends Failure {
  final Map<String, List<String>>? fieldErrors;

  const ValidationFailure({
    required String message,
    this.fieldErrors,
    int? statusCode,
  }) : super(message: message, statusCode: statusCode ?? 422);

  @override
  List<Object?> get props => [message, statusCode, fieldErrors];
}

/// Pas de connexion réseau.
class NetworkFailure extends Failure {
  const NetworkFailure({String? message})
      : super(message: message ?? 'Aucune connexion réseau');
}

/// Erreur de lecture/écriture dans le cache local.
class CacheFailure extends Failure {
  const CacheFailure({String? message})
      : super(message: message ?? 'Erreur de cache local');
}
