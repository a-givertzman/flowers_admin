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
  final TableSchemaAbstract<T, P> schema;
  final TableWidgetAction<T, P> addAction;
  final TableWidgetAction<T, P> editAction;
  final TableWidgetAction<T, P> delAction;
  final TableWidgetAction<T, P> fetchAction;
  final void Function(bool? value)? onShowDeletedChanged;
  final bool? showDeleted;
  ///
  ///
  const TableWidget({
    super.key,
    required this. schema,
    this.addAction = const TableWidgetAction.empty(),
    this.editAction = const TableWidgetAction.empty(),
    this.delAction = const TableWidgetAction.empty(),
    this.fetchAction = const TableWidgetAction.empty(),
    this.onShowDeletedChanged,
    this.showDeleted,
  });
  //
  //
  @override
  State<TableWidget<T, P>> createState() => _TableWidgetState();
}
//
//
class _TableWidgetState<T extends SchemaEntryAbstract, P> extends State<TableWidget<T, P>> {
  late final Log _log;
  final ScrollController _controller = ScrollController();
  bool? _showDeleted;
  //
  //
  @override
  void initState() {
    _log = Log('$runtimeType');
    _showDeleted = widget.showDeleted;
    super.initState();
  }
  //
  //
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    final onShowDeletedChanged = widget.onShowDeletedChanged;
    final editOnPressed = widget.editAction.onPressed;
    final addOnPressed = widget.addAction.onPressed;
    final delOnPressed = widget.delAction.onPressed;
    final fetchOnPressed = widget.fetchAction.onPressed;
    final showDeleted = _showDeleted ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(children: [
          const Expanded(child: SizedBox.shrink()),
          if (_showDeleted != null)
            Tooltip(
              message: 'Show deleted'.inRu,
              child: Checkbox(
                // title: Text(InRu('Show deleted').toString()),
                value: showDeleted,
                onChanged: (value) async {
                  if (onShowDeletedChanged != null) {
                    onShowDeletedChanged(value);
                  }
                  setState(() {
                    _showDeleted = value;
                  });
                },
              ),
            ),
          if (editOnPressed != null)
            IconButton(
              onPressed: () async {
                switch (await editOnPressed(widget.schema)) {
                  case Ok(value: final entry): () {
                    if (entry.isChanged) {
                      widget.schema.update(entry).then((result) {
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
                switch (await addOnPressed(widget.schema)) {
                  case Ok(value: final entry): () {
                    widget.schema.insert(entry: entry).then((result) {
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
                switch (await delOnPressed(widget.schema)) {
                  case Ok(value: final entry): () {
                    widget.schema.delete(entry).then((result) {
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
                switch (await fetchOnPressed(widget.schema)) {
                  case Ok(value: final _): () {
                    widget.schema.fetch(null).then((result) {
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
          future: widget.schema.fetch(null),
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
                      return Expanded(
                        child: Scrollbar(
                          thumbVisibility: true,
                          trackVisibility: true,
                          controller: _controller,
                          child: ListView(
                            shrinkWrap: true,
                            controller: _controller,
                            children: _buildRows(widget.schema, showDeleted, widget.editAction.onPressed),
                          ),
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
  List<Widget> _buildRows(TableSchemaAbstract<T, P> schema, bool showDeleted, Future<Result<T, void>> Function(TableSchemaAbstract<T, P>)? onDoubleTap) {
    // final textStile = Theme.of(context).textTheme.bodyMedium;
    final rows = [TRow<T>(fields: schema.fields)];
    rows.addAll(
      schema.entries.values
      .where((entry) {
        final deleted = '${entry.value('deleted').value ?? ''}'.toLowerCase();
        final isDeleted = deleted.isNotEmpty && deleted != 'null';
        return showDeleted || (!showDeleted && !isDeleted);
      })
      .map((entry) {
        // _log.debug("._buildRows | entry: $entry");
        return TRow<T>(
          entry: entry,
          fields: schema.fields,
          relations: schema.relations,
          onSelectionChange: (entry) {},
          onEditingComplete: (entry) => _updateEntry(schema, entry),
          onDoubleTap: () async {
            if (onDoubleTap != null) {
              switch (await onDoubleTap(schema)) {
                case Ok(value: final entry): () {
                  if (entry.isChanged) {
                    schema.update(entry).then((result) {
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
  _updateEntry(TableSchemaAbstract<T, P> schema, T entry) {
    if (entry.isChanged) {
      schema.update(entry).then((result) {
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
