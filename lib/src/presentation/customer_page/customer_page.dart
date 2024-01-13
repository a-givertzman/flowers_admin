
import 'package:flowers_admin/src/presentation/customer_page/widgets/customer_body.dart';
import 'package:flutter/material.dart';

class CustomerPage extends StatelessWidget {
  final String _authToken;
  ///
  ///
  const CustomerPage({
    super.key,
    required String authToken,
  }):
    _authToken = authToken;
  //
  //
  @override
  Widget build(BuildContext context) {
    return CustomerBody(
      authToken: _authToken,
    );
  }
}