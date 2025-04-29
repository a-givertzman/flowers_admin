
import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list_entry.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/t_cell.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/t_cell_list_widget.dart';
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
//
//
class _TRowState<T extends SchemaEntryAbstract> extends State<TRow<T>> {
  late final Log _log;
  final T? _entry;
  final Map<String, List<SchemaEntryAbstract>> _relations;
  final List<Field> _fields;
  final void Function()? _onTap;
  final void Function()? _onDoubleTap;
  final void Function(T? entry)? _onSelectionChange;
  final void Function(T entry)? _onEditingComplete;
  bool _onEnter = false;
  //
  //
  @override
  void initState() {
    _entry?.selectionChanged((bool isSelected) {
      _log.trace('.initState | selectionChanged: $_entry - ${isSelected ? 'isSelected' : 'isNotSelected'} ${_entry?.isSelected}');
      if (mounted) setState(() {return;});
    });
    super.initState();
  }
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
    final isHeader = _entry == null;
    final deleted = _entry?.value('deleted').str;
    final isDeleted = (deleted != null && deleted.isNotEmpty && deleted.toLowerCase() != 'null');
    final textStile = isHeader
      ? Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSecondary,
      )
      : !isDeleted
        ? Theme.of(context).textTheme.bodyMedium 
        : Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.4),
          );
    return GestureDetector(
      // behavior: HitTestBehavior.deferToChild,
      // enableFeedback: false,
      // focusColor: Colors.transparent,
      // canRequestFocus: false,
      onTap: () {
        if (!isDeleted) {
          _entry?.select(!(_entry?.isSelected ?? true));
          final onSelectionChange = _onSelectionChange;
          if (onSelectionChange != null) onSelectionChange(_entry);
          final onTap = _onTap;
          if (onTap != null) onTap();
        }
      },
      onDoubleTap: () {
        if (!isDeleted) {
          _entry?.select(true);
          final onSelectionChange = _onSelectionChange;
          if (onSelectionChange != null) onSelectionChange(_entry);
          setState(() {return;});
          final onDoubleTap = _onDoubleTap;
          if (onDoubleTap != null) onDoubleTap();
        }
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
        child: Stack(
          children: [
            if (isDeleted)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Divider(
                    color: Theme.of(context).colorScheme.error.withValues(alpha: 0.5),
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: isHeader
                  ? Theme.of(context).colorScheme.secondary
                  : _entry?.isSelected ?? false ? Colors.blue.withAlpha(128) : null,
                border: (_onEnter && !isHeader)
                  ? Border.all(color: Theme.of(context).primaryColor)
                  : Border.all(color: Colors.transparent),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildRow(context, _fields as List<Field<T>>, _entry, textStile),
              ),
            ),
          ],
        ),
      ),
    );
  }
  ///
  /// On editing completed
  void _onComplete(String value, Field field) {
    final entry = _entry;
    final onEditingComplete = _onEditingComplete;
    if (onEditingComplete != null && entry != null) {
      entry.update(field.key, value);
      onEditingComplete(entry);
    }
  }
  ///
  ///
  List<Widget> _buildRow(BuildContext context, List<Field<T>> fields, T? entry, textStyle) {
    // _log.debug("._buildRow | entry: $entry");
    final cells = fields
      .where((field) => !field.isHidden)
      .map((field) {
        return _cell(context, field, entry, textStyle);
      }).toList();
    return cells;
  }
  ///
  /// Returns built cell widget
  Widget _cell(BuildContext context, Field<T> field, T? entry, textStyle) {
    final fieldValue = entry?.value(field.key);
    // _log.debug("._buildRow | \t value: $fieldValue");
    final builder = field.builder;
    if (entry == null) {
      return TCell<T>(
        value: field.title,
        hint: field.hint,
        editable: false,
        style: textStyle,
        flex: field.flex,
      );
    }
    if (builder != null) {
      return TCell<T>.builder(
        builder: builder,
        entry: entry,
        editable: field.isEditable,
        style: textStyle,
        onComplete: (value) => _onComplete(value, field),
        flex: field.flex,
      );
    }
    if (field.relation.isNotEmpty) {
      final relation = EditListEntry(entries: _relations[field.relation.id] ?? [], field: field.relation.field);
      // _log.debug("._buildRow | \t fieldValue '$fieldValue");
      // _log.debug("._buildRow | \t relation '${field.relation.id}': $relation");
      return TCellListWidget(
        id: '${fieldValue?.value}',
        relation: relation,
        editable: field.isEditable,
        style: textStyle,
        onComplete: (value) => _onComplete(value, field),
        flex: field.flex,
      );
    } else {
      return TCell<T>(
        value: fieldValue?.value.toString() ?? field.title,
        editable: field.isEditable,
        style: textStyle,
        onComplete: (value) => _onComplete(value, field),
        flex: field.flex,
      );
    }
  }
}
