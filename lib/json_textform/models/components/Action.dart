import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';

import 'Icon.dart';

typedef Future<String> OnActionTap(Schema schema);

/// Actions type
enum ActionTypes { image, qrScan, custom }

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
  IconData icon;
  ActionTypes actionTypes;
  ActionDone actionDone;
  final OnDone<T> onDone;
  final OnActionTap onActionTap;
  @override
  String schemaName;

  @override
  String schemaFor;

  @override
  bool useGlobally;

  FieldAction({
    this.actionDone,
    @required this.actionTypes,
    this.schemaName,
    this.onDone,
    this.useGlobally = true,

    /// When this value is null,
    /// then the icon will be for the main schema and all its
    /// foreignkey schema's field;
    /// If this field is set, then only the related name's field will be set icon.
    this.schemaFor,

    /// Set this only if you use custom action
    this.onActionTap,

    /// Action icon. Set this field if you use
    /// custom action
    this.icon = Icons.search,
  });

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
