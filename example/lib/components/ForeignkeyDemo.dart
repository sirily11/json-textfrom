import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/JSONForm.dart';
import 'package:json_schema_form/json_textform/JSONSchemaForm.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';
import 'package:json_schema_form/json_textform/models/components/Action.dart';
import 'package:json_schema_form/json_textform/models/components/Icon.dart';
import 'package:json_schema_form_example/menubutton/MenuButton.dart';
import 'package:json_schema_form_example/model/HomeProvider.dart';
import 'package:provider/provider.dart';

class ForeignkeyDemo extends StatefulWidget {
  @override
  _ForeignkeyDemoState createState() => _ForeignkeyDemoState();
}

class _ForeignkeyDemoState extends State<ForeignkeyDemo> {
  List<Choice> choices = [];

  @override
  Widget build(BuildContext context) {
    final schema = [
      {
        "label": "location",
        "readonly": false,
        "extra": {"related_model": "storage-management/location"},
        "name": "location_id",
        "widget": "foreignkey",
        "required": false,
        "translated": false,
        "validations": {}
      },
    ];

    final detailSchema = [
      {
        "label": "Title",
        "readonly": false,
        "extra": {"help": "Please Enter your item name", "default": ""},
        "name": "title",
        "widget": "text",
        "required": true,
        "translated": false,
        "validations": {
          "length": {"maximum": 1024}
        }
      },
    ];

    HomeProvider homeProvider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("ForeignKey Preview"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            JSONSchemaForm(
              schema: schema,
              useDialog: homeProvider.useDialog,
              showSubmitButton: homeProvider.showSubmitButton,
              filled: homeProvider.isFilled,
              rounded: homeProvider.isRounded,
              useDropdownButton: homeProvider.useDropdown,
              actions: [
                FieldAction(
                    schemaFor: 'location_id',
                    schemaName: 'title',
                    actionTypes: ActionTypes.custom,
                    actionDone: ActionDone.getInput,
                    icon: Icons.search,
                    onActionTap: (schema) async {
                      String value = await showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => AlertDialog(
                          content: TextField(
                            decoration: InputDecoration(
                              labelText: "Click OK!",
                            ),
                          ),
                          actions: [
                            FlatButton(
                              onPressed: () => Navigator.pop(context, "ok"),
                              child: Text("Ok"),
                            )
                          ],
                        ),
                      );
                      return value;
                    })
              ],
              onFetchingSchema: (path, isEdit, id) async {
                if (isEdit) {
                  var choice = choices.firstWhere(
                    (element) => element.value == id,
                    orElse: () => null,
                  );

                  if (choice != null) {
                    return SchemaValues(
                      schema: detailSchema,
                      values: {
                        "title": choice.label,
                      },
                    );
                  }
                }
                return SchemaValues(schema: detailSchema, values: {});
              },
              onSearch: homeProvider.useCustomSearch
                  ? (path, keyword) async {
                      await Future.delayed(Duration(seconds: 1));
                      return [
                        Choice(label: "Test", value: 3),
                      ];
                    }
                  : null,
              onFetchingforeignKeyChoices: (path) async {
                return choices;
              },
              onAddforeignKeyField: (path, values) async {
                var choice = Choice(
                  label: values['title'],
                  value: choices.length,
                );
                setState(() {
                  choices.add(choice);
                });
                return choice;
              },
              onUpdateforeignKeyField: (path, values, id) async {
                var index =
                    choices.indexWhere((element) => element.value == id);
                if (index > -1) {
                  setState(() {
                    choices[index].label = values['title'];
                  });
                }
                return choices[index];
              },
              onDeleteforeignKeyField: (path, id) async {
                var removed = choices.removeAt(id);
                return removed;
              },
              icons: [
                FieldIcon(
                  iconData: Icons.title,
                  schemaName: "unit",
                ),
              ],
            ),
            MenuButton(),
          ],
        ),
      ),
    );
  }
}
