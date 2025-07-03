import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user_role.dart';
import 'package:flowers_admin/src/presentation/auth_page/auth_page.dart';
import 'package:flowers_admin/src/presentation/home_page/home_page.dart';
import 'package:flutter/material.dart';
///
///
class AppWidget extends StatefulWidget {
  // final AppThemeSwitch themeSwitch;
  final String authToken;
  ///
  ///
  const AppWidget({
    super.key,
    // required this.themeSwitch,
    required this.authToken,
  });
  //
  //
  @override
  State<AppWidget> createState() => _AppWidgetState();
}

///
class _AppWidgetState extends State<AppWidget> {
  final AppUser _user = AppUser.empty();
  //
  //
  @override
  void initState() {
    super.initState();
    // _themeSwitch.addListener(_themeSwitchListener);
  }
  //
  //
  @override
  void dispose() {
    // _themeSwitch.removeListener(_themeSwitchListener);
    super.dispose();
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
      authToken: widget.authToken,
      user: AppUser(id: '1', name: 'Anton Lobanov', role: AppUserRole.admin),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: _user.isEmpty
      //   ? 
      //   : homePage, 
      theme: ThemeData(useMaterial3: true),
          // themeSwitch: widget.themeSwitch,
      initialRoute: _user.isEmpty ? 'authPage' : 'homePage',
      routes: {
        'authPage': (context) => AuthPage(
          authToken: widget.authToken,
        ),
        'homePage': (context) => homePage,
      },
      // theme: widget.themeSwitch.themeData,
    );
  }
}
