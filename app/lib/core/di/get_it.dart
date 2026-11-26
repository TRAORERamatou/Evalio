import 'package:get_it/get_it.dart';
import '../../features/focus/data/android_focus_monitor.dart';
import '../../features/focus/domain/focus_monitor.dart';

final GetIt getIt = GetIt.instance;

/// Enregistre toutes les dépendances de l'application.
/// Appelé une fois au démarrage (main).
void setupLocator() {
  // Feature : focus (spike T04)
  getIt.registerLazySingleton<FocusMonitor>(() => AndroidFocusMonitor());
}
