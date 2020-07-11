import 'package:flutter/material.dart';

class OutlineButtonContainer extends StatelessWidget {
  final bool isOutlined;
  final bool isFilled;
  final Widget child;
  final Key key;

  OutlineButtonContainer({
    @required this.isOutlined,
    this.child,
    this.key,
    this.isFilled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
