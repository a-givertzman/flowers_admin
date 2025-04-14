import 'dart:async';
import 'dart:io';

import 'package:flowers_admin/src/app_widget.dart';
import 'package:flowers_admin/src/core/log/log.dart';
import 'package:flowers_admin/src/core/log/log_level.dart';
import 'package:flowers_admin/src/core/settings/settings.dart';
import 'package:hmi_core/hmi_core_json.dart';
import 'package:hmi_core/hmi_core_text_file.dart';
import 'package:flowers_admin/src/core/settings/app_settings.dart';
import 'package:flutter/material.dart';
// import 'package:window_manager/window_manager.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:window_size/window_size.dart';

///
///
void main() async {
  runZonedGuarded(
    () async {
      Log.initialize(level: LogLevel.debug);
      WidgetsFlutterBinding.ensureInitialized();
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
          setWindowTitle('Flowers | Admin');
          setWindowMinSize(const Size(400, 300));
          setWindowMaxSize(Size.infinite);
      }
      // if (!kIsWeb) {
      //   await windowManager.ensureInitialized();
      //   windowManager.waitUntilReadyToShow().then((_) async {
      //     // Hide window title bar
      //     await windowManager.setTitleBarStyle(TitleBarStyle.normal);
      //     await windowManager.setTitle("Expenses Tracker");
      //     // await windowManager.setSize(Size(400, 400));
      //     // await windowManager.center();
      //     await windowManager.show();
      //   });
      // //   Future.delayed(
      // //     Duration.zero,
      // //     () async {
      // //       // windowManager.setFullScreen(true);
      // //       // windowManager.setTitleBarStyle(TitleBarStyle.hidden);
      // //       // windowManager.setBackgroundColor(Colors.transparent);
      // //       windowManager.setSize(const Size(1800, 768));
      // //       // windowManager.center();
      // //       windowManager.focus();
      // //       WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {return;}));
      // //     },
      // //   );
      // }

      await AppSettings.initialize(
        jsonMap: JsonMap.fromTextFile(
          const TextFile.asset(
            'assets/settings/app-settings.json',
          ),
        ),
      );
      // final appThemeSwitch = AppThemeSwitch();
      final apiAuthToken = Setting('api-auth-token').toString();
      runApp(
        AppWidget(
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
