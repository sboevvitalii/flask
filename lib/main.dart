import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() {
  // FlutterError.onError позволяет перехватывать ошибки рендеринга
  // и отправлять их в Crashlytics на продакшене.
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    // TODO: Отправить в Firebase Crashlytics
  };

  runApp(const ProviderScope(child: AppWidget()));
}
