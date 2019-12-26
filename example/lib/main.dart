import 'package:flutter/material.dart';
import 'package:json_schema_form/JSONSchemaForm.dart';
import 'package:json_schema_form/models/Action.dart';
import 'package:json_schema_form/models/Icon.dart';

import 'data/sample_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Map<String, dynamic>> getSchema() async {
    await Future.delayed(Duration(milliseconds: 100));
    return itemJSONData;
  }

  ThemeData buildTheme() {
    final ThemeData base = ThemeData();
    return base.copyWith(
      iconTheme: IconThemeData(color: Colors.white),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.blue,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Form"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
          future: getSchema(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            return Theme(
              data: buildTheme(),
              child: JSONSchemaForm(
                rounded: true,
                schema: (snapshot.data['fields'] as List)
                    .map((s) => s as Map<String, dynamic>)
                    .toList(),
                icons: [
                  FieldIcon(schemaName: "name", iconData: Icons.title),
                  FieldIcon(
                      schemaName: "description", iconData: Icons.description),
                  FieldIcon(schemaName: "price", iconData: Icons.attach_money),
                  FieldIcon(schemaName: "column", iconData: Icons.view_column),
                  FieldIcon(schemaName: "row", iconData: Icons.view_list),
                  FieldIcon(schemaName: "qr_code", iconData: Icons.scanner),
                  FieldIcon(schemaName: "unit", iconData: Icons.g_translate)
                ],
                actions: [
                  FieldAction(
                      schemaName: "qr_code",
                      actionTypes: ActionTypes.qrScan,
                      actionDone: ActionDone.getInput)
                ],
                onSubmit: (value) {
                  print(value);
                },
                values: {
                  "author_id": {"label": "sdfsdf", "value": 2},
                  "name": "abc"
                },
              ),
            );
          }),
    );
  }
}
