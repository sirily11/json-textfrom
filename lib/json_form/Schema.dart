enum WidgetType { text, number, datetime, foreignkey, unknown, select }

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

  Schema(
      {this.label,
      this.readOnly,
      this.extra,
      this.name,
      this.widget,
      this.isRequired,
      this.validation});

  /// Convert from list of json objects
  static List<Schema> convertFromList(List<Map<String, dynamic>> jsonList) {
    return jsonList.map((l) => Schema.fromJSON(l)).toList();
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
  Extra({this.defaultValue, this.helpText, this.choices});

  factory Extra.fromJSON(Map<dynamic, dynamic> json) {
    List<Choice> choices =
        json['choices']?.map<Choice>((s) => Choice.fromJSON(s))?.toList();
    return Extra(
        defaultValue: json['default'],
        helpText: json['help'],
        choices: choices);
  }
}

class Validation {
  Length length;

  Validation({this.length});

  factory Validation.fromJSON(Map<dynamic, dynamic> json) {
    return Validation(length: Length.fromJSON(json['length']));
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
