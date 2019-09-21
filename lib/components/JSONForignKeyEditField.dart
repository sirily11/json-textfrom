import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';


import '../JSONSchemaForm.dart';
import '../utils.dart';

class BaseEditField {
  GlobalKey<ScaffoldState> key = GlobalKey();

  String _preProcessURL(String path) {
    String p = "$path/".replaceFirst("-", "_");
    String url = getURL(p);
    return url;
  }

  /// Update current forign key's value
  /// Only call this method if the mode is editing
  Future updateField(String path, Map<String, dynamic> json, dynamic id) async {
    try {
      String url = "${_preProcessURL(path)}$id/";
      Response response = await Dio().patch(url, data: json);
      return;
    } on DioError catch (e) {
      _showSnackBar(e.message);
    }
  }

  /// Add new forign key
  /// Only call this method if the mode is not edit
  Future addField(String path, Map<String, dynamic> json) async {
    try {
      String url = _preProcessURL(path);
      Response response = await Dio().post(url, data: json);
      return;
    } on DioError catch (e) {
      _showSnackBar(e.message);
    }
  }

  /// Get schema
  Future<List<Map<String, dynamic>>> getEditSchema(String path) async {
    try {
      String url = _preProcessURL(path);
      Response response =
          await Dio().request(url, options: Options(method: "OPTIONS"));
      return (response.data['fields'] as List)
          .map((d) => d as Map<String, dynamic>)
          .toList();
    } on DioError catch (e) {
      _showSnackBar(e.message);
    }
    return null;
  }

  /// show error message
  void _showSnackBar(String message) {
    key.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  /// get values
  Future<Map<String, dynamic>> getValues(String path, dynamic id) async {
    try {
      String url = "${_preProcessURL(path)}$id/";
      Response response = await Dio().get(url);
      return response.data;
    } on DioError catch (e) {
      _showSnackBar(e.message);
    }
    return null;
  }
}

class JSONForignKeyEditField extends StatefulWidget {
  final String path;
  final Function onSubmit;
  final String title;
  final dynamic id;
  final bool isEdit;

  JSONForignKeyEditField(
      {@required this.path,
      this.onSubmit,
      this.title,
      this.id,
      this.isEdit = false});

  @override
  _JSONForignKeyEditFieldState createState() => _JSONForignKeyEditFieldState();
}

class _JSONForignKeyEditFieldState extends State<JSONForignKeyEditField>
    with BaseEditField {
  List<Map<String, dynamic>> schemas = [];
  Map<String, dynamic> values;

  @override
  void initState() {
    super.initState();
    getEditSchema(widget.path).then((value) {
      setState(() {
        schemas = value;
      });
    });
    if (widget.isEdit) {
      getValues(widget.path, widget.id).then((v) {
        setState(() {
          values = v;
        });
      });
    } else {
      // If this is not edit mode, set values to empty
      values = {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
          title: schemas.length > 0 && values != null
              ? Text(widget.title)
              : JumpingDotsProgressIndicator(
                  color: Colors.white,
                  fontSize: 26,
                )),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: schemas.length > 0 && values != null
            ? JSONSchemaForm(
                schema: schemas,
                values: values,
                onSubmit: (Map<String, dynamic> json) async {
                  print(json);
                  if (widget.isEdit) {
                    await updateField(widget.path, json, widget.id);
                  } else {
                    await addField(widget.path, json);
                  }
                  Navigator.pop(context);
                },
              )
            : Container(
                child: Center(
                  child: Image.asset("assets/animat-cube-color.gif"),
                ),
              ),
      ),
    );
  }
}
