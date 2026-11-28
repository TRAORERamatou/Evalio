import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/focus/data/android_focus_monitor.dart';
import '../../features/focus/domain/focus_monitor.dart';
import '../network/dio_client.dart';
import '../storage/secure_storage.dart';

final GetIt getIt = GetIt.instance;

/// Enregistre toutes les dépendances de l'application.
/// Appelé une fois au démarrage (main).
void setupLocator() {
  // Feature : focus (spike T04)
  getIt.registerLazySingleton<FocusMonitor>(() => AndroidFocusMonitor());

  // Core : stockage sécurisé
  getIt.registerLazySingleton<SecureStorage>(
    () => SecureStorage(const FlutterSecureStorage()),
  );

  // Core : client HTTP (initialise avec le stockage)
  DioClient.init(getIt<SecureStorage>());
}
