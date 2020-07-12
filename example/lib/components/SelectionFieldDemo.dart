import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/JSONSchemaForm.dart';
import 'package:json_schema_form/json_textform/models/components/Icon.dart';
import 'package:json_schema_form_example/menubutton/MenuButton.dart';
import 'package:json_schema_form_example/model/HomeProvider.dart';
import 'package:provider/provider.dart';

class SelectionFieldDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final schema = [
      {
        "label": "unit",
        "readonly": false,
        "extra": {
          "choices": [
            {"label": "US Dollar", "value": "USD"},
            {"label": "Hong Kong Dollar", "value": "HDK"},
            {"label": "RMB", "value": "CNY"}
          ],
          "default": "USD"
        },
        "name": "unit",
        "widget": "select",
        "required": false,
        "translated": false,
        "validations": {}
      },
    ];

    HomeProvider homeProvider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("CheckBox Preview"),
      ),
      body: Stack(
        children: <Widget>[
          JSONSchemaForm(
            schema: schema,
            showSubmitButton: homeProvider.showSubmitButton,
            filled: homeProvider.isFilled,
            rounded: homeProvider.isRounded,
            useDropdownButton: homeProvider.useDropdown,
            onFetchingSchema: null,
            onFetchingforeignKeyChoices: null,
            onAddforeignKeyField: null,
            onUpdateforeignKeyField: null,
            onDeleteforeignKeyField: null,
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
    );
  }
}
