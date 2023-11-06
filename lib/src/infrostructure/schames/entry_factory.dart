import 'package:flowers_admin/src/infrostructure/schames/entry_customer.dart';
import 'package:flowers_admin/src/infrostructure/schames/entry_customer_order.dart';
import 'package:flowers_admin/src/infrostructure/schames/entry_product.dart';
import 'package:flowers_admin/src/infrostructure/schames/entry_product_category.dart';
import 'package:flowers_admin/src/infrostructure/schames/entry_purchase.dart';
import 'package:flowers_admin/src/infrostructure/schames/entry_purchase_content.dart';
import 'package:flowers_admin/src/infrostructure/schames/entry_transaction.dart';


final entryFactories = <Type, Function>{
  EntryCustomer: (Map<String, dynamic> row) => EntryCustomer.from(row),
  EntryProductCategory: (Map<String, dynamic> row) => EntryProductCategory.from(row),
  EntryProduct: (Map<String, dynamic> row) => EntryProduct.from(row),
  EntryPurchaseContent: (Map<String, dynamic> row) => EntryPurchaseContent.from(row),
  EntryPurchase: (Map<String, dynamic> row) => EntryPurchase.from(row),
  EntryTransaction: (Map<String, dynamic> row) => EntryTransaction.from(row),
  EntryCustomerOrder: (Map<String, dynamic> row) => EntryCustomerOrder.from(row),
};
