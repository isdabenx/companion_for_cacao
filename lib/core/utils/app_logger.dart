import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Minimal logging facade for the app.
///
/// Centralizes log output so call sites don't depend on the backend:
/// today logs go to the developer console in debug builds only (dropped
/// in profile/release builds, unlike [debugPrint] which also prints in
/// profile); tomorrow this can forward to crash reporting or file logs
/// without touching any caller.
class AppLogger {
  AppLogger._();

  static const _name = 'companion_for_cacao';

  /// Unexpected but recoverable situations (fallbacks, skipped records).
  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    if (!kDebugMode) return;
    developer.log(
      message,
      name: _name,
      level: 900,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Failures worth investigating (caught exceptions).
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (!kDebugMode) return;
    developer.log(
      message,
      name: _name,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
