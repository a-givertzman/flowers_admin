import 'package:flowers_admin/src/presentation/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

///
///
class AppWidget extends StatefulWidget {
  // final AppThemeSwitch _themeSwitch;
  final String _authToken;
  ///
  ///
  const AppWidget({
    Key? key,
    // required AppThemeSwitch themeSwitch,
    required String authToken,
  }) : 
    // _themeSwitch = themeSwitch,
    _authToken = authToken,
    super(key: key);
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<AppWidget> createState() => _AppWidgetState(
    // themeSwitch: _themeSwitch,
      authToken: _authToken,
  );
}

///
class _AppWidgetState extends State<AppWidget> {
  // final AppThemeSwitch _themeSwitch;
  final String _authToken;
  ///
  ///
  _AppWidgetState({
    required String authToken,
  }) : 
    // _themeSwitch = themeSwitch,
    _authToken = authToken,
    super();
  //
  //
  @override
  void dispose() {
    // _themeSwitch.removeListener(_themeSwitchListener);
    super.dispose();
  }
  //
  //
  @override
  void initState() {
    super.initState();
    // _themeSwitch.addListener(_themeSwitchListener);
    if (!kIsWeb) {
      Future.delayed(
        Duration.zero,
        () async {
          await windowManager.ensureInitialized();
          // windowManager.setFullScreen(true);
          // windowManager.setTitleBarStyle(TitleBarStyle.hidden);
          // windowManager.setBackgroundColor(Colors.transparent);
          // windowManager.setSize(const Size(1024, 768));
          // windowManager.center();
          windowManager.focus();
          WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {true;}));
        },
      );
    }
  }
  ///
  // void _themeSwitchListener() {
  //   if (mounted) {
  //     setState(() {true;});
  //   }
  // }
  //
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(
        authToken: _authToken,
      ), 
      theme: ThemeData(useMaterial3: true),
          // themeSwitch: _themeSwitch,
      initialRoute: 'homePage',
      routes: {
        'homePahe': (context) => HomePage(
          authToken: _authToken,
        ),
      },
      // theme: _themeSwitch.themeData,
    );
  }
}
