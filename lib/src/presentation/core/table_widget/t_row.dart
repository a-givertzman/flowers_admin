
import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list_entry.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/t_cell.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/t_cell_list.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';

///
///
class TRow<T extends SchemaEntryAbstract> extends StatefulWidget {
  final T? _entry;
  final Map<String, List<SchemaEntryAbstract>> _relations;
  final List<Field> _fields;
  final void Function()? _onTap;
  final void Function()? _onDoubleTap;
  final void Function(T? entry)? _onSelectionChange;
  final void Function(T entry)? _onEditingComplete;
  ///
  ///
  const TRow({
    super.key,
    T? entry,
    Map<String, List<SchemaEntryAbstract>> relations = const {},
    required List<Field> fields,
    void Function()? onTap,
    void Function()? onDoubleTap,
    void Function(T? entry)? onSelectionChange,
    void Function(T entry)? onEditingComplete,
  }) :
    _entry = entry,
    _relations = relations,
    _fields = fields,
    _onTap = onTap,
    _onDoubleTap = onDoubleTap,
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
    onDoubleTap: _onDoubleTap,
    onSelectionChange: _onSelectionChange,
    onEditingComplete: _onEditingComplete,
  );
  ///
  ///
}
///
///
class _TRowState<T extends SchemaEntryAbstract> extends State<TRow<T>> {
  late final Log _log;
  final T? _entry;
  final Map<String, List<SchemaEntryAbstract>> _relations;
  final List<Field> _fields;
  final void Function()? _onTap;
  final void Function()? _onDoubleTap;
  final void Function(T? entry)? _onSelectionChange;
  final void Function(T entry)? _onEditingComplete;
  bool _isSelected;
  bool _onEnter = false;
  ///
  ///
  _TRowState({
    required T? entry,
    required Map<String, List<SchemaEntryAbstract>> relations,
    required List<Field> fields,
    required void Function()? onTap,
    void Function()? onDoubleTap,
    required void Function(T? entry)? onSelectionChange,
    required void Function(T entry)? onEditingComplete,
  }):
    _entry = entry,
    _relations = relations,
    _fields = fields,
    _isSelected = entry?.isSelected ?? false,
    _onTap = onTap,
    _onDoubleTap = onDoubleTap,
    _onSelectionChange = onSelectionChange,
    _onEditingComplete = onEditingComplete {
    _log = Log('$runtimeType');
    }
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
        if (onSelectionChange != null) onSelectionChange(_entry);
        setState(() {return;});
        final onTap = _onTap;
        if (onTap != null) onTap();
      },
      onDoubleTap: () {
        _isSelected = true;
        _entry?.select(_isSelected);
        final onSelectionChange = _onSelectionChange;
        if (onSelectionChange != null) onSelectionChange(_entry);
        setState(() {return;});
        final onDoubleTap = _onDoubleTap;
        if (onDoubleTap != null) onDoubleTap();
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
    _log.debug("._buildRow | entry: $entry");
    final cells = fields
      .where((field) => !field.isHidden)
      .map((field) {
        final fieldValue = entry?.value(field.key);
        _log.debug("._buildRow | \t value: $fieldValue");
        if (field.relation.isEmpty) {
          return TCell(
            value: fieldValue?.value.toString() ?? (field.title.isNotEmpty ? field.title : field.key),
            editable: field.isEditable,
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
          final List<SchemaEntryAbstract>? relEntries = _relations[field.relation.id];
          if (relEntries != null) {
            final relation = EditListEntry(entries: relEntries, field: field.relation.field);
            _log.debug("._buildRow | \t fieldValue '$fieldValue");
            _log.debug("._buildRow | \t relation '${field.relation.id}': $relation");
            // _log.debug("._buildRow | \t relEntries '$relEntries");
            return TCellList(
              id: '${fieldValue?.value}',
              relation: relation,
              editable: field.isEditable,
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
          return TCell(
            value: field.title.isNotEmpty ? field.title : field.key,
            editable: false,
            style: textStyle,
          );
        }
      }).toList();
    return cells;
  }
}
