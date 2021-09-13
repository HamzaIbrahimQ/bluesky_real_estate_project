import 'package:flutter/material.dart';
import 'package:bluesky_project/utils/constants.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: greenColor,
          valueColor: AlwaysStoppedAnimation<Color>(purpleColor),
        ),
      ),
    );
  }
}
