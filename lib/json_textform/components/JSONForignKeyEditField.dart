import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/JSONForm.dart';
import 'package:json_schema_form/json_textform/models/Action.dart';
import 'package:json_schema_form/json_textform/models/Icon.dart';
import 'package:json_schema_form/json_textform/models/NetworkProvider.dart';
import 'package:provider/provider.dart';

/// This is the field for forign key.
/// For example if model b is forign key of model a
/// This will create/ update model b
// /// based on the path
// class JSONForignKeyEditField extends StatefulWidget {
//   /// Model path
//   final String path;

//   /// On submit button has been clicked
//   final Function onSubmit;

//   /// Page's title
//   final String title;

//   /// Page's name
//   /// This one is different from the title
//   /// and will be used to merge actions and icons.
//   final String name;

//   /// Model's id. This will be provided if
//   /// and only if the mode is editing mode
//   final dynamic id;

//   /// Whether the mode is editing mode
//   final bool isEdit;
//   final bool isOutlined;

//   /// List of actions. Each field will only have one action.
//   /// If not, the last one will replace the first one.
//   final List<FieldAction> actions;

//   /// List of icons. Each field will only have one icon.
//   /// If not, the last one will replace the first one.
//   final List<FieldIcon> icons;

//   JSONForignKeyEditField(
//       {@required this.path,
//       this.onSubmit,
//       this.title,
//       this.id,
//       this.isOutlined = false,
//       this.isEdit = false,
//       @required this.name,
//       this.actions,
//       this.icons});

//   @override
//   _JSONForignKeyEditFieldState createState() => _JSONForignKeyEditFieldState();
// }

// class _JSONForignKeyEditFieldState extends State<JSONForignKeyEditField> {
//   List<Map<String, dynamic>> schemas = [];
//   Map<String, dynamic> values;

//   @override
//   void initState() {
//     super.initState();
//     Provider.of<NetworkProvider>(context, listen: false)
//         .getEditSchema(widget.path)
//         .then((value) {
//       if (value != null) {
//         setState(() {
//           schemas = value;
//         });
//       }
//     });
//     if (widget.isEdit) {
//       Provider.of<NetworkProvider>(context, listen: false)
//           .getValues(widget.path, widget.id)
//           .then((v) {
//         setState(() {
//           values = v;
//         });
//       });
//     } else {
//       // If this is not edit mode, set values to empty
//       values = {};
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     NetworkProvider provider = Provider.of(context);
//     return Scaffold(
//       key: provider.key,
//       appBar: AppBar(
//           title: schemas.length > 0 && values != null
//               ? Text(widget.title)
//               : JumpingDotsProgressIndicator(
//                   color: Colors.white,
//                   fontSize: 26,
//                 )),
//       body: AnimatedSwitcher(
//         duration: Duration(milliseconds: 300),
//         child: schemas.length > 0 && values != null
//             ? JSONForm(
//                 schemaName: widget.name,
//                 rounded: widget.isOutlined,
//                 schema: schemas,
//                 values: values,
//                 actions: widget.actions,
//                 icons: widget.icons,
//                 onSubmit: (Map<String, dynamic> json) async {
//                   if (widget.isEdit) {
//                     await provider.updateField(widget.path, json, widget.id);
//                   } else {
//                     await provider.addField(widget.path, json);
//                   }
//                   Navigator.pop(context);
//                 },
//               )
//             : Container(
//                 child: Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               ),
//       ),
//     );
//   }
// }

class JSONForignKeyEditField extends StatelessWidget {
  final OnFetchingSchema onFetchingSchema;

  /// Model path
  final String path;

  /// On submit button has been clicked
  final Function onSubmit;

  /// Page's title
  final String title;

  /// Page's name
  /// This one is different from the title
  /// and will be used to merge actions and icons.
  final String name;

  /// Model's id. This will be provided if
  /// and only if the mode is editing mode
  final dynamic id;

  /// Whether the mode is editing mode
  final bool isEdit;
  final bool isOutlined;

  /// List of actions. Each field will only have one action.
  /// If not, the last one will replace the first one.
  final List<FieldAction> actions;

  /// List of icons. Each field will only have one icon.
  /// If not, the last one will replace the first one.
  final List<FieldIcon> icons;

  const JSONForignKeyEditField({
    @required this.path,
    this.onSubmit,
    this.title,
    this.id,
    this.isOutlined = false,
    this.isEdit = false,
    @required this.name,
    @required this.onFetchingSchema,
    this.actions,
    this.icons,
  });

  @override
  Widget build(BuildContext context) {
    NetworkProvider provider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("$title"),
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 100),
        child: FutureBuilder<SchemaValues>(
          future: onFetchingSchema(path, isEdit, id),
          builder: (context, schemaSnapshot) {
            if (!schemaSnapshot.hasData) {
              return CircularProgressIndicator();
            }
            if (schemaSnapshot.hasError) {
              return Center(
                child: Text("${schemaSnapshot.error}"),
              );
            }
            if (schemaSnapshot.data == null) {
              return Container();
            }
            return JSONForm(
              onFetchingSchema: onFetchingSchema,
              schemaName: name,
              rounded: isOutlined,
              schema: schemaSnapshot.data.schema,
              values: schemaSnapshot.data.values,
              actions: actions,
              showSubmitButton: true,
              icons: icons,
              onSubmit: (Map<String, dynamic> json) async {
                if (isEdit) {
                  await provider.updateField(path, json, id);
                } else {
                  await provider.addField(path, json);
                }
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }
}
