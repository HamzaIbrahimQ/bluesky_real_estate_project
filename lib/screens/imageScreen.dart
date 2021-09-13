import 'package:flutter/material.dart';
import 'package:bluesky_project/utils/constants.dart';
import 'package:photo_view/photo_view.dart';


class ImageScreen extends StatelessWidget {

  String image;
  ImageScreen(this.image);



  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;
    // final ThemeData themeData = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = (mediaQuery.orientation == Orientation.landscape);
    final size = isLandscape ? screenSize.height * 0.05 : screenSize.width * 0.05;
    // size = 20.55
    final double padding = isLandscape ? screenSize.height * 0.04 : screenSize.width * 0.04;
    // padding = 16.45

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: padding * 2),
            child: Center(
              child: PhotoView(
                imageProvider: NetworkImage(image),
                // enableRotation: true,
              ),
            ),
          ),
          if (isLandscape) Positioned(
              bottom: screenSize.width * 0.4,
              left: screenSize.width * 0.01,
            child: IconButton(
              icon: Icon(Icons.clear),
              color: Colors.red,
              iconSize: size * 2,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          if (!isLandscape) Positioned(
            bottom: size,
            left: screenSize.width / 2.8,
            child: ElevatedButton(
              child: Text('Exit',
              textAlign: TextAlign.center,
              style: TEXT_THEME_DEFAULT.headline3.copyWith(color: Colors.red, fontSize: isLandscape ? screenSize.width * 0.015 : screenSize.height * 0.020),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: screenSize.width * 0.1)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),),
        ],
      ),
    );
  }
}
