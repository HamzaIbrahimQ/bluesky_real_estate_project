import 'package:flutter/material.dart';
import 'package:bluesky_project/utils/widget_functions.dart';

class OptionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final double width;
  final double size;
  final Color color;
  final Function onPressed;

  const OptionButton({Key key, @required this.text, @required this.icon, @required this.width, this.size, this.color, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
          backgroundColor: MaterialStateProperty.all(
            color,
          ),
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: size * 1.1,
              ),
              addHorizontalSpace(10),
              Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: size * 0.7),
              )
            ],
          )
      ),
    );
  }
}
