import 'dart:async';

import 'package:flowers_admin/src/app_widget.dart';
import 'package:flowers_admin/src/core/log/log.dart';
import 'package:flowers_admin/src/core/log/log_level.dart';
import 'package:flutter/material.dart';

void main() async {
  Log.initialize(level: LogLevel.all);
  runZonedGuarded(
    () async {
      // final appThemeSwitch = AppThemeSwitch();
      runApp(
        const AppWidget(
          // themeSwitch: appThemeSwitch,
        ),
      );
    },
    (error, stackTrace) {
      final trace = stackTrace.toString().isEmpty ? StackTrace.current : stackTrace.toString();
      const Log('main').error('message: $error\nstackTrace: $trace'); 
    },
  );}
