import 'package:flutter/material.dart';
import 'package:json_textform/json_form/Schema.dart';
import 'package:json_textform/json_form/components/JSONTextFormField.dart';

class JSONSchemaForm extends StatefulWidget {
  final List<Map<String, dynamic>> schema;
  final Function onSubmit;
  JSONSchemaForm({@required this.schema, this.onSubmit});

  @override
  _JSONSchemaFormState createState() =>
      _JSONSchemaFormState(uiSchema: this.schema, onSubmit: this.onSubmit);
}

class _JSONSchemaFormState extends State<JSONSchemaForm> {
  final List<Map<String, dynamic>> uiSchema;
  final _formKey = GlobalKey<FormState>();

  List<Schema> schemaList = [];
  Function onSubmit;
  _JSONSchemaFormState({@required this.uiSchema, this.onSubmit});

  @override
  void initState() {
    super.initState();
    schemaList = Schema.convertFromList(uiSchema);
  }

  Widget _buildBody(Schema schema) {
    switch (schema.widget) {
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
                  itemCount: uiSchema.length,
                  itemBuilder: (BuildContext context, int index) {
                    Schema schema = schemaList[index];

                    return schema.readOnly ? Container() : _buildBody(schema);
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
