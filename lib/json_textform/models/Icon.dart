import 'package:flutter/cupertino.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';

abstract class Field<T> {
  /// This should match the schema's name
  String schemaName;

  /// When this value is null,
  /// then the icon will be for the main schema and all its
  /// forignkey schema's field;
  /// If this field is set, then only the related name's field will be set icon.
  String schemaFor;

  /// If this is true and schemaFor is null, then use the icon/action globally,
  /// otherwise, only main screen will use the icon/action
  bool useGlobally;

  /// Merge with schema
  List<Schema> merge(List<Schema> schemas, List<T> fields, String name);
}

class FieldIcon implements Field<FieldIcon> {
  IconData iconData;

  @override
  String schemaName;

  @override
  String schemaFor;

  @override
  bool useGlobally;

  FieldIcon(
      {this.iconData,
      this.schemaName,
      this.schemaFor,
      this.useGlobally = true});

  @override
  List<Schema> merge(
      List<Schema> schemas, List<FieldIcon> fields, String name) {
    return schemas.map((s) {
      fields.forEach((f) {
        if (f.schemaName == s.name) {
          if ((f.schemaFor == null && f.useGlobally) || f.schemaFor == name) {
            s.icon = f;
          } else if ((!f.useGlobally && f.schemaFor == null) &&
              f.schemaFor == null) {
            s.icon = f;
          }
        }
      });
      return s;
    }).toList();
  }
}
