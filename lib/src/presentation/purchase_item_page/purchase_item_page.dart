import 'package:flowers_admin/src/presentation/purchase_item_page/widgets/purchase_item_body.dart';
import 'package:flutter/material.dart';
///
///
class PurchaseItemPage extends StatelessWidget {
  final String _authToken;
  ///
  ///
  const PurchaseItemPage({
    super.key,
    required String authToken,
  }):
    _authToken = authToken;
  //
  //
  @override
  Widget build(BuildContext context) {
    return PurchaseItemBody(
      authToken: _authToken,
    );
  }
}
