import 'package:json_schema_form/json_textform/models/components/Action.dart';
import 'package:json_schema_form/json_textform/models/components/FileFieldValue.dart';
import 'components/AvaliableWidgetTypes.dart';
import 'components/Icon.dart';

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

  /// List of choices. Set this value only if you are using many to many field;
  List<Choice> choices;

  /// icon for the field
  /// this will be set through the params of JSONForm widget
  FieldIcon icon;

  /// action for the field
  /// this will be set through the params of JSONForm widget
  FieldAction action;

  Schema({
    this.label,
    this.readOnly,
    this.extra,
    this.name,
    this.widget,
    this.isRequired,
    this.validation,
    this.value,
    this.action,
    this.choice,
    this.icon,
    this.choices = const [],
  });

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
        if (s.value != null) {
          return s;
        }

        switch (s.widget) {
          case WidgetType.select:
            Choice choice = s.extra?.choices?.firstWhere(
              (c) => c.value == value,
              orElse: () => null,
            );
            s.choice = choice;
            s.value = value;
            break;
          case WidgetType.foreignkey:
            try {
              Choice choice = Choice.fromJSON(value);
              s.choice = choice;
              s.value = choice.value;
            } catch (err) {
              print(err);
            }
            break;
          case WidgetType.manytomanyLists:
            if (value is List) {
              List<Choice> choices = value
                  .map(
                    (e) => Choice.fromJSON(e),
                  )
                  .toList();
              s.choices = choices;
              s.value = choices.map((e) => e.value).toList();
            }
            break;

          case WidgetType.text:
          case WidgetType.number:
          case WidgetType.datetime:
          case WidgetType.unknown:
          case WidgetType.checkbox:
          case WidgetType.file:
            s.value = value;
            break;
        }
      }
      return s;
    }).toList();
  }

  factory Schema.fromJSON(Map<String, dynamic> json) {
    WidgetType _widgetType;
    if (json['widget'] == "manytomany-lists") {
      _widgetType = WidgetType.manytomanyLists;
    } else {
      _widgetType = WidgetType.values.firstWhere(
          (e) => e.toString() == "WidgetType.${json['widget']}",
          orElse: () => WidgetType.unknown);
    }

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

  /// call this function when submit. Will return null sometimes
  Map<String, dynamic> onSubmit() {
    if (value is FileFieldValue) {
      if (!(value as FileFieldValue).hasUpdated) {
        return null;
      } else {
        return {'key': this.name, 'value': (value as FileFieldValue).value};
      }
    }

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

  bool operator ==(o) => o is Choice && o.label == label && o.value == value;

  factory Choice.fromJSON(Map<dynamic, dynamic> json) {
    return Choice(label: json['label'], value: json['value']);
  }

  toJson() {
    return {
      "label": label,
      "value": value,
    };
  }

  @override
  int get hashCode => super.hashCode;
}
