import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/presentation/purchase_item_page/widgets/purchase_item_body.dart';
import 'package:flutter/material.dart';
///
///
class PurchaseItemPage extends StatelessWidget {
  final String authToken;
  final AppUser user;
  ///
  ///
  const PurchaseItemPage({
    super.key,
    required this.authToken,
    required this.user,
  });
  //
  //
  @override
  Widget build(BuildContext context) {
    return PurchaseItemBody(
      authToken: authToken,
      user: user,
    );
  }
}
