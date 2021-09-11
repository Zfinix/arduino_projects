import 'dart:async';
import 'dart:developer';

import 'package:arduino_projects/app/app.dart';
import 'package:flutter/widgets.dart';

void main() async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  runZonedGuarded(
    () => runApp(const App()),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
