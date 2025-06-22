
import 'package:flowers_admin/src/presentation/auth_page/widgets/auth_body.dart';
import 'package:flutter/material.dart';
///
///
class AuthPage extends StatelessWidget {
  final String authToken;
  ///
  ///
  const AuthPage({
    super.key,
    required this.authToken,
  });
  //
  //
  @override
  Widget build(BuildContext context) {
    return AuthBody(
      authToken: authToken,
    );
  }
}