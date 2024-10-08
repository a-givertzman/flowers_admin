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
  final bool _isEmpty;
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
    _entry = SchemaEntry(map: _initial),
    _isEmpty = false {
    for (final MapEntry(:key, :value) in row.entries) {
      _entry.update(key, value);
    }
  }
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
  void update(String key, dynamic value) => _entry.update(key, value);
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
}
