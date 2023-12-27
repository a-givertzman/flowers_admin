import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/t_row.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget_add_action.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

///
///
class TableWidget<T extends SchemaEntryAbstract, P> extends StatefulWidget {
  final TableSchemaAbstract<T, P> _scheme;
  final TableWidgetAction<T, P> _addAction;
  final TableWidgetAction<T, P> _editAction;
  final TableWidgetAction<T, P> _delAction;
  ///
  ///
  const TableWidget({
    super.key,
    required TableSchemaAbstract<T, P> schema,
    TableWidgetAction<T, P>? addAction,
    TableWidgetAction<T, P>? editAction,
    TableWidgetAction<T, P>? delAction,
  }) :
    _scheme = schema,
    _addAction = addAction ?? const TableWidgetAction.empty(),
    _editAction = editAction ?? const TableWidgetAction.empty(),
    _delAction = delAction ?? const TableWidgetAction.empty();
  ///
  ///
  @override
  // ignore: no_logic_in_create_state
  State<TableWidget<T, P>> createState() => _TableWidgetState(
    scheme: _scheme,
    addAction: _addAction,
    editAction: _editAction,
    delAction: _delAction,
  );
}
///
///
class _TableWidgetState<T extends SchemaEntryAbstract, P> extends State<TableWidget<T, P>> {
  final _log = Log("$_TableWidgetState");
  final TableSchemaAbstract<T, P> _scheme;
  final TableWidgetAction<T, P> _addAction;
  final TableWidgetAction<T, P> _editAction;
  final TableWidgetAction<T, P> _delAction;
  ///
  ///
  _TableWidgetState({
    required TableSchemaAbstract<T, P> scheme,
    required TableWidgetAction<T, P>? addAction,
    required TableWidgetAction<T, P>? editAction,
    required TableWidgetAction<T, P>? delAction,
  }) :
    _scheme = scheme,
    _addAction = addAction ?? const TableWidgetAction.empty(),
    _editAction = editAction ?? const TableWidgetAction.empty(),
    _delAction = delAction ?? const TableWidgetAction.empty();
  ///
  ///
  @override
  void initState() {
    super.initState();
  }
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(children: [
          const Expanded(child: SizedBox.shrink()),
          IconButton(
            onPressed: () async {
              final onPressed = _editAction.onPressed;
              if (onPressed != null) {
                switch (await onPressed(_scheme)) {
                  case Ok(value: final entry): () {
                    if (entry.isChanged) {
                      _scheme.update(entry).then((result) {
                        if (result case Err error) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Update error'),
                              content: Text('error: ${error.error}'),
                            ),
                          );
                          return;
                        }
                        setState(() {return;});
                      });
                    }
                  } ();
                  case Err():
                }
              }
            }, 
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () async {
              final onPressed = _addAction.onPressed;
              if (onPressed != null) {
                switch (await onPressed(_scheme)) {
                  case Ok(value: final entry): () {
                    _scheme.insert(entry: entry).then((result) {
                      if (result case Err error) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Insert error'),
                            content: Text('error: ${error.error}'),
                          ),
                        );
                        return;
                      }
                      setState(() {return;});
                    });
                  } ();
                  case Err():
                }
              }
            }, 
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () async {
              final onPressed = _delAction.onPressed;
              if (onPressed != null) {
                switch (await onPressed(_scheme)) {
                  case Ok(value: final entry): () {
                    _scheme.delete(entry).then((result) {
                      if (result case Err error) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Delete error'),
                            content: Text('error: ${error.error}'),
                          ),
                        );
                        return;
                      }
                      setState(() {return;});
                    });
                  } ();
                  case Err():
                }
              }
            }, 
            icon: const Icon(Icons.remove),
          ),
        ]),
        FutureBuilder<Result<List<T>, Failure>>(
          future: _scheme.fetch(null),
          builder: (BuildContext context, AsyncSnapshot<Result<List<T>, Failure>> snapshot) {
            final textStile = Theme.of(context).textTheme.bodyMedium;
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(backgroundColor: Colors.blue),
              );
            } else {        
              _log.debug(".build | snapshot: $snapshot");
              final result = snapshot.data;
              if (result != null) {
                return switch(result) {
                  Ok(:final value) => () {
                    final entries = value;
                    if (entries.isNotEmpty) {
                      final rows = entries;
                      return ListView(
                        shrinkWrap: true,
                        // defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        // border: TableBorder.all(),
                        // columnWidths: { for (var i in [for (var i = 0; i <= 14; i++) i]) i : const IntrinsicColumnWidth() },
                        // {
                        //   0: IntrinsicColumnWidth(),
                        //   1: FlexColumnWidth(),
                        // },
                        children: _buildRows(_scheme, rows),
                      );
                    } else {
                      return Center(child: Text("No orders received", style: textStile,));
                    }
                  }(),
                  Err(:final error) => () {
                    return Center(child: Text("Error: $error", style: textStile,));
                  }(),
                };
              }
            }
            return Center(child: Text("No orders received", style: textStile,));
          },
        ),
      ],
    );
  }
  ///
  ///
  List<Widget> _buildRows(TableSchemaAbstract<T, void> scheme, List<T> entries) {
    // final textStile = Theme.of(context).textTheme.bodyMedium;
    final rows = [TRow<T>(fields: scheme.fields)];
    rows.addAll(
      entries.map((entry) {
        return TRow<T>(
          entry: entry,
          fields: scheme.fields,
          onEditingComplete: _updateEntry,
        );
      }),
    );
    return rows;
  }
  ///
  ///
  _updateEntry(T entry) {
    if (entry.isChanged) {
      _scheme.update(entry).then((result) {
        if (result is Err) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Update error'),
              content: Text('error: $result'),
            ),
          );          
        }
      });
    }
  }
}














  // ///
  // ///
  // List<Widget> _buildHead(List<Field> fields, textStyle) {
  //   final cells = fields
  //     .where((field) => !field.hidden)
  //     .map((field) {
  //       return TCell(
  //         value: field.name,
  //         style: textStyle,
  //         editable: false,
  //       );
  //     }).toList();
  //   return cells;
  // }