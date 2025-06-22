
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/presentation/product_page/widgets/product_body.dart';
import 'package:flutter/material.dart';
///
/// View / Edit the dictionary of `Product`'s
class ProductPage extends StatelessWidget {
  final String authToken;
  final AppUser user;
  ///
  /// View / Edit the dictionary of `Product`'s
  const ProductPage({
    super.key,
    required this.authToken,
    required this.user,
  });
  //
  //
  @override
  Widget build(BuildContext context) {
    return ProductBody(
      authToken: authToken,
      user: user,
    );
  }
}
