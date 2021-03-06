import 'package:flutter/material.dart';
import 'package:json_schema_form/json_schema_form.dart';
import 'package:json_schema_form/json_textform/JSONSchemaForm.dart';
import 'package:json_schema_form_example/data/sample_data.dart';
import 'package:json_schema_form_example/menubutton/MenuButton.dart';
import 'package:json_schema_form_example/model/HomeProvider.dart';
import 'package:provider/provider.dart';

class CompleteDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("TextField List View Preview"),
      ),
      body: Stack(
        children: <Widget>[
          JSONSchemaForm(
            schema: itemJSONData['fields'],
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
