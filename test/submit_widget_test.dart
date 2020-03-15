import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_schema_form/json_textform/JSONSchemaForm.dart';

void main() {
  group("Submit widget test", () {
    testWidgets("Textfield submition test", (WidgetTester tester) async {
      // Required schema
      var schema = [
        {
          "label": "Item Name",
          "readonly": false,
          "extra": {"help": "Please Enter your item name"},
          "name": "name",
          "widget": "text",
          "required": true,
          "translated": false,
          "validations": {
            "length": {"maximum": 1024}
          }
        }
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
              child: JSONSchemaForm(
            schema: schema,
            onSubmit: (value) {},
          )),
        ),
      );
      // if the field is required
      // and no value has been provided
      // show error message
      await tester.tap(find.byType(RaisedButton));
      await tester.pump();
      expect(find.text("This field is required"), findsOneWidget);
    });

    testWidgets("Textfield number submition test", (WidgetTester tester) async {
      // Required schema
      var schema = [
        {
          "label": "Item Name",
          "readonly": false,
          "extra": {"help": "Please Enter your item name"},
          "name": "name",
          "widget": "number",
          "required": true,
          "translated": false,
          "validations": {
            "length": {"maximum": 1024}
          }
        }
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
              child: JSONSchemaForm(
            schema: schema,
            values: {"name": "abc"},
            onSubmit: (value) {},
          )),
        ),
      );
      // if the widget is type of number
      // and a string value has been provided
      // show error message
      await tester.tap(find.byType(RaisedButton));
      await tester.pump();
      expect(find.text('abc is not a valid number'), findsOneWidget);
    });

    testWidgets("Textfield enter submition test", (WidgetTester tester) async {
      // Required schema
      var schema = [
        {
          "label": "Item Name",
          "readonly": false,
          "extra": {"help": "Please Enter your item name"},
          "name": "name",
          "widget": "number",
          "required": true,
          "translated": false,
          "validations": {
            "length": {"maximum": 1024}
          }
        }
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
              child: JSONSchemaForm(
            schema: schema,
            onSubmit: (value) async {
              print(value);
            },
          )),
        ),
      );
      // if the widget is type of number
      // and a string value has been provided
      // show error message
      await tester.enterText(find.byType(TextField), "abc");
      await tester.pump();
      expect(find.text('abc'), findsOneWidget);
      await tester.tap(find.byType(RaisedButton));
      await tester.pump();
    });

    testWidgets("Textfield default value submition test",
        (WidgetTester tester) async {
      // submit with default value
      var schema = [
        {
          "label": "Item Name",
          "readonly": false,
          "extra": {"help": "Please Enter your item name", "default": "abc"},
          "name": "name",
          "widget": "number",
          "required": true,
          "translated": false,
          "validations": {
            "length": {"maximum": 1024}
          }
        }
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
              child: JSONSchemaForm(
            schema: schema,
          )),
        ),
      );
      expect(find.text("abc"), findsOneWidget);
      await tester.tap(find.byType(RaisedButton));
      await tester.pump();
    });

    testWidgets("Selection submition test", (WidgetTester tester) async {
      // submit with default value
      var schema = [
        {
          "label": "Item unit",
          "readonly": false,
          "extra": {"default": "USD"},
          "name": "unit",
          "widget": "select",
          "required": true,
          "translated": false,
          "validations": {
            "length": {"maximum": 1024}
          }
        }
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
              child: JSONSchemaForm(
            schema: schema,
          )),
        ),
      );
      expect(find.text("USD"), findsOneWidget);
      await tester.tap(find.byType(RaisedButton));
    });

    testWidgets("Selection submition test", (WidgetTester tester) async {
      // submit with value
      var schema = [
        {
          "label": "Item unit",
          "readonly": false,
          "name": "unit",
          "widget": "select",
          "required": true,
          "extra": {
            "choices": [
              {"label": "美元", "value": "USD"},
              {"label": "港币", "value": "HDK"},
              {"label": "人民币", "value": "CNY"}
            ]
          },
          "translated": false,
          "validations": {
            "length": {"maximum": 1024}
          }
        }
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
              child: JSONSchemaForm(
            schema: schema,
            values: {"unit": "USD"},
          )),
        ),
      );
      expect(find.text("USD"), findsOneWidget);
      await tester.tap(find.byType(RaisedButton));
    });
  });
}
