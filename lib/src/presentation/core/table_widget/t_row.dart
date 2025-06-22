
import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list_entry.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/t_cell.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/t_cell_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';

///
///
class TRow<T extends SchemaEntryAbstract> extends StatefulWidget {
  final T? entry;
  final Map<String, List<SchemaEntryAbstract>> relations;
  final List<Field> fields;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function(T? entry)? onSelectionChange;
  final void Function(T entry)? onEditingComplete;
  ///
  ///
  const TRow({
    super.key,
    this.entry,
    this.relations = const {},
    required this.fields,
    this.onTap,
    this.onDoubleTap,
    this.onSelectionChange,
    this.onEditingComplete,
  });
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<TRow<T>> createState() => _TRowState<T>();
  ///
  ///
}
//
//
class _TRowState<T extends SchemaEntryAbstract> extends State<TRow<T>> {
  late final Log _log;
  bool _onEnter = false;
  //
  //
  @override
  void initState() {
    _log = Log('$runtimeType');
    widget.entry?.selectionChanged((bool isSelected) {
      _log.trace('.initState | selectionChanged: ${widget.entry} - ${isSelected ? 'isSelected' : 'isNotSelected'} ${widget.entry?.isSelected}');
      if (mounted) setState(() {return;});
    });
    super.initState();
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    final isHeader = widget.entry == null;
    final deleted = widget.entry?.value('deleted').str;
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
          widget.entry?.select(!(widget.entry?.isSelected ?? true));
          final onSelectionChange = widget.onSelectionChange;
          if (onSelectionChange != null) onSelectionChange(widget.entry);
          final onTap = widget.onTap;
          if (onTap != null) onTap();
        }
      },
      onDoubleTap: () {
        if (!isDeleted) {
          widget.entry?.select(true);
          final onSelectionChange = widget.onSelectionChange;
          if (onSelectionChange != null) onSelectionChange(widget.entry);
          setState(() {return;});
          final onDoubleTap = widget.onDoubleTap;
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
        child: TapRegion(
          onTapOutside: (PointerDownEvent _) {
            widget.entry?.select(false);
            widget.onSelectionChange?.call(widget.entry);
            // final onSelectionChange = widget.onSelectionChange;
            // if (onSelectionChange != null) onSelectionChange(widget.entry);
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
                    : widget.entry?.isSelected ?? false ? Colors.blue.withAlpha(128) : null,
                  border: (_onEnter && !isHeader)
                    ? Border.all(color: Theme.of(context).primaryColor)
                    : Border.all(color: Colors.transparent),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildRow(context, widget.fields as List<Field<T>>, widget.entry, textStile, widget.onEditingComplete),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  ///
  /// On editing completed
  void _onComplete(String? value, Field field, T? entry, void Function(T entry)? onEditingComplete) {
    if (onEditingComplete != null && entry != null) {
      entry.update(field.key, value);
      onEditingComplete(entry);
    }
  }
  ///
  ///
  List<Widget> _buildRow(BuildContext context, List<Field<T>> fields, T? entry, textStyle, void Function(T entry)? onEditingComplete) {
    // _log.debug("._buildRow | entry: $entry");
    final cells = fields
      .where((field) => !field.isHidden)
      .map((field) {
        return _cell(context, field, entry, textStyle, onEditingComplete);
      }).toList();
    return cells;
  }
  ///
  /// Returns built cell widget
  Widget _cell(BuildContext context, Field<T> field, T? entry, textStyle, void Function(T entry)? onEditingComplete) {
    final fieldValue = entry?.value(field.key);
    // _log.debug("._buildRow | \t value: $fieldValue");
    if (entry == null) {
      return TCell<T>(
        value: field.title,
        hint: field.hint,
        editable: false,
        style: textStyle,
        flex: field.flex,
      );
    }
    final builder = field.builder;
    if (builder != null) {
      return TCell<T>.builder(
        builder: builder,
        entry: entry,
        editable: field.isEditable,
        style: textStyle,
        onComplete: (value) => _onComplete(value, field, entry, onEditingComplete),
        flex: field.flex,
      );
    }
    if (field.relation.isNotEmpty) {
      final relation = EditListEntry(entries: widget.relations[field.relation.id] ?? [], field: field.relation.field);
      // _log.debug("._buildRow | \t fieldValue '$fieldValue");
      // _log.debug("._buildRow | \t relation '${field.relation.id}': $relation");
      return TCellListWidget(
        id: '${fieldValue?.value}',
        relation: relation,
        editable: field.isEditable,
        style: textStyle,
        onComplete: (value) => _onComplete(value, field, entry, onEditingComplete),
        flex: field.flex,
      );
    } else {
      return TCell<T>(
        value: fieldValue?.value.toString() ?? field.title,
        editable: field.isEditable,
        style: textStyle,
        onComplete: (value) => _onComplete(value, field, entry, onEditingComplete),
        flex: field.flex,
      );
    }
  }
}
