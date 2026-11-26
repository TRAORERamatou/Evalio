import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../../core/di/get_it.dart';
import '../domain/focus_event.dart';
import '../domain/focus_monitor.dart';

abstract class FocusGuardState extends Equatable {
  const FocusGuardState();

  @override
  List<Object?> get props => [];
}

/// État initial avant tout événement de focus.
class FocusGuardInitial extends FocusGuardState {}

/// L'application a le focus (au premier plan).
class FocusGuardFocused extends FocusGuardState {}

/// L'application a perdu le focus. [exitCount] est le nombre de sorties comptées.
class FocusGuardBlurred extends FocusGuardState {
  const FocusGuardBlurred(this.exitCount);

  final int exitCount;

  @override
  List<Object?> get props => [exitCount];
}

/// Cubit de surveillance du focus pour l'écran d'essai (spike T04).
///
/// Écoute le FocusMonitor et compte les pertes de focus.
class FocusGuardCubit extends Cubit<FocusGuardState> {
  final FocusMonitor _monitor = getIt<FocusMonitor>();
  StreamSubscription? _subscription;

  int _exitCount = 0;

  FocusGuardCubit() : super(FocusGuardInitial());

  /// Démarre la surveillance du focus.
  Future<void> start() async {
    try {
      final bool secure = await _monitor.isSecure();
      debugPrint('FocusGuardCubit: FLAG_SECURE active = $secure');
    } catch (e) {
      debugPrint('FocusGuardCubit: impossible de lire FLAG_SECURE : $e');
    }

    _subscription = _monitor.onFocusChanged().listen((FocusEvent event) {
      if (event.hasFocus) {
        emit(FocusGuardFocused());
      } else {
        _exitCount++;
        emit(FocusGuardBlurred(_exitCount));
      }
    });
  }

  /// Arrête la surveillance.
  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  int get exitCount => _exitCount;
}
