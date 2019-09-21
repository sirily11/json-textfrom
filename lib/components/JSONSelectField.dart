import 'package:flutter/material.dart';
import 'package:json_schema_form/components/SelectionPage.dart';
import 'package:json_schema_form/models/Schema.dart';


class JSONSelectField extends StatelessWidget {
  final Schema schema;
  final Function onSaved;
  final bool showIcon;
  final bool isOutlined;

  JSONSelectField(
      {@required this.schema,
      this.onSaved,
      this.showIcon = true,
      this.isOutlined = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
        child: ListTile(
          key: Key("selection-field"),
          leading: schema.icon != null ? Icon(schema.icon.iconData) : null,
          trailing: Icon(Icons.expand_more),
          onTap: schema?.extra?.choices == null
              ? null
              : () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) {
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
                      },
                    ),
                  );
                },
          title: Text("Select ${schema.name}"),
          subtitle: Text(schema.value ?? schema?.extra?.defaultValue ?? ""),
        ),
      ),
    );
  }
}
