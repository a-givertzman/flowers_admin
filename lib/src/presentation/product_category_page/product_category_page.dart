
import 'package:flowers_admin/src/presentation/product_category_page/widgets/product_category_body.dart';
import 'package:flutter/material.dart';

class ProductCategoryPage extends StatelessWidget {
  final String _authToken;
  ///
  ///
  const ProductCategoryPage({
    super.key,
    required String authToken,
  }):
    _authToken = authToken;
  //
  //
  @override
  Widget build(BuildContext context) {
    return ProductCategoryBody(
      authToken: _authToken,
    );
  }
}
