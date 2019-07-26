import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  String error;
  
  ErrorMessageWidget({@required this.error}) 
    : assert(error != null);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        error,
        style: Theme.of(context).textTheme.body2
      ),
    );
  }
}