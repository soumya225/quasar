import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SpinKitFadingFour(
          color: Theme.of(context).accentColor,
          shape: BoxShape.rectangle,
        ),
      ),
    );
  }
}
