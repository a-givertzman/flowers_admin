
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/presentation/home_page/widgets/home_body.dart';
import 'package:flutter/material.dart';
///
///
class HomePage extends StatelessWidget {
  final String _authToken;
  final AppUser _user;
  ///
  ///
  const HomePage({
    super.key,
    required String authToken,
    required AppUser user,
  }): 
    _authToken = authToken,
    _user = user;
  //
  //
  @override
  Widget build(BuildContext context) {
    return HomeBody(
      authToken: _authToken,
      user: _user,
    );
  }
}