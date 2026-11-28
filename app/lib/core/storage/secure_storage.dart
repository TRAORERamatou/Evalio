import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stockage sécurisé des tokens (accès + refresh) sur le périphérique.
class SecureStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  final FlutterSecureStorage _storage;

  SecureStorage(this._storage);

  /// Écrit le token d'accès.
  Future<void> writeAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  /// Lit le token d'accès.
  Future<String?> readAccessToken() async =>
      _storage.read(key: _accessTokenKey);

  /// Supprime le token d'accès.
  Future<void> deleteAccessToken() async =>
      _storage.delete(key: _accessTokenKey);

  /// Écrit le token de rafraîchissement.
  Future<void> writeRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Lit le token de rafraîchissement.
  Future<String?> readRefreshToken() async =>
      _storage.read(key: _refreshTokenKey);

  /// Supprime le token de rafraîchissement.
  Future<void> deleteRefreshToken() async =>
      _storage.delete(key: _refreshTokenKey);

  /// Efface les deux tokens (déconnexion).
  Future<void> clearAll() async {
    await deleteAccessToken();
    await deleteRefreshToken();
  }
}
