import 'dart:async';

import 'package:flowers_admin/src/app_widget.dart';
import 'package:flowers_admin/src/core/log/log.dart';
import 'package:flowers_admin/src/core/log/log_level.dart';
// ignore: implementation_imports
import 'package:hmi_core/src/core/json/json_map.dart';
// ignore: implementation_imports
import 'package:hmi_core/src/core/text_file.dart';
import 'package:flowers_admin/src/core/settings/app_settings.dart';
import 'package:flutter/material.dart';
///
///
void main() async {
  const apiAuthToken = '';
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      Log.initialize(level: LogLevel.all);
      await AppSettings.initialize(
        jsonMap: JsonMap.fromTextFile(
          const TextFile.asset(
            'assets/settings/app-settings.json',
          ),
        ),
      );
      // final appThemeSwitch = AppThemeSwitch();
      runApp(
        const AppWidget(
          // themeSwitch: appThemeSwitch,
          authToken: apiAuthToken,
        ),
      );
    },
    (error, stackTrace) {
      final trace = stackTrace.toString().isEmpty ? StackTrace.current : stackTrace.toString();
      const Log('main').error('message: $error\nstackTrace: $trace'); 
    },
  );
}
