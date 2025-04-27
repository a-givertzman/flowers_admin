import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/presentation/customer_order_page/widgets/customer_order_body.dart';
import 'package:flutter/material.dart';
///
///
class CustomerOrderPage extends StatelessWidget {
  final String authToken;
  final AppUser user;
  ///
  ///
  const CustomerOrderPage({
    super.key,
    required this.authToken,
    required this.user,
  });
  //
  //
  @override
  Widget build(BuildContext context) {
    return CustomerOrderBody(
      authToken: authToken,
      user: user,
    );
  }
}
