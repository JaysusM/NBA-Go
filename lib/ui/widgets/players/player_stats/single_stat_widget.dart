import 'package:flutter/material.dart';

class SingleStatWidget extends StatelessWidget {
  final String name;
  final double value;
  static const SIZE = 100.0;

  SingleStatWidget({@required this.name, @required this.value})
      : assert(name != null),
        assert(value != null);

  @override
  Widget build(BuildContext context) {
    TextStyle nameStyle = TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        fontSize: 20.0,
        color: Theme.of(context).toggleableActiveColor);
    TextStyle valueStyle = TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w200,
        fontSize: 30.0,
        color: Theme.of(context).primaryColor);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(name, style: nameStyle),
          Text("$value", style: valueStyle)
        ],
      ),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Theme.of(context).backgroundColor, width: 1.5),
          left: BorderSide(color: Theme.of(context).backgroundColor, width: 1.5),
        ),
      ),
      height: SIZE,
      width: SIZE,
    );
  }
}
