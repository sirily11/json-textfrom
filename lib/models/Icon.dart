import 'package:flutter/cupertino.dart';
import 'package:json_schema_form/models/Schema.dart';


abstract class Field<T> {
  /// This should match the schema's name
  String schemaName;

  /// Merge with schema
  List<Schema> merge(List<Schema> schemas, List<T> fields);
}

class FieldIcon implements Field<FieldIcon> {
  IconData iconData;

  @override
  String schemaName;

  FieldIcon({this.iconData, this.schemaName});

  @override
  List<Schema> merge(List<Schema> schemas, List<FieldIcon> fields) {
    return schemas.map((s) {
      fields.forEach((f) {
        if (f.schemaName == s.name) {
          s.icon = f;
        }
      });
      return s;
    }).toList();
  }
}
