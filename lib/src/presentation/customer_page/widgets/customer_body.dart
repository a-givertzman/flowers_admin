import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
// import 'package:hmi_core/hmi_core_log.dart';


class CustomerBody extends StatefulWidget {
  const CustomerBody({super.key});

  @override
  State<CustomerBody> createState() => _CustomerBodyState();
}

class _CustomerBodyState extends State<CustomerBody> {
  // final _log = Log("$_CustomerBodyState._");
  final _apiAddress = ApiAddress.localhost(port: 8080);
  final _paddingH = 8.0;
  final _paddingV = 8.0;
  ///
  @override
  Widget build(BuildContext context) {
    final tabHeadesStyle = Theme.of(context).textTheme.headlineSmall;
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: null,
        body: Text('Customer page'),
      ),
    );
  }
}
