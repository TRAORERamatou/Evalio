import 'package:flutter/services.dart';
import '../domain/focus_event.dart';
import '../domain/focus_monitor.dart';

/// Implémentation Android de [FocusMonitor] via un MethodChannel.
///
/// Communique avec MainActivity (Kotlin) sur le canal "bf.evalio/focus".
class AndroidFocusMonitor implements FocusMonitor {
  static const _channel = MethodChannel('bf.evalio/focus');
  static const _eventChannel = EventChannel('bf.evalio/focus/events');

  @override
  Stream<FocusEvent> onFocusChanged() {
    return _eventChannel.receiveBroadcastStream().map((dynamic event) {
      final Map<dynamic, dynamic> args = event as Map<dynamic, dynamic>;
      return FocusEvent(
        hasFocus: args['hasFocus'] as bool,
        timestampMs: args['timestampMs'] as int,
      );
    });
  }

  @override
  Future<bool> isSecure() async {
    try {
      final bool? result = await _channel.invokeMethod('isSecure');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }
}
