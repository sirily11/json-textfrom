import 'package:flutter/material.dart';

typedef Future<Map<String, dynamic>> OnControllerSubmit(BuildContext context);

class JSONSchemaController {
  OnControllerSubmit onSubmit;
}
