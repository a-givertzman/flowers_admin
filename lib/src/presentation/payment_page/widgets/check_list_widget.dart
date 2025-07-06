import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
///
/// Check list
class CheckListWidget<T extends SchemaEntryAbstract> extends StatefulWidget {
  final Map<int, T> items;
  final Widget Function(T entry)? builder;
  final void Function(Map<int, T> entries)? onChanged;
  ///
  ///
  const CheckListWidget({
    super.key,
    required this.items,
    this.builder,
    this.onChanged,
  });
  //
  //
  @override
  State<CheckListWidget> createState() => _CheckListWidgetState<T>();
}
//
//
class _CheckListWidgetState<T extends SchemaEntryAbstract> extends State<CheckListWidget> {
  late final Log _log;
  final ScrollController _controller = ScrollController();
  //
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
    _log.trace('.build | Customer`s (${widget.items.length}): ${widget.items.map((id, c) => MapEntry(id, c.value('name').value))}');
    return Scrollbar(
      thumbVisibility: true,
      trackVisibility: true,
      controller: _controller,
      child: ListView(
        controller: _controller,
        shrinkWrap: true,
        children: widget.items.values.map((item) {
          return ListTile(
            leading: Checkbox(
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
            title: widget.builder?.call(item) ?? Text('${item.value('name').value}'),
          );
        })
        .toList()
      ),
    );
  }
}
