
import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/t_cell.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/t_cell_list.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';

///
///
class TRow<T extends SchemaEntry> extends StatelessWidget {
  final _log = Log("$TRow");
  final T? _entry;
  final Map<String, List<SchemaEntry>> _relations;
  final List<Field> _fields;
  final void Function()? _onTap;
  final void Function(T? entry)? _onSelectionChange;
  final void Function(T entry)? _onEditingComplete;
  bool _isSelected;
  ///
  ///
  TRow({
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
    _isSelected = entry?.isSelected ?? false,
    // _cells = children,
    _onTap = onTap,
    _onSelectionChange = onSelectionChange,
    _onEditingComplete = onEditingComplete;

  @override
  Widget build(BuildContext context) {
    final textStile = Theme.of(context).textTheme.bodyMedium;
    return InkWell(
      onTap: () {
        _isSelected = ! _isSelected;
        _entry?.select(_isSelected);
        final onSelectionChange = _onSelectionChange;
        if (onSelectionChange != null) _onSelectionChange!(_entry);
        final onTap = _onTap;
        if (onTap != null) onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        color: isSelected ? Colors.blue : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildRow(_fields, _entry, textStile),
          // children: _buildCells(context, _children, _isSelected),
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
  ///
  ///
  bool get isSelected => _isSelected;
}





  // ///
  // ///
  // List<Widget> _buildCells(BuildContext context, List<Widget> cells, bool isSelected) {
  //   return cells.map((cell) {
  //     return InkWell(
  //       onTap: () {
  //         final onTap = _onTap;
  //         if (onTap != null) onTap();
  //       },
  //       child: Container(
  //         padding: const EdgeInsets.symmetric(vertical: 1.5, horizontal: 2.5),
  //         decoration: const BoxDecoration(
  //           border: Border.symmetric(
  //             vertical: BorderSide(),
  //           ),
  //         ),
  //         child: cell,
  //       ),
  //     );
  //   }).toList();
  // }
