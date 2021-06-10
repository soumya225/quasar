import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          "assets/icons/in-app-icon.png",
          width: 160
        ),
      ),
      body: Center(
        child: Text("NO INTERNET CONNECTION"),
      ),
    );
  }
}
