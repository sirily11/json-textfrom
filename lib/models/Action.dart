import 'package:json_schema_form/models/Icon.dart';
import 'package:json_schema_form/models/Schema.dart';

/// Actions type
enum ActionTypes { image, qrScan }

/// Actions when the action is finished
enum ActionDone { getInput, getImage }

/// Field Action class for each json field
class FieldAction implements Field<FieldAction> {
  ActionTypes actionTypes;
  ActionDone actionDone;
  @override
  String schemaName;

  FieldAction({this.actionDone, this.actionTypes, this.schemaName});

  onDone<T>(T value) {}

  @override
  List<Schema> merge(List<Schema> schemas, List<FieldAction> fields) {
    return schemas.map((s) {
      fields.forEach((f) {
        if (f.schemaName == s.name) {
          s.action = f;
        }
      });
      return s;
    }).toList();
  }
}
