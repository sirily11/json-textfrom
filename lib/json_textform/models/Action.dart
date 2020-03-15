import 'dart:io';

import 'package:json_schema_form/json_textform/models/Icon.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';


/// Actions type
enum ActionTypes { image, qrScan }

/// Actions when the action is finished
enum ActionDone {
  /// get input from the action
  /// And use the input to fill the field
  getInput,

  /// get image from the action
  /// and use the image to fill the field
  getImage,
}

typedef OnDone<T> = Future<dynamic> Function(T value);

/// Field Action class for each json field
class FieldAction<T> implements Field<FieldAction> {
  ActionTypes actionTypes;
  ActionDone actionDone;
  final OnDone<T> onDone;
  @override
  String schemaName;

  @override
  String schemaFor;

  @override
  bool useGlobally;

  FieldAction(
      {this.actionDone,
      this.actionTypes,
      this.schemaName,
      this.onDone,
      this.useGlobally = true,
      this.schemaFor});

  @override
  List<Schema> merge(
      List<Schema> schemas, List<FieldAction> fields, String name) {
    return schemas.map((s) {
      fields.forEach((f) {
        if (f.schemaName == s.name) {
          if ((f.schemaFor == null && f.useGlobally) || f.schemaFor == name) {
            s.action = f;
          } else if ((!f.useGlobally && f.schemaFor == null) &&
              f.schemaFor == null) {
            s.action = f;
          }
        }
      });
      return s;
    }).toList();
  }
}
