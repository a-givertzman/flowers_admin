import 'package:ext_rw/ext_rw.dart';
///
/// # Single record of table Transaction
/// 
/// ## Defination
/// Represents the operation of debiting/crediting amount from/to Customer's account, and storing it as historian record.
/// - Crediting the amount to the Customer's account in case of adding funds
/// - Debiting the amount from the Customer's account in case of refund (payback)
/// - Debiting the amount from the Customer's account in case of payment operation (charge of Purchase Item payment)
/// 
/// ## Fields
/// - ID
/// - Author (ID) - Person who created the transaction
/// - Customer (ID)
/// - Customer Account before transaction
/// - Details - Payment details
/// - Value - the amount of payment
/// - Created timestamp
class EntryTransaction implements SchemaEntryAbstract {
  final SchemaEntry _entry;
  bool _isEmpty;
  ///
  ///
  static Map<String, FieldValue> get _initial {
    final initial = <String, FieldValue>{
	    'id': FieldValue(0),
	    'author_id': FieldValue(0),
	    'author': FieldValue(''),
	    'value': FieldValue(''),
	    'details': FieldValue(''),
	    'order_id': FieldValue(0),
	    'order': FieldValue(''),
	    'customer_id': FieldValue(null, type: FieldType.int),
	    'customer': FieldValue(''),
	    'customer_account': FieldValue(''),
	    'description': FieldValue(''),
	    'created': FieldValue(''),
	    'updated': FieldValue(''),
	    'deleted': FieldValue(''),
	    'allow_indebted': FieldValue(false),
    };
    return initial;
  }
  ///
  /// Single row of table "Transaction"
  /// - [keys] - list of field names
  EntryTransaction({
    required Map<String, FieldValue> map,
    bool isEmpty = false,
  }) :
    _entry = SchemaEntry(map: map),
    _isEmpty = isEmpty;
  //
  //
  @override
  EntryTransaction.from(Map<String, dynamic> row):
    _entry = SchemaEntry.from(row, def: _initial),
    _isEmpty = false;
  //
  //
  EntryTransaction.empty():
    _entry = SchemaEntry(map: _initial),
    _isEmpty = true;
  //
  //
  @override
  String get key => _entry.key;
  //
  //
  @override
  bool get isChanged => _entry.isChanged;
  //
  //
  @override
  bool get isSelected => _entry.isSelected;
  //
  //
  @override
  bool get isEmpty => _isEmpty;
  //
  //
  @override
  FieldValue value(String key) => _entry.value(key);
  //
  //  
  @override
  void update(String key, dynamic value) {
    _entry.update(key, value);
    _isEmpty = false;
  }
  //
  //
  @override
  void select(bool selected) => _entry.select(selected);
  //
  //
  @override
  void saved() => _entry.saved();
  //
  //
  @override
  String toString() => _entry.toString();
  ///
  /// Returns SQL to insert/update the transaction
  /// ```
  /// select set_transaction(
  /// 	author_id_ int8,
  ///   customer_id_ int8,
  ///   value_ numeric(20, 2),
  ///   details_ varchar(2048),
  ///   order_id_ int8,
  ///   description_ varchar(2048),
  ///   allow_indebted bool,
  ///   -- returns
  ///   out result_account numeric(20, 2),
  ///   out result_error text)
  /// );
  /// select set_transaction(15, 2, -33.33, 'Testing transaction - 33.33', null, 'Empty description', false);
  /// select set_transaction(15, 2, 100.33, 'Testing transaction +100.33', null, 'Empty description', false);
  /// select set_transaction(15, 2, 100.33, 'Testing transaction +100.33',    1, 'Empty description', false);
  /// ```
  ///
  /// Returns SQL to update the transaction
  /// - [author_id]           - int8, Person who created the transaction
  ///	- [customer_id]         - int8, Cuctomer which account will be proccesed
  ///	- [value]               - numeric(20, 2), The amount to be transferred to/from Customers' account
  ///	- [details]             - varchar(2048), Transfer/Payment details
  /// - [order_id]            - int8, If not NULL, trunsactions refers to the Customer's order
  /// - [description]         - varchar(2048), Additional info about transfer
  ///	- [allow_indebted]      - bool, allow the transfer to be done with insufficient funds, transfer will be completed if account is positive but insufficient
  ///
  static Sql updateSqlBuilder(Sql sql, EntryTransaction entry) {
    if (entry.isEmpty) {
      return Sql(sql: "select ;");
    } else {
      return Sql(sql: """select * from
        edit_transaction(
          ${entry.value('id').str},
          ${entry.value('author_id').str},
          ${entry.value('customer_id').str},
          ${entry.value('value').str},
          ${entry.value('details').str},
          ${entry.value('order_id').str},
          ${entry.value('description').str},
          ${entry.value('allow_indebted').str},
        );
        """,
      );
    }

  //   return Sql(sql: """UPDATE transaction SET (
  //     id,
  //     author_id,
  //     value,
  //     details,
  //     order_id,
  //     customer_id,
  //     customer_account,
  //     description,
  //     updated,
  //     deleted
  //   ) = (
  //     ${entry.value('id').str},
  //     ${entry.value('author_id').str},
  //     ${entry.value('value').str},
  //     ${entry.value('details').str},
  //     ${entry.value('order_id').str},
  //     ${entry.value('customer_id').str},
  //     ${entry.value('customer_account').str},
  //     ${entry.value('description').str},
  //     ${entry.value('updated').str},
  //     ${entry.value('deleted').str}
  //   )
  //   WHERE id = ${entry.value('id').str};
  // """);
  }
  ///
  /// Returns SQL to insert the transaction
  /// - [author_id]           - int8, Person who created the transaction
  ///	- [customer_id]         - int8, Cuctomer which account will be proccesed
  ///	- [value]               - numeric(20, 2), The amount to be transferred to/from Customers' account
  ///	- [details]             - varchar(2048), Transfer/Payment details
  /// - [order_id]            - int8, If not NULL, trunsactions refers to the Customer's order
  /// - [description]         - varchar(2048), Additional info about transfer
  ///	- [allow_indebted]      - bool, allow the transfer to be done with insufficient funds, transfer will be completed if account is positive but insufficient
  ///
  static Sql insertSqlBuilder(Sql sql, EntryTransaction entry) {
    if (entry.isEmpty) {
      return Sql(sql: "select ;");
    } else {
      return Sql(sql: """select * from
        add_transaction(
          ${entry.value('author_id').str},
          ${entry.value('customer_id').str},
          ${entry.value('value').str},
          ${entry.value('details').str},
          ${entry.value('order_id').str},
          ${entry.value('description').str},
          ${entry.value('allow_indebted').str}
        );
        """,
      );
    }
  }
  ///
  /// Returns delete transaction Sql 
  static Sql deleteSqlBuilder(Sql sql, EntryTransaction entry) {
    if (entry.isEmpty) {
      return Sql(sql: "select ;");
    } else {
      return Sql(sql: """select * from
        del_transaction(
          ${entry.value('id').str},
          ${entry.value('author_id').str},
          ${entry.value('customer_id').str},
          ${entry.value('description').str},
          ${entry.value('allow_indebted').str}
        );
        """,
      );
    }
  }

}
