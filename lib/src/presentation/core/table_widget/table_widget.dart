import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/t_row.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/table_widget_add_action.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
///
///
class TableWidget<T extends SchemaEntryAbstract, P> extends StatefulWidget {
  final TableSchemaAbstract<T, P> _schema;
  final TableWidgetAction<T, P> _addAction;
  final TableWidgetAction<T, P> _editAction;
  final TableWidgetAction<T, P> _delAction;
  final TableWidgetAction<T, P> _fetchAction;
  final bool? _showDeleted;
  ///
  ///
  const TableWidget({
    super.key,
    required TableSchemaAbstract<T, P> schema,
    TableWidgetAction<T, P>? addAction,
    TableWidgetAction<T, P>? editAction,
    TableWidgetAction<T, P>? delAction,
    TableWidgetAction<T, P>? fetchAction,
    bool? showDeleted,
  }) :
    _schema = schema,
    _addAction = addAction ?? const TableWidgetAction.empty(),
    _editAction = editAction ?? const TableWidgetAction.empty(),
    _delAction = delAction ?? const TableWidgetAction.empty(),
    _fetchAction = fetchAction ?? const TableWidgetAction.empty(),
    _showDeleted = showDeleted;
  ///
  ///
  @override
  // ignore: no_logic_in_create_state
  State<TableWidget<T, P>> createState() => _TableWidgetState(
    schema: _schema,
    addAction: _addAction,
    editAction: _editAction,
    delAction: _delAction,
    fetchAction: _fetchAction,
    showDeleted: _showDeleted,
  );
}
///
///
class _TableWidgetState<T extends SchemaEntryAbstract, P> extends State<TableWidget<T, P>> {
  final _log = Log("$_TableWidgetState");
  final TableSchemaAbstract<T, P> _schema;
  final TableWidgetAction<T, P> _addAction;
  final TableWidgetAction<T, P> _editAction;
  final TableWidgetAction<T, P> _delAction;
  final TableWidgetAction<T, P> _fetchAction;
  bool? _showDeleted;
  ///
  ///
  _TableWidgetState({
    required TableSchemaAbstract<T, P> schema,
    required TableWidgetAction<T, P> addAction,
    required TableWidgetAction<T, P> editAction,
    required TableWidgetAction<T, P> delAction,
    required TableWidgetAction<T, P> fetchAction,
    required bool? showDeleted,
  }) :
    _schema = schema,
    _addAction = addAction,
    _editAction = editAction,
    _delAction = delAction,
    _fetchAction = fetchAction,
    _showDeleted = showDeleted;
  ///
  ///
  @override
  Widget build(BuildContext context) {
    final editOnPressed = _editAction.onPressed;
    final addOnPressed = _addAction.onPressed;
    final delOnPressed = _delAction.onPressed;
    final fetchOnPressed = _fetchAction.onPressed;
    final showDeleted = _showDeleted;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(children: [
          const Expanded(child: SizedBox.shrink()),
          if (showDeleted != null)
            Tooltip(
              message: 'Show deleted'.inRu(),
              child: Checkbox(
                value: showDeleted,
                onChanged: (value) {
                  setState(() {
                    _showDeleted = value;
                  });
                },
              ),
            ),
          if (editOnPressed != null)
            IconButton(
              onPressed: () async {
                switch (await editOnPressed(_schema)) {
                  case Ok(value: final entry): () {
                    if (entry.isChanged) {
                      _schema.update(entry).then((result) {
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
              }, 
              icon: const Icon(Icons.edit),
            ),
          if (addOnPressed != null)
            IconButton(
              onPressed: () async {
                switch (await addOnPressed(_schema)) {
                  case Ok(value: final entry): () {
                    _schema.insert(entry: entry).then((result) {
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
              }, 
              icon: const Icon(Icons.add),
            ),
          if (delOnPressed != null)
            IconButton(
              onPressed: () async {
                switch (await delOnPressed(_schema)) {
                  case Ok(value: final entry): () {
                    _schema.delete(entry).then((result) {
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
              }, 
              icon: const Icon(Icons.remove),
            ),
          if (fetchOnPressed != null)
            IconButton(
              onPressed: () async {
                switch (await fetchOnPressed(_schema)) {
                  case Ok(value: final _): () {
                    _schema.fetch(null).then((result) {
                      if (result case Err error) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Fetch error'),
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
              }, 
              icon: const Icon(Icons.refresh),
            ),
        ]),
        FutureBuilder<Result<List<T>, Failure>>(
          future: _schema.fetch(null),
          builder: (BuildContext context, AsyncSnapshot<Result<List<T>, Failure>> snapshot) {
            final textStile = Theme.of(context).textTheme.bodyMedium;
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(backgroundColor: Colors.blue),
              );
            } else {
              final result = snapshot.data;
              if (result != null) {
                return switch(result) {
                  Ok(value: final entries) => () {
                    // _log.debug(".build | snapshot entries: $entries");
                    if (entries.isNotEmpty) {
                      // final rows = entries;
                      return Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          // defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          // border: TableBorder.all(),
                          // columnWidths: { for (var i in [for (var i = 0; i <= 14; i++) i]) i : const IntrinsicColumnWidth() },
                          // {
                          //   0: IntrinsicColumnWidth(),
                          //   1: FlexColumnWidth(),
                          // },
                          children: _buildRows(_schema),
                        ),
                      );
                    } else {
                      return Center(child: Text("No items received", style: textStile,));
                    }
                  }(),
                  Err(:final error) => () {
                    _log.debug(".build | snapshot has error: $error");
                    return Center(child: Text("Error: $error", style: textStile,));
                  }(),
                };
              }
            }
            return Center(child: Text("No items received", style: textStile,));
          },
        ),
      ],
    );
  }
  ///
  ///
  List<Widget> _buildRows(TableSchemaAbstract<T, void> schema) {
    // final textStile = Theme.of(context).textTheme.bodyMedium;
    final rows = [TRow<T>(fields: schema.fields)];
    final showDeleted = _showDeleted ?? false;
    rows.addAll(
      schema.entries
      .where((entry) {
        final deleted = entry.value('deleted').str;
        final isDeleted = deleted != null && deleted.isNotEmpty && deleted.toLowerCase() != 'null';
        return showDeleted || (!showDeleted && !isDeleted);
      })
      .map((entry) {
        // _log.debug("._buildRows | entry: $entry");
        return TRow<T>(
          entry: entry,
          fields: schema.fields,
          relations: schema.relations,
          onEditingComplete: _updateEntry,
          onDoubleTap: () async {
            final onPressed = _editAction.onPressed;
            if (onPressed != null) {
              switch (await onPressed(_schema)) {
                case Ok(value: final entry): () {
                  if (entry.isChanged) {
                    _schema.update(entry).then((result) {
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
        );
      }),
    );
    return rows;
  }
  ///
  ///
  _updateEntry(T entry) {
    if (entry.isChanged) {
      _schema.update(entry).then((result) {
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