import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user_role.dart';
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
    super.key,
    // required AppThemeSwitch themeSwitch,
    required String authToken,
  }) : 
    // _themeSwitch = themeSwitch,
    _authToken = authToken;
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
    final homePage = HomePage(
      authToken: _authToken,
      user: AppUser(id: '15', name: 'Anton Lobanov', role: AppUserRole.admin),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homePage, 
      theme: ThemeData(useMaterial3: true),
          // themeSwitch: _themeSwitch,
      initialRoute: 'homePage',
      routes: {
        'homePahe': (context) => homePage,
      },
      // theme: _themeSwitch.themeData,
    );
  }
}
