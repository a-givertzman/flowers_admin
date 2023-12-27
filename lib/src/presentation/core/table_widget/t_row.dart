
import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/t_cell.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/t_cell_list.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';

///
///
class TRow<T extends SchemaEntryAbstract> extends StatefulWidget {
  final T? _entry;
  final Map<String, List<SchemaEntry>> _relations;
  final List<Field> _fields;
  final void Function()? _onTap;
  final void Function(T? entry)? _onSelectionChange;
  final void Function(T entry)? _onEditingComplete;
  ///
  ///
  const TRow({
    super.key,
    T? entry,
    Map<String, List<SchemaEntry>> relations = const {},
    required List<Field> fields,
    void Function()? onTap,
    void Function(T? entry)? onSelectionChange,
    void Function(T entry)? onEditingComplete,
  }) :
    _entry = entry,
    _relations = relations,
    _fields = fields,
    _onTap = onTap,
    _onSelectionChange = onSelectionChange,
    _onEditingComplete = onEditingComplete;
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<TRow<T>> createState() => _TRowState<T>(
    entry: _entry,
    relations: _relations,
    fields: _fields,
    onTap: _onTap,
    onSelectionChange: _onSelectionChange,
    onEditingComplete: _onEditingComplete,
  );
  ///
  ///
}
///
///
class _TRowState<T extends SchemaEntryAbstract> extends State<TRow<T>> {
  final _log = Log("$TRow");
  final T? _entry;
  final Map<String, List<SchemaEntry>> _relations;
  final List<Field> _fields;
  final void Function()? _onTap;
  final void Function(T? entry)? _onSelectionChange;
  final void Function(T entry)? _onEditingComplete;
  bool _isSelected;
  bool _onEnter = false;
  ///
  ///
  _TRowState({
    required T? entry,
    required Map<String, List<SchemaEntry>> relations,
    required List<Field> fields,
    required void Function()? onTap,
    required void Function(T? entry)? onSelectionChange,
    required void Function(T entry)? onEditingComplete,
  }):
    _entry = entry,
    _relations = relations,
    _fields = fields,
    _isSelected = entry?.isSelected ?? false,
    _onTap = onTap,
    _onSelectionChange = onSelectionChange,
    _onEditingComplete = onEditingComplete;
  //
  //
  @override
  Widget build(BuildContext context) {
    final textStile = Theme.of(context).textTheme.bodyMedium;
    return GestureDetector(
      // behavior: HitTestBehavior.deferToChild,
      // enableFeedback: false,
      // focusColor: Colors.transparent,
      // canRequestFocus: false,
      onTap: () {
        _isSelected = ! _isSelected;
        _entry?.select(_isSelected);
        final onSelectionChange = _onSelectionChange;
        if (onSelectionChange != null) _onSelectionChange!(_entry);
        final onTap = _onTap;
        if (onTap != null) onTap();
        setState(() {return;});
      },
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _onEnter = true;
          });
        },
        onExit: (_) {
          setState(() {
            _onEnter = false;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: _isSelected ? Colors.blue.withAlpha(128) : null,
            border: _onEnter ? Border.all(color: Theme.of(context).primaryColor) : Border.all(color: Colors.transparent),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildRow(_fields, _entry, textStile),
          ),
        ),
      ),
    );
  }
  ///
  ///
  List<Widget> _buildRow(List<Field> fields, T? entry, textStyle) {
    final cells = fields
      .where((field) => !field.hidden)
      .map((field) {
        final value = entry?.value(field.key);
        if (field.relation.isEmpty) {
          return TCell(
            value: value?.value.toString() ?? field.key,
            editable: field.edit,
            style: textStyle,
            onComplete: (value) {
              final entry = _entry;
              final onEditingComplete = _onEditingComplete;
              if (onEditingComplete != null && entry != null) {
                entry.update(field.key, value);
                onEditingComplete(entry);
              }
            },
          );
        } else {
          final List<SchemaEntry> relEntries = _relations[field.relation.id] ?? [];
          final relation = TCellEntry(entries: relEntries, field: field.relation.field);
          _log.debug("._buildRow | relation '${field.relation.id}': $relation");
          return TCellList(
            id: value?.value,
            relation: relation,
            editable: field.edit,
            style: textStyle,
            onComplete: (value) {
              final entry = _entry;
              final onEditingComplete = _onEditingComplete;
              if (onEditingComplete != null && entry != null) {
                entry.update(field.key, value);
                onEditingComplete(entry);
              }
            },
          );
        }
      }).toList();
    return cells;
  }
}
