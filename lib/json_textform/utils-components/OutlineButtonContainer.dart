import 'package:flutter/material.dart';

class OutlineButtonContainer extends StatelessWidget {
  final bool isOutlined;
  final bool isFilled;
  final Widget child;
  final Key key;

  OutlineButtonContainer({
    this.isOutlined = false,
    this.child,
    this.key,
    this.isFilled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isOutlined
          ? null
          : isFilled ? Theme.of(context).inputDecorationTheme.fillColor : null,
      decoration: isOutlined
          ? BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(10),
              color: isFilled
                  ? Theme.of(context).inputDecorationTheme.fillColor
                  : null,
            )
          : null,
      child: child,
    );
  }
}
