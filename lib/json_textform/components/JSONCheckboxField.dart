import 'package:flutter/material.dart';
import '../models/Schema.dart';

typedef void OnChange(bool value);

class JSONCheckboxField extends StatelessWidget {
  final Schema schema;
  final OnChange onSaved;
  final bool showIcon;
  final bool isOutlined;

  JSONCheckboxField({
    @required this.schema,
    this.onSaved,
    this.showIcon = true,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: schema.value ?? schema?.extra?.defaultValue ?? false,
      onChanged: (v) {
        onSaved(v);
      },
      title: Text("${schema.label}"),
      subtitle: Text("${schema?.extra?.helpText ?? ""}"),
    );
  }
}
