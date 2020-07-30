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
            {"label": "RMB", "value": "CNY"},
            {"label": "US Dollar", "value": "1"},
            {"label": "US Dollar", "value": "2"},
            {"label": "US Dollar", "value": "3"},
            {"label": "US Dollar", "value": "4"},
            {"label": "US Dollar", "value": "5"},
            {"label": "US Dollar", "value": "6"},
            {"label": "US Dollar", "value": "7"},
            {"label": "Hong Kong Dollar", "value": "8"},
            {"label": "RMB", "value": "9"},
            {"label": "US Dollar", "value": "10"},
            {"label": "US Dollar", "value": "11"},
            {"label": "US Dollar", "value": "12"},
            {"label": "US Dollar", "value": "13"},
            {"label": "US Dollar", "value": "14"},
            {"label": "US Dollar", "value": "15"},
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
        title: Text("Selection Field Preview"),
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
              onFetchingSchema: null,
              onFetchingforeignKeyChoices: null,
              onAddforeignKeyField: null,
              onUpdateforeignKeyField: null,
              onDeleteforeignKeyField: null,
              useRadioButton: true,
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
