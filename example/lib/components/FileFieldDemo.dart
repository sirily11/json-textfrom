import 'package:flutter/material.dart';
import 'package:json_schema_form/json_schema_form.dart';
import 'package:json_schema_form/json_textform/JSONSchemaForm.dart';
import 'package:json_schema_form/json_textform/models/components/Icon.dart';
import 'package:json_schema_form_example/menubutton/MenuButton.dart';
import 'package:json_schema_form_example/model/HomeProvider.dart';
import 'package:provider/provider.dart';

class FileFieldDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final schema = [
      {
        "label": "cover",
        "readonly": false,
        "extra": {},
        "name": "cover",
        "widget": "file",
        "required": false,
        "translated": false,
        "validations": {
          "length": {"maximum": 100}
        }
      },
    ];

    HomeProvider homeProvider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("CheckBox Preview"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
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
              values: {
                "cover": FileFieldValue(path: "https://s3.amazon.com/test.jpg"),
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
