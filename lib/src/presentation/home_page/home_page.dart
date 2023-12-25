
import 'package:flowers_admin/src/presentation/home_page/widgets/home_body.dart';
import 'package:flutter/material.dart';

///
///
class HomePage extends StatelessWidget {
  final String _authToken;
  ///
  ///
  const HomePage({
    super.key,
    required String authToken,
  }): 
    _authToken = authToken;
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return HomeBody(
      authToken: _authToken,
    );
  }
}