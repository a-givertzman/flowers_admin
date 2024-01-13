
import 'package:flowers_admin/src/presentation/product_page/widgets/product_body.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  final String _authToken;
  ///
  ///
  const ProductPage({
    super.key,
    required String authToken,
  }):
    _authToken = authToken;
  //
  //
  @override
  Widget build(BuildContext context) {
    return ProductBody(
      authToken: _authToken,
    );
  }
}