import 'package:flutter/material.dart';
import 'package:json_schema_form/components/JSONForignKeyField.dart';
import 'package:json_schema_form/components/JSONSelectField.dart';
import 'package:json_schema_form/components/JSONTextFormField.dart';
import 'package:json_schema_form/models/Action.dart';
import 'package:json_schema_form/models/Icon.dart';
import 'package:json_schema_form/models/Schema.dart';
import 'package:permission_handler/permission_handler.dart';

typedef Future OnSubmit(Map<String, dynamic> json);

/// A JSON Schema Form Widget
/// Which will take a schema input
/// and generate a form
class JSONSchemaForm extends StatefulWidget {
  /// Schema you want to have. This is a JSON object
  /// Using dart's map data structure
  final List<Map<String, dynamic>> schema;

  /// List of actions. Each field will only have one action.
  /// If not, the last one will replace the first one.
  final List<FieldAction> actions;

  /// List of icons. Each field will only have one icon.
  /// If not, the last one will replace the first one.
  final List<FieldIcon> icons;

  /// Default values for each field
  final Map<String, dynamic> values;

  /// Will call this function after user
  /// clicked the submit button
  final OnSubmit onSubmit;

  /// Round corner of text field
  final bool rounded;
  JSONSchemaForm({
    @required this.schema,
    this.onSubmit,
    this.icons,
    this.actions,
    this.values,
    this.rounded = false,
  });

  @override
  _JSONSchemaFormState createState() => _JSONSchemaFormState();
}

class _JSONSchemaFormState extends State<JSONSchemaForm> {
  final _formKey = GlobalKey<FormState>();
  List<Schema> schemaList = [];
  _JSONSchemaFormState();

  @override
  void initState() {
    super.initState();
    schemaList = Schema.convertFromList(widget.schema);

    /// Merge actions
    if (widget.actions != null) {
      PermissionHandler()
          .requestPermissions([PermissionGroup.camera]).then((m) => null);
      schemaList = FieldAction().merge(schemaList, widget.actions);
    }

    /// Merge icons
    if (widget.icons != null) {
      schemaList = FieldIcon().merge(schemaList, widget.icons);
    }

    /// Merge values
    if (widget.values != null) {
      schemaList = Schema.mergeValues(schemaList, widget.values);
    }
  }

  /// Render body widget based on widget type
  Widget _buildBody(Schema schema) {
    switch (schema.widget) {
      case (WidgetType.select):
        return JSONSelectField(
          isOutlined: widget.rounded,
          schema: schema,
          onSaved: (Choice value) {
            setState(() {
              schema.value = value.value;
              schema.choice = value;
            });
          },
        );

      case (WidgetType.foreignkey):
        return JSONForignKeyField(
          isOutlined: widget.rounded,
          schema: schema,
          onSaved: (Choice value) {
            setState(() {
              schema.value = value.value;
              schema.choice = value;
            });
          },
        );

      default:
        return JSONTextFormField(
          schema: schema,
          isOutlined: widget.rounded,
          onSaved: (String value) {
            schema.value = value;
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height - 200,
                child: ListView.builder(
                  itemCount: widget.schema.length,
                  itemBuilder: (BuildContext context, int index) {
                    Schema schema = schemaList[index];
                    return schema.readOnly ||
                            schema.widget == WidgetType.unknown
                        ? Container()
                        : _buildBody(schema);
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: 300,
                      height: 40,
                      child: RaisedButton(
                        color: Theme.of(context).buttonColor,
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .title
                                  .color),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            // hide keyboard
                            FocusScope.of(context).requestFocus(FocusNode());
                            List<Map<String, dynamic>> json = schemaList
                                .where((s) => !s.readOnly)
                                .map((schema) => schema.onSubmit())
                                .toList();
                            Map<String, dynamic> ret = Map.fromIterables(
                                json.map((j) => j['key'] as String).toList(),
                                json.map((j) => j['value']).toList());
                            // call on submit function
                            if (widget.onSubmit != null) {
                              await widget.onSubmit(ret);
                            }
                            // clear the content
                            _formKey.currentState.reset();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
