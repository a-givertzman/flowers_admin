
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/presentation/purchase_page/widgets/purchase_body.dart';
import 'package:flutter/material.dart';
///
///
class PurchasePage extends StatelessWidget {
  final String authToken;
  final AppUser user;
  ///
  ///
  const PurchasePage({
    super.key,
    required this.authToken,
    required this.user,
  });
  //
  //
  @override
  Widget build(BuildContext context) {
    return PurchaseBody(
      authToken: authToken,
      user: user,
    );
  }
}
