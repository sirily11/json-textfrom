import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/models/Action.dart';
import 'package:json_schema_form/json_textform/models/Icon.dart';

enum WidgetType {
  text,
  number,
  datetime,
  foreignkey,
  unknown,
  select,
  checkbox
}

class Schema {
  /// Text which will be displayed at screen
  String label;
  bool readOnly;

  /// Could be null
  Extra extra;

  /// Map's key
  String name;

  /// If widget type is not defined in the enum, then
  /// return widgetType.unknown
  WidgetType widget;
  bool isRequired;

  /// could be null
  Validation validation;

  /// this is value will be displayed at screen if set,
  /// else null
  dynamic value;

  /// Set this value only if the field includes selection
  Choice choice;

  /// icon for the field
  /// this will be set through the params of JSONForm widget
  FieldIcon icon;

  /// action for the field
  /// this will be set through the params of JSONForm widget
  FieldAction action;

  Schema(
      {this.label,
      this.readOnly,
      this.extra,
      this.name,
      this.widget,
      this.isRequired,
      this.validation,
      this.value,
      this.action,
      this.choice,
      this.icon});

  /// Convert from list of json objects
  static List<Schema> convertFromList(List<Map<String, dynamic>> jsonList) {
    return jsonList.map((l) => Schema.fromJSON(l)).toList();
  }

  static List<Schema> mergeValues(
      List<Schema> schemas, Map<String, dynamic> values) {
    return schemas.map((s) {
      // if values match
      if (values.containsKey(s.name)) {
        var value = values[s.name];
        // If the type is select
        if (s.widget == WidgetType.select) {
          Choice choice = s.extra?.choices
              ?.firstWhere((c) => c.value == value, orElse: null);
          s.choice = choice;
          s.value = value;
        } else if (s.widget == WidgetType.foreignkey) {
          try {
            Choice choice = Choice.fromJSON(value);
            s.choice = choice;
            s.value = choice.value;
          } catch (err) {
            print(err);
          }
        } else {
          s.value = value;
        }
      }
      return s;
    }).toList();
  }

  factory Schema.fromJSON(Map<String, dynamic> json) {
    WidgetType _widgetType = WidgetType.values.firstWhere(
        (e) => e.toString() == "WidgetType.${json['widget']}",
        orElse: () => WidgetType.unknown);

    return Schema(
      label: json['label'],
      readOnly: json['readonly'],
      extra: Extra.fromJSON(
        json['extra'],
      ),
      name: json['name'],
      widget: _widgetType,
      isRequired: json['required'],
      validation: Validation.fromJSON(json['validations']),
    );
  }

  /// call this function when submit
  Map<String, dynamic> onSubmit() {
    return {'key': this.name, 'value': this.value};
  }
}

class Extra {
  dynamic defaultValue;
  String helpText;
  List<Choice> choices;
  String relatedModel;
  Extra({this.defaultValue, this.helpText, this.choices, this.relatedModel});

  factory Extra.fromJSON(Map<dynamic, dynamic> json) {
    if (json == null) return null;
    List<Choice> choices =
        json['choices']?.map<Choice>((s) => Choice.fromJSON(s))?.toList();
    return Extra(
      defaultValue: json['default'],
      helpText: json['help'],
      relatedModel: json['related_model'],
      choices: choices,
    );
  }
}

class Validation {
  Length length;

  Validation({this.length});

  factory Validation.fromJSON(Map<dynamic, dynamic> json) {
    return Validation(
        length: json != null ? Length.fromJSON(json['length']) : null);
  }
}

class Length {
  int maximum;
  int minimum;

  Length({this.maximum, this.minimum});

  factory Length.fromJSON(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return Length(maximum: json['maximum'], minimum: json['minimum']);
  }
}

class Choice {
  String label;
  dynamic value;

  Choice({this.label, this.value});

  factory Choice.fromJSON(Map<dynamic, dynamic> json) {
    return Choice(label: json['label'], value: json['value']);
  }
}
