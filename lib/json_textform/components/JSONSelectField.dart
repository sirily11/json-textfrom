import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/components/SelectionPage.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';


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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
      child: Container(
        decoration: isOutlined
            ? BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).inputDecorationTheme.fillColor)
            : null,
        child: ListTile(
          key: Key("selection-field"),
          leading: schema.icon != null
              ? Icon(
                  schema.icon.iconData,
                  color: Theme.of(context).iconTheme.color,
                )
              : null,
          trailing:
              Icon(Icons.expand_more, color: Theme.of(context).iconTheme.color),
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
                          title: "Select ${schema.label}",
                          selections: schema.extra.choices,
                          value: schema.value ?? schema.extra.defaultValue,
                        );
                      },
                    ),
                  );
                },
          title: Text("Select ${schema.label}"),
          subtitle: Text(schema.value ?? schema?.extra?.defaultValue ?? ""),
        ),
      ),
    );
  }
}
