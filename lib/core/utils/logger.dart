import 'package:flutter/foundation.dart';

/// Утилитарный класс для логирования.
///
/// В режиме DEBUG (при запуске `flutter run`) выводит все сообщения в консоль.
/// В режиме RELEASE (собранное приложение) отключает вывод, чтобы не засорять логи устройства,
/// но оставляет заглушки для легкой интеграции с внешними сервисами (например, Firebase Crashlytics).
class Logger {
  const Logger._();

  /// Информационное сообщение. Используется для отслеживания потока данных.
  static void i(Object? message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('ℹ️ INFO: $message');
      if (error != null) {
        debugPrint('   ERROR: $error');
      }
      if (stackTrace != null) {
        debugPrint('   STACK: $stackTrace');
      }
    }
  }

  /// Предупреждение о нестандартной ситуации, которая не ломает работу приложения.
  static void w(Object? message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('⚠️ WARNING: $message');
      if (error != null) {
        debugPrint('   ERROR: $error');
      }
      if (stackTrace != null) {
        debugPrint('   STACK: $stackTrace');
      }
    }
  }

  /// Сообщение об ошибке. Рекомендуется вызывать перед отправкой отчета в Sentry/Crashlytics.
  static void e(Object? message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('❌ ERROR: $message');
      if (error != null) {
        debugPrint('   DETAILS: $error');
      }
      if (stackTrace != null) {
        debugPrint('   STACK: $stackTrace');
      }
    }

    // TODO: Интеграция с внешним сервисом мониторинга ошибок
    // Example: FirebaseCrashlytics.instance.log('$message | $error');
    // Example: FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }

  /// Трассировка выполнения (метод вошел / метод вышел). Полезно при отладке сложной логики переливания.
  static void d(Object? message) {
    if (kDebugMode) {
      debugPrint('🔍 DEBUG: $message');
    }
  }
}
