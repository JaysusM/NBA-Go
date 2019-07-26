import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitRipple (
        duration: Duration(milliseconds: 750),
        size: 100.0,
        color: Theme.of(context).primaryColor,
      )
    );
  }
}