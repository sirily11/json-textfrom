import 'package:flutter/material.dart';
import 'package:json_textform/json_form/models/Action.dart';
import 'package:json_textform/json_form/models/Icon.dart';
import 'package:json_textform/json_form/models/Schema.dart';
import 'package:json_textform/json_form/components/JSONForignKeyField.dart';
import 'package:json_textform/json_form/components/JSONSelectField.dart';
import 'package:json_textform/json_form/components/JSONTextFormField.dart';

class JSONSchemaForm extends StatefulWidget {
  final List<Map<String, dynamic>> schema;
  final List<FieldAction> actions;
  final List<FieldIcon> icons;
  final Function onSubmit;
  JSONSchemaForm(
      {@required this.schema, this.onSubmit, this.icons, this.actions});

  @override
  _JSONSchemaFormState createState() => _JSONSchemaFormState();
}

class _JSONSchemaFormState extends State<JSONSchemaForm> {
  final _formKey = GlobalKey<FormState>();

  List<Schema> schemaList = [];
  Function onSubmit;
  _JSONSchemaFormState();

  @override
  void initState() {
    super.initState();
    schemaList = Schema.convertFromList(widget.schema);
    if (widget.actions != null) {
      schemaList = FieldAction().merge(schemaList, widget.actions);
    }
    if (widget.icons != null) {
      schemaList = FieldIcon().merge(schemaList, widget.icons);
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
                            if (this.onSubmit != null) {
                              await this.onSubmit(ret);
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
