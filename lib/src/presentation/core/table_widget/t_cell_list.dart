
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list_entry.dart';
import 'package:flutter/material.dart';
///
///
class TCellList extends StatelessWidget {
  final String? _id;
  final EditListEntry _relation;
  final TextStyle? _style;
  final void Function(String value)? _onComplete;
  // final void Function(String value)? _onSelectionChange;
  final String? _labelText;
  final bool _editable;
  ///
  ///
  TCellList({
    super.key,
    required String? id,
    EditListEntry? relation,
    TextStyle? style,
    void Function(String value)? onComplete,
    // void Function(String value)? onSelectionChange,
    String? labelText,
    bool editable = true,
  }) :
    _id = id,
    _relation = relation ?? EditListEntry.empty(),
    _style = style,
    _onComplete = onComplete,
    // _onSelectionChange = onSelectionChange,
    _labelText = labelText,
    _editable = editable;
  //
  //
  @override
  Widget build(BuildContext context) {
    return EditList(
      id: _id,
      relation: _relation,
      onComplete: _onComplete,
      labelText: _labelText,
      editable: _editable,
      style: _style,
    );
  }
}
