import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_schema_form/json_textform/JSONSchemaForm.dart';
import 'package:json_schema_form/json_textform/models/Controller.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';

void main() {
  group("Test Selection Field", () {
    final doneButtonFinder = find.byIcon(Icons.done);
    final backbuttonFinder = find.byKey(Key("Back"));
    final dropdownButtonFinder = find.byKey(Key("Dropdown"));

    final schema = [
      {
        "label": "unit",
        "readonly": false,
        "extra": {
          "choices": [
            {"label": "A", "value": "USD"},
            {"label": "B", "value": "HKD"},
            {"label": "C", "value": "CNY"}
          ],
          "default": "USD"
        },
        "name": "unit",
        "widget": "select",
        "required": false,
        "translated": false,
        "validations": {}
      },
    ];

    testWidgets(
      "Test Select",
      (WidgetTester tester) async {
        // default value
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: JSONSchemaForm(
                schema: schema,
                onFetchingSchema: null,
                onFetchingForignKeyChoices: null,
                onAddForignKeyField: null,
                onUpdateForignKeyField: null,
                onDeleteForignKeyField: null,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text("Select unit"), findsOneWidget);
        await tester.tap(find.text("Select unit"));
        await tester.pumpAndSettle();
        expect(find.byKey(Key("A-true")), findsOneWidget);
        expect(find.byKey(Key("B-false")), findsOneWidget);
        expect(find.byKey(Key("C-false")), findsOneWidget);
        await tester.tap(find.byKey(Key("B-false")));
        await tester.pumpAndSettle();
        expect(find.byKey(Key("A-false")), findsOneWidget);
        expect(find.byKey(Key("B-true")), findsOneWidget);
        expect(find.byKey(Key("C-false")), findsOneWidget);
        await tester.tap(doneButtonFinder);
        await tester.pumpAndSettle();
        expect(find.text("HKD"), findsOneWidget);
      },
    );

    testWidgets(
      "Test Select 2",
      (WidgetTester tester) async {
        // dropdown
        final controller = JSONSchemaController();
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: JSONSchemaForm(
                controller: controller,
                useDropdownButton: true,
                schema: schema,
                onFetchingSchema: null,
                onFetchingForignKeyChoices: null,
                onAddForignKeyField: null,
                onDeleteForignKeyField: null,
                onUpdateForignKeyField: null,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text("Select unit"), findsOneWidget);
        await tester.tap(dropdownButtonFinder);
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(Key("Dropdown-B")).last);
        await tester.pumpAndSettle();
        var result = await controller.onSubmit();
        expect(result['unit'], "HKD");
      },
    );
  });
}
