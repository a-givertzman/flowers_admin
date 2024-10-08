
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/presentation/payment_page/widgets/payment_body.dart';
import 'package:flutter/material.dart';
///
/// Provides an Order's payment procedure
/// - list of Order's groupped by Purchase's
/// - list of Customer's on selected Order's
class PaymentPage extends StatelessWidget {
  final String _authToken;
  final AppUser _user;
  ///
  ///
  const PaymentPage({
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
    return PaymentBody(
      authToken: _authToken,
      user: _user,
    );
  }
}