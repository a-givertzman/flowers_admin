
import 'package:flowers_admin/src/presentation/transaction_page/widgets/transaction_body.dart';
import 'package:flutter/material.dart';

class TransactionPage extends StatelessWidget {
  final String _authToken;
  ///
  ///
  const TransactionPage({
    super.key,
    required String authToken,
  }):
    _authToken = authToken;
  //
  //
  @override
  Widget build(BuildContext context) {
    return TransactionBody(
      authToken: _authToken,
    );
  }
}