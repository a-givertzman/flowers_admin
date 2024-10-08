
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/presentation/customer_page/widgets/customer_body.dart';
import 'package:flutter/material.dart';
///
/// Widget for Overview / edit Customer's
class CustomerPage extends StatelessWidget {
  final String _authToken;
  final AppUser _user;
  ///
  ///
  const CustomerPage({
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
    return CustomerBody(
      authToken: _authToken,
      user: _user,
    );
  }
}