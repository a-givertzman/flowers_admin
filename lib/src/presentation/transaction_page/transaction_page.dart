
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/presentation/transaction_page/widgets/transaction_body.dart';
import 'package:flutter/material.dart';

class TransactionPage extends StatelessWidget {
  final String _authToken;
  final AppUser _user;
  ///
  ///
  const TransactionPage({
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
    return TransactionBody(
      authToken: _authToken,
      user: _user,
    );
  }
}