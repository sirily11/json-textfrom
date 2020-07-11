import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';
import 'package:json_schema_form/json_textform/models/components/Action.dart';
import 'package:json_schema_form/json_textform/models/components/Icon.dart';

import '../../JSONForm.dart';

class ManyToManySelectionPage extends StatefulWidget {
  final OnFileUpload onFileUpload;
  final OnUpdateForignKeyField onUpdateForignKeyField;
  final OnAddForignKeyField onAddForignKeyField;
  final OnFetchingSchema onFetchingSchema;
  final OnFetchForignKeyChoices onFetchingForignKeyChoices;
  final Schema schema;
  final String title;
  final bool isOutlined;

  /// Page's name
  /// This one is different from the title
  /// and will be used to merge actions and icons.
  final String name;

  /// List of actions. Each field will only have one action.
  /// If not, the last one will replace the first one.
  final List<FieldAction> actions;

  /// List of icons. Each field will only have one icon.
  /// If not, the last one will replace the first one.
  final List<FieldIcon> icons;

  /// Current selected value
  final List<Choice> value;

  ManyToManySelectionPage({
    @required this.title,
    this.isOutlined = false,
    this.value,
    @required this.onFetchingForignKeyChoices,
    @required this.onAddForignKeyField,
    @required this.onFetchingSchema,
    @required this.onUpdateForignKeyField,
    @required this.schema,
    @required this.actions,
    @required this.icons,
    @required this.name,
    @required this.onFileUpload,
  });

  @override
  _ManyToManySelectionPageState createState() =>
      _ManyToManySelectionPageState();
}

class _ManyToManySelectionPageState extends State<ManyToManySelectionPage> {
  String _filterText = "";
  List<Choice> selections = [];

  @override
  void initState() {
    super.initState();

    selections = (widget.value ?? [])
        .map((e) => e.toJson())
        .map((e) => Choice.fromJSON(e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          key: Key("Back"),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              Navigator.pop(context, selections);
            },
          )
        ],
      ),
      body: FutureBuilder<List<Choice>>(
          future: widget
              .onFetchingForignKeyChoices(widget.schema.extra.relatedModel),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            }

            List<Choice> choices = snapshot.data
                .where(
                  (element) => element.label.contains(_filterText),
                )
                .toList();

            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          key: Key("Filter"),
                          decoration: InputDecoration(labelText: "Search..."),
                          onChanged: (value) {
                            setState(() {
                              _filterText = value;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: choices.length,
                    itemBuilder: (ctx, index) {
                      Choice selection = choices[index];
                      bool checked = selections.contains(selection);
                      return CheckboxListTile(
                        key: Key("Checkbox-${selection.label}-$checked"),
                        title: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.edit),
                            ),
                            Text(selection.label),
                          ],
                        ),
                        value: checked,
                        onChanged: (checked) {
                          if (checked) {
                            selections.add(selection);
                          } else {
                            selections.remove(selection);
                          }

                          setState(() {
                            selections = selections;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}
