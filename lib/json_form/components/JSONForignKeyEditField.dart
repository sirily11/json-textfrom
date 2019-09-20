import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:json_textform/json_form/JSONSchemaForm.dart';

import '../utils.dart';

class JSONForignKeyEditField extends StatefulWidget {
  final String path;
  final Function onSubmit;
  final String title;

  JSONForignKeyEditField({@required this.path, this.onSubmit, this.title});

  @override
  _JSONForignKeyEditFieldState createState() => _JSONForignKeyEditFieldState();
}

class _JSONForignKeyEditFieldState extends State<JSONForignKeyEditField> {
  List<Map<String, dynamic>> schemas = [];

  @override
  void initState() {
    super.initState();
    _getEditSchema(widget.path).then((value) {
      setState(() {
        schemas = value;
      });
    });
  }

  Future<List<Map<String, dynamic>>> _getEditSchema(String path) async {
    String p = "$path/".replaceFirst("-", "_");
    String url = getURL(p);
    Response response =
        await Dio().request(url, options: Options(method: "OPTIONS"));
    return (response.data['fields'] as List)
        .map((d) => d as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: schemas.length > 0
            ? JSONSchemaForm(
                schema: schemas,
              )
            : Container(),
      ),
    );
  }
}
