import 'package:flowers_admin/src/presentation/customer_order_page/widgets/customer_order_body.dart';
import 'package:flutter/material.dart';
///
///
class CustomerOrderPage extends StatelessWidget {
  final String _authToken;
  ///
  ///
  const CustomerOrderPage({
    super.key,
    required String authToken,
  }):
    _authToken = authToken;
  //
  //
  @override
  Widget build(BuildContext context) {
    return CustomerOrderBody(
      authToken: _authToken,
    );
  }
}
