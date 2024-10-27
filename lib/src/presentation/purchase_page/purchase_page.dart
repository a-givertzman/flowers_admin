
import 'package:flowers_admin/src/presentation/purchase_page/widgets/purchase_body.dart';
import 'package:flutter/material.dart';
///
///
class PurchasePage extends StatelessWidget {
  final String _authToken;
  ///
  ///
  const PurchasePage({
    super.key,
    required String authToken,
  }):
    _authToken = authToken;
  //
  //
  @override
  Widget build(BuildContext context) {
    return PurchaseBody(
      authToken: _authToken,
    );
  }
}
