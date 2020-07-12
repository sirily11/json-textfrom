import 'package:flutter/material.dart';
import 'package:json_schema_form/json_schema_form.dart';
import 'package:json_schema_form/json_textform/JSONSchemaForm.dart';
import 'package:json_schema_form_example/menubutton/MenuButton.dart';
import 'package:json_schema_form_example/model/HomeProvider.dart';
import 'package:provider/provider.dart';

class TextFieldDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final schema = [
      {
        "label": "description",
        "readonly": false,
        "extra": {"help": "Please enter your item description"},
        "name": "description",
        "widget": "text",
        "required": true,
        "translated": false,
        "validations": {
          "length": {"maximum": 1024}
        }
      },
      {
        "label": "price",
        "readonly": false,
        "extra": {"default": 0.0},
        "name": "price",
        "widget": "number",
        "required": true,
        "translated": false,
        "validations": {}
      },
    ];

    HomeProvider homeProvider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("TextField Preview"),
      ),
      body: Stack(
        children: <Widget>[
          JSONSchemaForm(
            schema: schema,
            showSubmitButton: homeProvider.showSubmitButton,
            filled: homeProvider.isFilled,
            rounded: homeProvider.isRounded,
            onFetchingSchema: null,
            onFetchingforeignKeyChoices: null,
            onAddforeignKeyField: null,
            onUpdateforeignKeyField: null,
            onDeleteforeignKeyField: null,
            icons: [
              FieldIcon(
                iconData: Icons.title,
                schemaName: "description",
              ),
            ],
            values: {
              "description": "Hello world",
            },
          ),
          MenuButton(),
        ],
      ),
    );
  }
}
