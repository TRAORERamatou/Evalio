import 'focus_event.dart';

/// Contrat de surveillance du focus de l'application.
///
/// Aucune dépendance à Flutter ni à Dio : ce contrat peut être implémenté
/// pour Android (MethodChannel), iOS ou testé avec un mock.
abstract class FocusMonitor {
  /// Écoute les changements de focus. Émet [FocusEvent] à chaque transition.
  Stream<FocusEvent> onFocusChanged();

  /// Vérifie si l'écran est actuellement protégé par FLAG_SECURE.
  Future<bool> isSecure();
}
