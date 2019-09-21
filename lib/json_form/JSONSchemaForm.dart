import 'package:flutter/material.dart';
import 'package:json_textform/json_form/models/Action.dart';
import 'package:json_textform/json_form/models/Icon.dart';
import 'package:json_textform/json_form/models/Schema.dart';
import 'package:json_textform/json_form/components/JSONForignKeyField.dart';
import 'package:json_textform/json_form/components/JSONSelectField.dart';
import 'package:json_textform/json_form/components/JSONTextFormField.dart';
import 'package:permission_handler/permission_handler.dart';

typedef Future OnSubmit(Map<String, dynamic> json);

class JSONSchemaForm extends StatefulWidget {
  final List<Map<String, dynamic>> schema;
  final List<FieldAction> actions;
  final List<FieldIcon> icons;

  /// Default values
  final Map<String, dynamic> values;
  final OnSubmit onSubmit;
  JSONSchemaForm(
      {@required this.schema,
      this.onSubmit,
      this.icons,
      this.actions,
      this.values});

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
      schemaList = schemaList.map((s) {
        if (widget.values.containsKey(s.name)) {
          s.value = widget.values[s.name];
        }
        return s;
      }).toList();
    }
  }

  /// Render body widget based on widget type
  Widget _buildBody(Schema schema) {
    switch (schema.widget) {
      case (WidgetType.select):
        return JSONSelectField(
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
                        color: Colors.blue,
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            // hide keyboard
                            FocusScope.of(context).requestFocus(FocusNode());
                            List<Map<String, dynamic>> json = schemaList
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
