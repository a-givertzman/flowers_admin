
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/presentation/product_category_page/widgets/product_category_body.dart';
import 'package:flutter/material.dart';
///
/// View/Edit the categories of the `Product`
class ProductCategoryPage extends StatelessWidget {
  final String authToken;
  final AppUser user;
  ///
  ///
  const ProductCategoryPage({
    super.key,
    required this.authToken,
    required this.user,
  });
  //
  //
  @override
  Widget build(BuildContext context) {
    return ProductCategoryBody(
      authToken: authToken,
      user: user,
    );
  }
}
