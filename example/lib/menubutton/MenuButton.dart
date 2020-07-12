import 'package:flutter/material.dart';
import 'package:json_schema_form_example/model/HomeProvider.dart';
import 'package:provider/provider.dart';

class MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = Provider.of(context);
    return Positioned(
      width: 300,
      right: 10,
      bottom: 100,
      child: Card(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            CheckboxListTile(
              title: Text("Show Submit Button"),
              value: homeProvider.showSubmitButton,
              onChanged: (v) => homeProvider.showSubmitButton = v,
            ),
            CheckboxListTile(
              title: Text("Filled"),
              value: homeProvider.isFilled,
              onChanged: (v) => homeProvider.isFilled = v,
            ),
            CheckboxListTile(
              title: Text("Is Rounded"),
              value: homeProvider.isRounded,
              onChanged: (v) => homeProvider.isRounded = v,
            ),
            CheckboxListTile(
              title: Text("Use Dropdown"),
              value: homeProvider.useDropdown,
              onChanged: (v) => homeProvider.useDropdown = v,
            )
          ],
        ),
      ),
    );
  }
}
