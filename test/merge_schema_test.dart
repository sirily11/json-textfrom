import 'package:flutter_test/flutter_test.dart';
import 'package:json_schema_form/json_textform/models/Action.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';
import 'package:json_schema_form/json_textform/models/Icon.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';

void main() {
  test("Test merge", () {
    List<Schema> schemas = [
      Schema(name: "a"),
      Schema(name: "b"),
      Schema(name: "c")
    ];
    List<FieldAction> actions = [
      FieldAction(
          schemaName: "a",
          actionTypes: ActionTypes.qrScan,
          actionDone: ActionDone.getInput)
    ];

    List<Schema> newSchema = FieldAction().merge(schemas, actions, null);
    expect(newSchema.length, 3);
    expect(newSchema[0].action, actions[0]);
  });

  test("Test with empty schema", () {
    List<Schema> schemas = [];
    List<FieldAction> actions = [];
    List<Schema> newSchema = FieldAction().merge(schemas, actions, null);
    expect(newSchema.length, 0);
  });

  test("Actions schema name doesn't match", () {
    List<Schema> schemas = [
      Schema(name: "a"),
      Schema(name: "b"),
      Schema(name: "c")
    ];
    List<FieldAction> actions = [
      FieldAction(
          schemaName: "d",
          actionTypes: ActionTypes.qrScan,
          actionDone: ActionDone.getInput)
    ];

    List<Schema> newSchema = FieldAction().merge(schemas, actions, null);
    newSchema.forEach((s) => expect(s.action, null));
  });

  test("Test merge", () {
    List<Schema> schemas = [
      Schema(name: "a"),
      Schema(name: "b"),
      Schema(name: "c")
    ];
    List<FieldIcon> icons = [FieldIcon(schemaName: "a")];

    List<Schema> newSchema = FieldIcon().merge(schemas, icons, null);
    expect(newSchema.length, 3);
    expect(newSchema[0].icon, icons[0]);
  });

  test("Test with empty schema", () {
    List<Schema> schemas = [];
    List<FieldIcon> icons = [];
    List<Schema> newSchema = FieldIcon().merge(schemas, icons, null);
    expect(newSchema.length, 0);
  });

  test("Actions schema name doesn't match", () {
    List<Schema> schemas = [
      Schema(name: "a"),
      Schema(name: "b"),
      Schema(name: "c")
    ];
    List<FieldIcon> icons = [FieldIcon(schemaName: "d")];

    List<Schema> newSchema = FieldIcon().merge(schemas, icons, null);
    newSchema.forEach((s) => expect(s.action, null));
  });

  test("Merge values", () {
    List<Schema> schemas = [
      Schema(name: "a"),
      Schema(name: "b"),
      Schema(name: "c")
    ];

    Map<String, dynamic> values = {"a": 123};

    List<Schema> newSchemas = Schema.mergeValues(schemas, values);
    expect(newSchemas.length, 3);
    expect(newSchemas[0].value, 123);
  });

  test("Merge values without matches", () {
    List<Schema> schemas = [
      Schema(name: "a"),
      Schema(name: "b"),
      Schema(name: "c")
    ];

    Map<String, dynamic> values = {"d": 123};

    List<Schema> newSchemas = Schema.mergeValues(schemas, values);
    expect(newSchemas.length, 3);
    newSchemas.forEach((s) => expect(s.value, null));
  });

  test("Empty merge", () {
    List<Schema> schemas = [];
    Map<String, dynamic> values = {};

    List<Schema> newSchemas = Schema.mergeValues(schemas, values);
    expect(newSchemas.length, 0);
  });

  test("Merge values which is a selection", () {
    List<Schema> schemas = [
      Schema(
          name: "a",
          widget: WidgetType.select,
          extra: Extra(choices: [
            Choice(label: "abc", value: 123),
            Choice(label: "cde", value: 345)
          ])),
      Schema(name: "b"),
      Schema(name: "c")
    ];

    Map<String, dynamic> values = {"a": 123};

    List<Schema> newSchemas = Schema.mergeValues(schemas, values);
    expect(newSchemas.length, 3);
    expect(newSchemas[0].value, 123);
    expect(newSchemas[0].choice.value, 123);
    expect(newSchemas[0].choice.label, "abc");
  });

  test("Merge values which is a forignkey", () {
    List<Schema> schemas = [
      Schema(
        name: "a",
        widget: WidgetType.foreignkey,
      ),
      Schema(name: "b"),
      Schema(name: "c")
    ];

    Map<String, dynamic> values = {
      "a": {"label": "abc", "value": 123}
    };

    List<Schema> newSchemas = Schema.mergeValues(schemas, values);
    expect(newSchemas.length, 3);
    expect(newSchemas[0].value, 123);
    expect(newSchemas[0].choice.value, 123);
    expect(newSchemas[0].choice.label, "abc");
  });

  test("icons and forignkey and main schema has same name", () {
    List<Schema> schemas = [
      Schema(name: "a"),
      Schema(name: "b"),
      Schema(name: "c")
    ];
    List<FieldIcon> icons = [FieldIcon(schemaName: "a", schemaFor: "abc")];

    List<Schema> newSchema = FieldIcon().merge(schemas, icons, null);
    newSchema.forEach((s) => expect(s.icon, null));
  });

  test("icons and forignkey and main schema has same name", () {
    List<Schema> schemas = [
      Schema(name: "a"),
      Schema(name: "b"),
      Schema(name: "c")
    ];
    List<FieldIcon> icons = [FieldIcon(schemaName: "a", schemaFor: "abc")];

    List<Schema> newSchema = FieldIcon().merge(schemas, icons, "abc");
    expect(newSchema[0].icon, icons.first);
  });
}
