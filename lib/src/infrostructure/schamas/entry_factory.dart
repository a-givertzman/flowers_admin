import 'package:flowers_admin/src/infrostructure/schamas/entry_customer.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_customer_order.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_product.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_product_category.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_purchase.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_purchase_content.dart';
import 'package:flowers_admin/src/infrostructure/schamas/entry_transaction.dart';
import 'package:flowers_admin/src/infrostructure/schamas/schema_entry.dart';


final entryFromFactories = <Type, Function>{
  EntryCustomer: (Map<String, dynamic> row) => EntryCustomer.from(row),
  EntryProductCategory: (Map<String, dynamic> row) => EntryProductCategory.from(row),
  EntryProduct: (Map<String, dynamic> row) => EntryProduct.from(row),
  EntryPurchaseContent: (Map<String, dynamic> row) => EntryPurchaseContent.from(row),
  EntryPurchase: (Map<String, dynamic> row) => EntryPurchase.from(row),
  EntryTransaction: (Map<String, dynamic> row) => EntryTransaction.from(row),
  EntryCustomerOrder: (Map<String, dynamic> row) => EntryCustomerOrder.from(row),
};

final entryEmptyFactories = <Type, Function>{
  EntryCustomer: () => EntryCustomer.empty(),
  EntryProductCategory: () => EntryProductCategory.empty(),
  EntryProduct: () => EntryProduct.empty(),
  EntryPurchaseContent: () => EntryPurchaseContent.empty(),
  EntryPurchase: () => EntryPurchase.empty(),
  EntryTransaction: () => EntryTransaction.empty(),
  EntryCustomerOrder: () => EntryCustomerOrder.empty(),
};
