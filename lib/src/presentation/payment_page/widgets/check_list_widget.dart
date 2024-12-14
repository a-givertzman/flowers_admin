import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
///
/// Check list
class CheckListWidget extends StatefulWidget {
  late final Log _log;
  final Map<int, SchemaEntryAbstract> _items;
  // final Widget Function(SchemaEntryAbstract) _builder;
  final void Function(Map<int, SchemaEntryAbstract> entries)? _onChanged;
  ///
  ///
  CheckListWidget({
    super.key,
    required Map<int, SchemaEntryAbstract> items,
    // required Widget Function(SchemaEntryAbstract) builder,
    void Function(Map<int, SchemaEntryAbstract>)? onChanged,
  }):
    _items = items,
    // _builder = builder,
    _onChanged = onChanged {
      _log = Log("$runtimeType");
    }
  //
  //
  @override
  State<CheckListWidget> createState() => _CheckListWidgetState();
}
//
//
class _CheckListWidgetState extends State<CheckListWidget> {
  final ScrollController _controller = ScrollController();
  //
  //
  @override
  Widget build(BuildContext context) {
    widget._log.trace('.build | Customer`s (${widget._items.length}): ${widget._items.map((id, c) => MapEntry(id, c.value('name').value))}');
    return Scrollbar(
      thumbVisibility: true,
      trackVisibility: true,
      controller: _controller,
      child: ListView(
        controller: _controller,
        shrinkWrap: true,
        children: widget._items.values.map((item) {
          return ListTile(
            leading: Checkbox(
              value: item.value('pay').value,
              onChanged: (value) {
                item.update('pay', value);
                setState(() {return;});
                final onChanged = widget._onChanged;
                if (onChanged != null) {
                  onChanged(widget._items);
                }
              },
            ),
            title: Text('${item.value('name').value}'),
          );
        })
        .toList()
      ),
    );
  }
}
