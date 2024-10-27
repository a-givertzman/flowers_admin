import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/presentation/customer_order_page/customer_order_page.dart';
import 'package:flowers_admin/src/presentation/customer_page/customer_page.dart';
import 'package:flowers_admin/src/presentation/payment_page/payment_page.dart';
import 'package:flowers_admin/src/presentation/product_category_page/product_category_page.dart';
import 'package:flowers_admin/src/presentation/product_page/product_page.dart';
import 'package:flowers_admin/src/presentation/purchase_item_page/purchase_item_page.dart';
import 'package:flowers_admin/src/presentation/purchase_page/purchase_page.dart';
import 'package:flowers_admin/src/presentation/transaction_page/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
///
///
class HomeBody extends StatefulWidget {
  final String _authToken;
  final AppUser _user;
  ///
  ///
  const HomeBody({
    super.key,
    required String authToken,
    required AppUser user,
  })  : _authToken = authToken,
        _user = user;
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<HomeBody> createState() => _HomeBodyState(
        authToken: _authToken,
        user: _user,
      );
}
//
//
class _HomeBodyState extends State<HomeBody> {
  final _log = Log("$_HomeBodyState._");
  final String _authToken;
  final AppUser _user;
  final _paddingH = 8.0;
  final _paddingV = 8.0;
  //
  //
  _HomeBodyState({
    required String authToken,
    required AppUser user,
  })  : _authToken = authToken,
        _user = user;
  //
  //
  @override
  Widget build(BuildContext context) {
    _log.debug('.build | ');
    final tabHeadesStyle = Theme.of(context).textTheme.headlineSmall;
    final tabs = [
      Tab(child: Text("Customers".inRu(), style: tabHeadesStyle)),
      Tab(child: Text("Transactions".inRu(), style: tabHeadesStyle)),
      Tab(child: Text("product_category".inRu(), style: tabHeadesStyle)),
      Tab(child: Text("product".inRu(), style: tabHeadesStyle)),
      Tab(child: Text("purchase".inRu(), style: tabHeadesStyle)),
      Tab(child: Text("purchase_item".inRu().inRu(), style: tabHeadesStyle)),
      Tab(child: Text("order".inRu(), style: tabHeadesStyle)),
      Tab(child: Text("Payment".inRu(), style: tabHeadesStyle)),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: TabBar(
          indicatorColor: Colors.amber,
          indicatorSize: TabBarIndicatorSize.tab,
          isScrollable: true,
          // indicator: BoxDecoration(
          //   color: Theme.of(context).cardColor,
          // ),
          tabs: tabs,
        ),
        body: TabBarView(
          children: [
            //
            // Customer Page
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: _paddingV,
                horizontal: _paddingH,
              ),
              child: CustomerPage(
                authToken: _authToken,
                user: _user,
              ),
            ),
            //
            // Transaction Page
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: _paddingV,
                horizontal: _paddingH,
              ),
              child: TransactionPage(
                authToken: _authToken,
                user: _user,
              ),
            ),
            //
            // Product category Page
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: _paddingV,
                horizontal: _paddingH,
              ),
              child: ProductCategoryPage(authToken: _authToken),
            ),
            //
            // - Page
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: _paddingV,
                horizontal: _paddingH,
              ),
              child: ProductPage(
                authToken: _authToken,
              ),
            ),
            //
            // - Page
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: _paddingV,
                horizontal: _paddingH,
              ),
              child: PurchasePage(authToken: _authToken),
            ),
            //
            // PurchaseItem Page
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: _paddingV,
                horizontal: _paddingH,
              ),
              child: PurchaseItemPage(authToken: _authToken),
            ),
            //
            // CustomerOrder Page
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: _paddingV,
                horizontal: _paddingH,
              ),
              child: CustomerOrderPage(authToken: _authToken),
            ),
            //
            // Payment Page
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: _paddingV,
                horizontal: _paddingH,
              ),
              child: PaymentPage(
                authToken: _authToken,
                user: _user,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
