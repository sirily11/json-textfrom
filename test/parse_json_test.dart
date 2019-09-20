import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:json_textform/json_form/Schema.dart';

void main() {
  test("Parse JSON", () {
    var testData = {
      "label": "ID",
      "readonly": true,
      "extra": {"default": 1},
      "name": "id",
      "widget": "number",
      "required": false,
      "translated": false,
      "validations": {}
    };
    Schema s = Schema.fromJSON(testData);
    expect(s.label, "ID");
    expect(s.readOnly, true);
    expect(s.widget, WidgetType.number);
    expect(s.extra.defaultValue, 1);
  });

  test("Parse JSON 2", () {
    var testData = {
      "label": "ID",
      "readonly": true,
      "extra": {},
      "name": "id",
      "widget": "email",
      "required": false,
      "translated": false,
      "validations": {}
    };
    Schema s = Schema.fromJSON(testData);
    expect(s.label, "ID");
    expect(s.readOnly, true);
    expect(s.widget, WidgetType.unknown);
    expect(s.value, null);
  });

  test("Parse JSON 3", () {
    var testData = {
      "label": "ID",
      "readonly": true,
      "extra": {},
      "name": "id",
      "widget": "email",
      "required": false,
      "translated": false,
      "validations": {
        "length": {"maximum": 1000}
      }
    };
    Schema s = Schema.fromJSON(testData);
    expect(s.label, "ID");
    expect(s.readOnly, true);
    expect(s.widget, WidgetType.unknown);
    expect(s.value, null);
    expect(s.validation.length.maximum, 1000);
  });

  test("Parse list of JSON", () {
    var testData = [
      {
        "label": "ID",
        "readonly": true,
        "extra": {},
        "name": "id",
        "widget": "number",
        "required": false,
        "translated": false,
        "validations": {}
      },
      {
        "label": "ID",
        "readonly": true,
        "extra": {},
        "name": "id",
        "widget": "email",
        "required": false,
        "translated": false,
        "validations": {}
      }
    ];
    List<Schema> ss = Schema.convertFromList(testData);
    Schema s = ss[0];
    expect(s.label, "ID");
    expect(s.readOnly, true);
    expect(s.widget, WidgetType.number);
    expect(s.value, null);
  });

  test("Parse with choices", () {
    var data = {
      "label": "unit",
      "readonly": false,
      "extra": {
        "choices": [
          {"label": "美元", "value": "USD"},
          {"label": "港币", "value": "HDK"},
          {"label": "人民币", "value": "CNY"}
        ],
        "default": "USD"
      },
      "name": "unit",
      "widget": "select",
      "required": false,
      "translated": false,
      "validations": {}
    };
    Schema s = Schema.fromJSON(data);
    expect(s.extra.choices.length, 3);
    expect(s.extra.choices[0].label, "美元");
    expect(s.extra.choices[0].value, "USD");
  });
}
