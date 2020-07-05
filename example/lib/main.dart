import 'dart:io';
import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/JSONForm.dart';
import 'package:json_schema_form/json_textform/JSONSchemaForm.dart';
import 'package:json_schema_form/json_textform/models/Action.dart';
import 'package:json_schema_form/json_textform/models/Controller.dart';
import 'package:json_schema_form/json_textform/models/Icon.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';

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
  JSONSchemaController controller = JSONSchemaController();

  Future<Map<String, dynamic>> getSchema() async {
    await Future.delayed(Duration(milliseconds: 100));
    return itemJSONData;
  }

  ThemeData buildTheme() {
    final ThemeData base = ThemeData();
    return base.copyWith(
      iconTheme: IconThemeData(color: Colors.grey),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.publish),
        onPressed: () async {
          var value = await this.controller.onSubmit(context);
          print(value);
        },
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
                controller: controller,
                useDropdownButton: true,
                onAddForignKeyField: (path, values) async {
                  print("added");
                },
                onUpdateForignKeyField: (path, values, id) async {
                  print("updated");
                },
                onFetchingForignKeyChoices: (path) async {
                  print("$path");
                  return [
                    Choice(label: "Hello", value: "1"),
                  ];
                },
                onFetchingSchema: (path, isEdit, id) async {
                  print("$path $id");
                  return SchemaValues(
                    schema: (itemJSONData2['fields'] as List)
                        .map((s) => s as Map<String, dynamic>)
                        .toList(),
                    values: {},
                  );
                },
                filled: false,
                rounded: false,
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
                  FieldAction<File>(
                      schemaName: "qr_code",
                      actionTypes: ActionTypes.image,
                      actionDone: ActionDone.getImage,
                      onDone: (File file) async {
                        if (file is File) {
                          print(file);
                        }
                        return file;
                      }),
                  FieldAction<File>(
                      schemaName: "name",
                      schemaFor: "category_id",
                      actionTypes: ActionTypes.image,
                      actionDone: ActionDone.getInput,
                      onDone: (File file) async {
                        if (file is File) {
                          print(file);
                        }
                        return "abc";
                      })
                ],
                onSubmit: (value) async {
                  print(value);
                },
                url: "http://192.168.1.120",
                values: {
                  "author_id": {"label": "sdfsdfa", "value": 2},
                  "name": "abcdefhahabaa1a",
                  "time": DateTime(2016, 1, 5, 1).toIso8601String(),
                },
              ),
            );
          }),
    );
  }
}
