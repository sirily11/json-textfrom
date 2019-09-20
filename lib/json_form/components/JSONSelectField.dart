import 'package:flutter/material.dart';
import 'package:json_textform/json_form/Schema.dart';
import 'package:json_textform/json_form/components/JSONTextFormField.dart';
import 'package:json_textform/json_form/components/SelectionPage.dart';

class JSONSelectField extends JSONTextFormField {
  final Schema schema;
  final Function onSaved;
  final bool showIcon;
  final bool isOutlined;

  JSONSelectField(
      {@required this.schema,
      this.onSaved,
      this.showIcon = true,
      this.isOutlined = false})
      : super(
            schema: schema,
            onSaved: onSaved,
            showIcon: showIcon,
            isOutlined: isOutlined);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return SelectionPage(
                onSelected: (value) {
                  if (this.onSaved != null) {
                    this.onSaved(value);
                  }
                },
                title: "Select ${schema.name}",
                selections: schema.extra.choices,
                value: schema.value,
              );
            }));
          },
          title: Text("Select ${schema.name}"),
          subtitle: Text(schema.value ?? schema?.extra?.defaultValue ?? ""),
        ),
      ),
    );
  }
}
