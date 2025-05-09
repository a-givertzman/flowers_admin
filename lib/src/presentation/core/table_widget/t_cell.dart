import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/t_edit_widget.dart';
import 'package:flutter/material.dart';

///
/// Cell Widget for [TableWidget]
class TCell<T extends SchemaEntryAbstract> extends StatelessWidget {
  final String value;
  final String hint;
  final TextStyle? style;
  final void Function(String value)? onComplete;
  final Widget Function(BuildContext ctx, T entry, Function(String)? onComplete)? _builder;
  final T? entry;
  final bool editable;
  final int flex;
  ///
  ///
  const TCell({
    super.key,
    this.value = '',
    this.hint = '',
    this.style,
    this.onComplete,
    this.entry,
    this.editable = true,
    this.flex = 1,
  }) :
    _builder = null;
  ///
  ///
  const TCell.builder({
    super.key,
    this.value = '',
    this.hint = '',
    this.style,
    this.onComplete,
    required Widget Function(BuildContext ctx, T entry, Function(String)? onComplete)? builder,
    required T this.entry,
    this.editable = true,
    this.flex = 1,
  }) :
    _builder = builder;
  //
  //
  @override
  Widget build(BuildContext context) {
    final builder = _builder;
    final entry_ = entry;
    if (builder != null && entry_ != null) {
      return Expanded(
        flex: flex,
        child: builder(context, entry_, onComplete),
      );
    }
    return Expanded(
      flex: flex,
      child: TEditWidget(
        value: value,
        hint: hint,
        style: style,
        onComplete: onComplete,
        editable: editable,
      ),
    );
  }
}
