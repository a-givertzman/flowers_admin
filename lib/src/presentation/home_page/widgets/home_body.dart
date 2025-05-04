import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user_role.dart';
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
  final String authToken;
  final AppUser user;
  ///
  ///
  const HomeBody({
    super.key,
    required this.authToken,
    required this.user,
  });
  //
  //
  @override
  State<HomeBody> createState() => _HomeBodyState();
}
//
//
class _HomeBodyState extends State<HomeBody> {
  late final Log _log;
  final _paddingH = 8.0;
  final _paddingV = 8.0;
  //
  //
  @override
  void initState() {
    _log = Log('$runtimeType');
    super.initState();
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    _log.debug('.build | ');
    final user = widget.user;
    final authToken = widget.authToken;
    final tabHeadesStyle = Theme.of(context).textTheme.headlineSmall;
    final tabs = [
      Tab(child: Text("Customers".inRu, style: tabHeadesStyle)),
      Tab(child: Text("Transactions".inRu, style: tabHeadesStyle)),
      Tab(child: Text("ProductCategory".inRu, style: tabHeadesStyle)),
      Tab(child: Text("Products".inRu, style: tabHeadesStyle)),
      Tab(child: Text("Purchases".inRu, style: tabHeadesStyle)),
      Tab(child: Text("PurchaseItems".inRu.inRu, style: tabHeadesStyle)),
      Tab(child: Text("Orders".inRu, style: tabHeadesStyle)),
      Tab(child: Text("Payment".inRu, style: tabHeadesStyle)),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface, //Colors.blueGrey,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("${user.name} | ${user.role.str}"),
            )
          ],
          bottom: TabBar(
            indicatorWeight: 4.0,
            indicatorSize: TabBarIndicatorSize.tab,
            isScrollable: true,
            tabs: tabs,
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Divider(),
            //     )
            //   ],
            // ),
            Expanded(
              child: TabBarView(
                children: [
                  //
                  // Customer Page
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: _paddingV,
                      horizontal: _paddingH,
                    ),
                    child: CustomerPage(
                      authToken: authToken,
                      user: user,
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
                      authToken: authToken,
                      user: user,
                    ),
                  ),
                  //
                  // Product category Page
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: _paddingV,
                      horizontal: _paddingH,
                    ),
                    child: ProductCategoryPage(
                      authToken: authToken,
                      user: user,
                    ),
                  ),
                  //
                  // - Page
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: _paddingV,
                      horizontal: _paddingH,
                    ),
                    child: ProductPage(
                      authToken: authToken,
                      user: user,
                    ),
                  ),
                  //
                  // - Page
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: _paddingV,
                      horizontal: _paddingH,
                    ),
                    child: PurchasePage(
                      authToken: authToken,
                      user: user,
                    ),
                  ),
                  //
                  // PurchaseItem Page
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: _paddingV,
                      horizontal: _paddingH,
                    ),
                    child: PurchaseItemPage(
                      authToken: authToken,
                      user: user,
                    ),
                  ),
                  //
                  // CustomerOrder Page
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: _paddingV,
                      horizontal: _paddingH,
                    ),
                    child: CustomerOrderPage(
                      authToken: authToken,
                      user: user,
                    ),
                  ),
                  //
                  // Payment Page
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: _paddingV,
                      horizontal: _paddingH,
                    ),
                    child: PaymentPage(
                      authToken: authToken,
                      user: user,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
