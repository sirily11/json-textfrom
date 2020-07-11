import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:json_schema_form/json_schema_form.dart';

void main() {
  group("Test file field value", () {
    var file = File("b.jpg");
    test("Test 1", () {
      var value = FileFieldValue(path: "a.jpg");
      value.clearOld();
      expect(value.file, null);
      expect(value.path, "a.jpg");
      expect(value.hasUpdated, true);
      expect(value.willClear, true);
      expect(value.value, null);
      expect(value.toString(), "a.jpg");
    });

    test("Test 2", () {
      var value = FileFieldValue(path: "a.jpg");
      value.file = file;
      value.clearOld();
      expect(value.file, file);
      expect(value.path, "a.jpg");
      expect(value.hasUpdated, true);
      expect(value.willClear, true);
      expect(value.toString(), "b.jpg");
      value.clearNew();
      expect(value.file, null);
      expect(value.hasUpdated, true);
      expect(value.willClear, true);
      expect(value.value, null);
      value.restoreOld();
      expect(value.hasUpdated, false);
      expect(value.toString(), "a.jpg");
    });

    test("Test 3", () {
      var value = FileFieldValue(path: "a.jpg");
      value.clearNew();
      expect(value.file, null);
      expect(value.path, "a.jpg");
      expect(value.hasUpdated, false);
      expect(value.willClear, false);
      expect(value.value, null);
    });

    test("Test 4", () {
      var value = FileFieldValue(path: "a.jpg");
      value.file = file;
      expect(value.file, file);
      expect(value.path, "a.jpg");
      expect(value.hasUpdated, true);
      expect(value.willClear, false);
      expect(value.value, file);
      value.clearOld();
      expect(value.file, file);
      expect(value.path, "a.jpg");
      expect(value.hasUpdated, true);
      expect(value.willClear, true);
      expect(value.value, file);
      value.restoreOld();
      expect(value.file, file);
      expect(value.path, "a.jpg");
      expect(value.hasUpdated, true);
      expect(value.willClear, false);
      expect(value.value, file);
    });
  });
}
