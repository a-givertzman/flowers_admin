import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/settings/settings.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user_role.dart';
import 'package:flowers_admin/src/infrostructure/customer/entry_customer.dart';
import 'package:flowers_admin/src/presentation/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_core/hmi_core_log.dart';
///
///
class AuthBody extends StatefulWidget {
  final String authToken;
  ///
  ///
  const AuthBody({
    super.key,
    required this.authToken,
  });
  //
  //
  @override
  State<AuthBody> createState() => AuthBodyState();
}
//
//
class AuthBodyState extends State<AuthBody> {
  late final Log _log;
  final _database = Setting('api-database').toString();
  final _apiAddress = ApiAddress(host: Setting('api-host').toString(), port: Setting('api-port').toInt);
  AppUser _user = AppUser.empty();
  //
  //
  @override
  void initState() {
    _log = Log("$runtimeType");
    super.initState();
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    _log.debug('.build | ');
    final authToken = widget.authToken;
    final tabHeadesStyle = Theme.of(context).textTheme.headlineSmall;
    final tabs = [
      Tab(child: Text("By email".inRu, style: tabHeadesStyle)),
      Tab(child: Text("By phone".inRu, style: tabHeadesStyle)),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${_user.name.isEmpty ? 'Not authenticated' : _user.name} | ${_user.role.str}"),
                  )
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: FutureBuilder(
                  future: SqlAccess<EntryCustomer, void>(
                    address: _apiAddress,
                    authToken: authToken,
                    database: _database,
                    sqlBuilder: (sql, params) {
                      return Sql(sql: 'select * from customer order by id;');
                    },
                    entryBuilder: (row) {
                      final entry = EntryCustomer.from(row);
                      // _log.debug('.build.entryBuilder | entry: $entry');
                      return entry;
                    },
                  ).fetch(),
                  builder: (BuildContext context, snapshot) {
                    final textStile = Theme.of(context).textTheme.bodyMedium;
                    if (snapshot.connectionState == ConnectionState.done) {
                      switch (snapshot.data) {
                        case Ok(value :final users):
                          final oddItemColor = Theme.of(context).colorScheme.primary.withValues(alpha: 0.04);
                          final evenItemColor = Theme.of(context).colorScheme.primary.withValues(alpha: 0.08);
                          return SizedBox(
                            width: 300.0,
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: users.length,
                              separatorBuilder: (context, index) => const Divider(color: Colors.transparent,),
                              itemBuilder: (BuildContext context, int index) {
                                final user = users[index];
                                final userId = user.value('id').value;
                                final userName = '${user.value('name').value}';
                                final userPhone = '${user.value('phone').value}';
                                final userRole = AppUserRole.from('${user.value('role').value}');
                                return ListTile(
                                  onTap: () {
                                    setState(() {
                                      _user = AppUser(
                                        id: '$userId',
                                        name: userName,
                                        role: userRole,
                                      );
                                    });
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => HomePage(
                                        authToken: authToken,
                                        user: _user,
                                      )),
                                    );
                                  },
                                  tileColor: index.isOdd ? oddItemColor : evenItemColor,
                                  leading: Text('$userId'),
                                  title: Text(userName),
                                  subtitle: Text(userPhone),
                                  trailing: Text('$userRole'),
                                );
                              },
                            ),
                          );
                        case Err(:final error):
                          _log.debug(".build | result has error: $error");
                          return Center(child: Text("Error: $error", style: textStile,));
                        case null:
                          _log.debug(".build | snapshot has error: ${snapshot.error}");
                          return Center(child: Text("Error: ${snapshot.error}", style: textStile,));
                      }
                    }
                    return Center(child: Column(
                      children: [
                        Text("Loading...", style: textStile,),
                        CircularProgressIndicator(),
                      ],
                    ));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
