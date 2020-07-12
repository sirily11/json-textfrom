import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_schema_form/json_textform/JSONSchemaForm.dart';
import 'package:json_schema_form/json_textform/models/Controller.dart';

void main() {
  final today = DateTime.now();
  group("Test datetime field", () {
    final schema = [
      {
        "label": "created time",
        "readonly": false,
        "extra": {},
        "name": "created_time",
        "widget": "datetime",
        "required": false,
        "translated": false,
        "validations": {}
      }
    ];

    testWidgets(
      "Test 1",
      (WidgetTester tester) async {
        final controller = JSONSchemaController();
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: JSONSchemaForm(
                controller: controller,
                schema: schema,
                values: {
                  "created_time": DateTime(2016, 1, 5, 1).toIso8601String(),
                },
                onFetchingSchema: null,
                onFetchingforeignKeyChoices: null,
                onAddforeignKeyField: null,
                onUpdateforeignKeyField: null,
                onDeleteforeignKeyField: null,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text("2016-1-5"), findsOneWidget);
        await tester.tap(find.text("2016-1-5"));
        await tester.pumpAndSettle();
        await tester.tap(find.text("6"));
        await tester.tap(find.text("OK"));
        await tester.pumpAndSettle();
        expect(find.text("2016-1-6"), findsOneWidget);
        var value = await controller.onSubmit();
        expect(value['created_time'], DateTime(2016, 1, 6).toIso8601String());
      },
    );

    testWidgets(
      "Test 2",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: JSONSchemaForm(
                schema: schema,
                onFetchingSchema: null,
                onFetchingforeignKeyChoices: null,
                onAddforeignKeyField: null,
                onUpdateforeignKeyField: null,
                onDeleteforeignKeyField: null,
              ),
            ),
          ),
        );
        final todayStr = "${today.year}-${today.month}-${today.day}";
        await tester.pumpAndSettle();
        expect(find.text(todayStr), findsOneWidget);
        await tester.tap(find.text(todayStr));
        await tester.pumpAndSettle();
        await tester.tap(find.text("6"));
        await tester.tap(find.text("OK"));
        await tester.pumpAndSettle();
        expect(find.text("${today.year}-${today.month}-6"), findsOneWidget);
      },
    );
  });
}
