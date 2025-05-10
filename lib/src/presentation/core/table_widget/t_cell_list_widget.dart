
import 'package:flowers_admin/src/presentation/core/table_widget/t_edit_list_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list_entry.dart';
import 'package:flutter/material.dart';
///
///
class TCellListWidget extends StatelessWidget {
  final String? id;
  final EditListEntry relation;
  final TextStyle? style;
  final void Function(String? value)? onComplete;
  final String? labelText;
  final bool editable;
  final int flex;
  ///
  ///
  const TCellListWidget({
    super.key,
    required this.id,
    this.relation = const EditListEntry.empty(),
    this.style,
    this.onComplete,
    this.labelText,
    this.editable = true,
    this.flex = 1,
  });
  //
  //
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: TEditListWidget(
        id: id,
        relation: relation,
        onComplete: onComplete,
        labelText: labelText,
        editable: editable,
        style: style,
      ),
    );
  }
}
