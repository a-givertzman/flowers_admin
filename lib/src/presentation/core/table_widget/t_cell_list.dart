
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list_entry.dart';
import 'package:flutter/material.dart';

///
///
class TCellList extends StatelessWidget {
  final String _id;
  final EditListEntry _relation;
  final TextStyle? _style;
  final void Function(String value)? _onComplete;
  // final void Function(String value)? _onSelectionChange;
  final bool _editable;
  ///
  ///
  TCellList({
    super.key,
    required String id,
    EditListEntry? relation,
    TextStyle? style,
    void Function(String value)? onComplete,
    // void Function(String value)? onSelectionChange,
    bool editable = true,
  }) :
    _id = id,
    _relation = relation ?? EditListEntry.empty(),
    _style = style,
    _onComplete = onComplete,
    // _onSelectionChange = onSelectionChange,
    _editable = editable;
  //
  //
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: EditList(
        id: _id,
        relation: _relation,
        onComplete: _onComplete,
        editable: _editable,
        style: _style,
      ),
    );
  }
}
// class TCellList extends StatefulWidget {
//   final String _id;
//   final EditListEntry _relation;
//   final TextStyle? _style;
//   final void Function(String value)? _onComplete;
//   // final void Function(String value)? _onSelectionChange;
//   final bool _editable;
//   ///
//   ///
//   TCellList({
//     super.key,
//     required String id,
//     EditListEntry? relation,
//     TextStyle? style,
//     void Function(String value)? onComplete,
//     // void Function(String value)? onSelectionChange,
//     bool editable = true,
//   }) :
//     _id = id,
//     _relation = relation ?? EditListEntry.empty(),
//     _style = style,
//     _onComplete = onComplete,
//     // _onSelectionChange = onSelectionChange,
//     _editable = editable;

//   @override
//   // ignore: no_logic_in_create_state
//   State<TCellList> createState() => _TCellListState(
//     id: _id,
//     relation: _relation,
//     style: _style,
//     onComplete: _onComplete,
//     editable: _editable,
//   );
// }
// ///
// ///
// class _TCellListState extends State<TCellList> {
//   // final _log = Log("$_TCellListState._");
//   String _id;
//   final EditListEntry _relation;
//   final TextStyle? _style;
//   final void Function(String value)? _onComplete;
//   final bool _editable;
//   final _textPaddingH = 16.0;
//   final _textPaddingV = 8.0;
//   final _textAlign = TextAlign.left;
//   bool _isEditing = false;
//   _TCellListState({
//     required String id,
//     required EditListEntry relation,
//     required TextStyle? style,
//     required void Function(String value)? onComplete,
//     required bool editable,
//   }) :
//     _id = id,
//     _relation = relation,
//     _style = style,
//     _onComplete = onComplete,
//     _editable = editable;
//   ///
//   ///
//   @override
//   Widget build(BuildContext context) {
    
//     return GestureDetector(
//       onTap: () {
//         if (_editable) {
//           setState(() {
//             _isEditing = true;
//           });
//         }
//       },
//       child: _isEditing
//         ? DropdownButton(
//             value: _id,
//             items: _relation.values.entries.map((entry) {
//               return DropdownMenuItem(
//                 value: entry.key,
//                 child: Text(
//                   entry.value,
//                   style: _style,
//                 ),
//               );
//             }).toList(),
//             onChanged: (value) {
//               _applyNewValue(value);
//             },
//             style: _style,
//             iconSize: 0.0,
//             isDense: true,
//             padding: EdgeInsets.symmetric(vertical: _textPaddingV - 8.0, horizontal: _textPaddingH),
//           )
//         : Padding(
//           padding: EdgeInsets.symmetric(vertical: _textPaddingV, horizontal: _textPaddingH),
//           child: Text(
//             _relation.value(_id),
//             style: _style,
//             textAlign: _textAlign,
//           ),
//         ),
//     );
//   }
//   ///
//   ///
//   _applyNewValue(id) {
//     setState(() {
//       _isEditing = false;
//       _id = id;
//     });
//     final onComplete = _onComplete;
//     if (onComplete != null) onComplete('$id');
//   }
// }
