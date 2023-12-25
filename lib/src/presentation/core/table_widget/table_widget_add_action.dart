import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
///
class TableWidgetAction<T extends SchemaEntry, TParams> {
  final Widget _icon;
  final Future<Result> Function(TableSchemaAbstract<T, TParams>)? _onPressed;
  ///
  ///
  TableWidgetAction({
    required Widget icon,
    required Future<Result> Function(TableSchemaAbstract<T, TParams>)? onPressed,
  }):
    _icon = icon,
    _onPressed = onPressed;
  ///
  ///
  const TableWidgetAction.empty():
    _icon = const Icon(null),
    _onPressed = null;
  ///
  ///
  Widget get icon => _icon;
  ///
  ///
  Future<Result> Function(TableSchemaAbstract<T, TParams>)? get onPressed => _onPressed;
}