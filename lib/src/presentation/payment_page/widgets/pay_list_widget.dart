import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/infrostructure/payment/entry_pay_customer.dart';
import 'package:flowers_admin/src/infrostructure/payment/entry_pay_purchase.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
///
/// Check list
class PayListWidget<T extends SchemaEntryAbstract> extends StatefulWidget {
  final List<Field<T>> header;
  final Map<String, T> items;
  final Map<int, EntryPayCustomer> customers;
  final Map<int, EntryPayPurchase> purchases;
  // final Widget Function(T) _builder;
  final void Function(Map<String, T> entries)? onChanged;
  ///
  ///
  const PayListWidget({
    super.key,
    required this.header,
    required this.items,
    required this.customers,
    required this.purchases,
    // required this.builder,
    this.onChanged,
  });
  //
  @override
  State<PayListWidget<T>> createState() => _CheckListWidgetState();
}
//
//
class _CheckListWidgetState<T extends SchemaEntryAbstract> extends State<PayListWidget<T>> {
  late final Log _log;
  final ScrollController _controller = ScrollController();
  //
  @override
  void initState() {
    _log = Log("$runtimeType");
    super.initState();
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    // widget._log.trace('.build | Customer`s (${widget._items.length}): ${widget._items.map((id, c) => MapEntry(id, c.value('name').value))}');
    return Scrollbar(
      controller: _controller,
      thumbVisibility: true,
      trackVisibility: true,
      child: SingleChildScrollView(
        controller: _controller,
        child: Table(
            columnWidths: const <int, TableColumnWidth>{
              0: IntrinsicColumnWidth(),
              1: IntrinsicColumnWidth(),
              2: FlexColumnWidth(),
              3: FlexColumnWidth(),
              4: FlexColumnWidth(),
              5: IntrinsicColumnWidth(),
              6: IntrinsicColumnWidth(),
              7: IntrinsicColumnWidth(),
              8: IntrinsicColumnWidth(),
              9: IntrinsicColumnWidth(),
              10: IntrinsicColumnWidth(),
              11: FlexColumnWidth(2),
            },
            border: TableBorder.all(),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                decoration: BoxDecoration(),
                children: widget.header
                  .where((item) => !item.isHidden)
                  .map((item) {
                    return Cell(child: Text(item.title.isEmpty ? item.key : item.title, softWrap: false));
                  }).toList(),
              ),
              ...widget.items.values.map((item) {
                double asDouble(item, key) {
                  return double.tryParse('${item.value(key).value}') ?? 0.0;
                }
                final costColor = Colors.black; //asDouble(item, 'paid') < asDouble(item, 'cost') ? Colors.red : Colors.black;
                final paidColor = (asDouble(item, 'paid') < asDouble(item, 'cost')) || asDouble(item, 'paid') > asDouble(item, 'cost') && (asDouble(item, 'paid') - asDouble(item, 'cost') > asDouble(item, 'refounded')) ? Colors.red : Colors.black;
                final distributedColor = asDouble(item, 'paid') >= asDouble(item, 'cost') && asDouble(item, 'distributed') < asDouble(item, 'count') ? Colors.red : Colors.black;
                final toRefoundColor = asDouble(item, 'to_refound') > asDouble(item, 'refounded') ? Colors.red : Colors.black;
                final refoundedColor = asDouble(item, 'refounded') > asDouble(item, 'to_refound') ? Colors.red : Colors.black;
                final customerId = item.value('customer_id').value;
                final putchaseId = item.value('purchase_id').value;
                final customerPay = widget.customers[customerId]?.value("pay").value ?? false;
                final purchasePay  =widget.purchases[putchaseId]?.value("pay").value ?? false;
                _log.debug('.build | customerId: $customerId,  isSelected: $customerPay');
                _log.debug('.build | putchaseId: $putchaseId,  isSelected: $purchasePay');
                final pay = customerPay && purchasePay;
                _log.debug('.build | pay: $pay');
                item.update('pay', pay);
                return TableRow(
                  decoration: BoxDecoration(),
                  children: [
                    Cell(
                      child: Checkbox(
                        value: item.value('pay').value,
                        onChanged: (value) {
                          item.update('pay', value);
                          setState(() {return;});
                          final onChanged = widget.onChanged;
                          if (onChanged != null) {
                            onChanged(widget.items);
                          }
                        },
                      ),
                    ),
                    Cell(child: Text('${item.value('id').value}', softWrap: false)),
                    Cell(child: Text('[$customerId] ${item.value('customer').value}', softWrap: false)),
                    Cell(child: Text('[${item.value('purchase_item_id').value}] ${item.value('purchase').value}', softWrap: false)),
                    Cell(child: Text('${item.value('product').value}}', softWrap: false)),
                    Cell(child: Text('${item.value('count').value}', softWrap: false, textAlign: TextAlign.right)),
                    Cell(child: Text('${item.value('cost').value}', softWrap: false, textAlign: TextAlign.right, style: DefaultTextStyle.of(context).style.copyWith(color: costColor))),
                    Cell(child: Text('${item.value('paid').value}', softWrap: false, textAlign: TextAlign.right, style: DefaultTextStyle.of(context).style.copyWith(color: paidColor))),
                    Cell(child: Text('${item.value('distributed').value}', softWrap: false, textAlign: TextAlign.right, style: DefaultTextStyle.of(context).style.copyWith(color: distributedColor))),
                    Cell(child: Text('${item.value('to_refound').value}', softWrap: false, textAlign: TextAlign.right, style: DefaultTextStyle.of(context).style.copyWith(color: toRefoundColor))),
                    Cell(child: Text('${item.value('refounded').value}', softWrap: false, textAlign: TextAlign.right, style: DefaultTextStyle.of(context).style.copyWith(color: refoundedColor))),
                    Cell(child: Text('${item.value('description').value}', softWrap: false, overflow: TextOverflow.fade)),
                  ],
                );
              }),
            ]
          ),
      ),
    );
  }
}
///
///
class Cell extends StatelessWidget {
  final Widget child;
  final Color? color;
  ///
  ///
  const Cell({
    super.key,
    required this.child,
    this.color,
  });
  //
  //
  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: child,
      ),
    );
  }
}
