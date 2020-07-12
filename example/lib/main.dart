import 'package:flutter/material.dart';
import 'package:json_schema_form/json_schema_form.dart';
import 'package:json_schema_form/json_textform/models/Controller.dart';
import 'package:json_schema_form_example/components/CheckBoxDemo.dart';
import 'package:json_schema_form_example/components/CompleteDemo.dart';
import 'package:json_schema_form_example/components/DatetimeFieldDemo.dart';
import 'package:json_schema_form_example/components/FileFieldDemo.dart';
import 'package:json_schema_form_example/components/ManyToManyFieldDemo.dart';
import 'package:json_schema_form_example/components/SelectionFieldDemo.dart';
import 'package:json_schema_form_example/components/TextFieidDemo.dart';
import 'package:json_schema_form_example/components/TextFieldInListView.dart';
import 'package:json_schema_form_example/model/HomeProvider.dart';
import 'package:provider/provider.dart';

import 'components/ForeignkeyDemo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  ThemeData buildTheme() {
    final ThemeData base = ThemeData();
    return base.copyWith(
      iconTheme: IconThemeData(color: Colors.grey),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.grey[400],
      ),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeProvider(),
        )
      ],
      child: MaterialApp(
        theme: buildTheme(),
        title: 'Flutter Demo',
        home: MyHomePage(),
      ),
    );
  }
}

class DemoPage {
  Widget page;
  String title;

  DemoPage({@required this.page, @required this.title});
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  JSONSchemaController controller = JSONSchemaController();
  final List<DemoPage> pages = [
    DemoPage(
      title: "TextField Field",
      page: TextFieldDemo(),
    ),
    DemoPage(
      title: "CheckBox Field",
      page: CheckBoxDemo(),
    ),
    DemoPage(
      title: "Datetime Field",
      page: DatetimeFieldDemo(),
    ),
    DemoPage(
      title: "Selection Field",
      page: SelectionFieldDemo(),
    ),
    DemoPage(
      title: "foreignkey Field",
      page: ForeignkeyDemo(),
    ),
    DemoPage(
      title: "File Field",
      page: FileFieldDemo(),
    ),
    DemoPage(
      title: "ManyToMany Field",
      page: ManyToManyFieldDemo(),
    ),
    DemoPage(
      title: "Text Field in ListView",
      page: TextFieldInListView(),
    ),
    DemoPage(
      title: "Complete Demo",
      page: CompleteDemo(),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form"),
      ),
      body: ListView.builder(
          itemCount: pages.length,
          itemBuilder: (context, index) {
            DemoPage page = pages[index];
            return ListTile(
              title: Text(
                "${page.title}",
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => page.page,
                  ),
                );
              },
            );
          }),
    );
  }
}
