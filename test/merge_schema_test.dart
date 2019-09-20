import 'package:flutter_test/flutter_test.dart';
import 'package:json_textform/json_form/models/Action.dart';
import 'package:json_textform/json_form/models/Icon.dart';
import 'package:json_textform/json_form/models/Schema.dart';

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

    List<Schema> newSchema = FieldAction().merge(schemas, actions);
    expect(newSchema.length, 3);
    expect(newSchema[0].action, actions[0]);
  });

  test("Test with empty schema", () {
    List<Schema> schemas = [];
    List<FieldAction> actions = [];
    List<Schema> newSchema = FieldAction().merge(schemas, actions);
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

    List<Schema> newSchema = FieldAction().merge(schemas, actions);
    newSchema.forEach((s) => expect(s.action, null));
  });

  test("Test merge", () {
    List<Schema> schemas = [
      Schema(name: "a"),
      Schema(name: "b"),
      Schema(name: "c")
    ];
    List<FieldIcon> icons = [FieldIcon(schemaName: "a")];

    List<Schema> newSchema = FieldIcon().merge(schemas, icons);
    expect(newSchema.length, 3);
    expect(newSchema[0].icon, icons[0]);
  });

  test("Test with empty schema", () {
    List<Schema> schemas = [];
    List<FieldIcon> icons = [];
    List<Schema> newSchema = FieldIcon().merge(schemas, icons);
    expect(newSchema.length, 0);
  });

  test("Actions schema name doesn't match", () {
    List<Schema> schemas = [
      Schema(name: "a"),
      Schema(name: "b"),
      Schema(name: "c")
    ];
    List<FieldIcon> icons = [FieldIcon(schemaName: "d")];

    List<Schema> newSchema = FieldIcon().merge(schemas, icons);
    newSchema.forEach((s) => expect(s.action, null));
  });
}
