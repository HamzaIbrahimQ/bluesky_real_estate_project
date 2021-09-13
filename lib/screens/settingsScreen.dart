import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:bluesky_project/providers/auth.dart';
import 'package:bluesky_project/screens/userHousesScreen.dart';
import 'package:bluesky_project/utils/constants.dart';
import 'package:bluesky_project/utils/widget_functions.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'loginScreen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {



  _showVisitorAlert() {
    final userProvider = Provider.of<Auth>(context, listen: false);
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Container(
            height: 200.0,
            child: DialogBackground(
              color: Colors.white,
              barrierColor: Colors.white,
              dismissable: true,
              blur: 0.2,
              onDismiss: () {},
              dialog: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                        type: MaterialType.transparency,
                        child: Text('Sorry, you need to login first!', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),)
                    ),
                    addVerticalSpace(16),
                    ElevatedButton(
                      child: Text('Login',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.green[700]),
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 5)),
                      ),
                      onPressed: () {
                        userProvider.visitor(false);
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = (mediaQuery.orientation == Orientation.landscape);
    final size = isLandscape ? screenSize.height * 0.05 : screenSize.width * 0.05;
    final double padding = isLandscape ? screenSize.height * 0.04 : screenSize.width * 0.04;
    final ThemeData themeData = Theme.of(context);
    final userProvider = Provider.of<Auth>(context);


    return SafeArea(
      child: Container(
        color: Color(0xfff6f6f6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            addVerticalSpace(size / 3),
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      if (isVisitor) {
                        _showVisitorAlert();
                      }
                      else {
                        return showDialog(context: context, builder: (context) => DialogBackground(
                          color: Colors.white,
                          barrierColor: Colors.white,
                          dismissable: true,
                          blur: 0.2,
                          onDismiss: () {},
                          dialog: UserHousesScreen(),
                        ));
                      }
                    },
                    child: SettingItem(
                      icon: LineAwesomeIcons.home,
                      text: 'My houses',
                      padding: size,
                      size: size,
                    ),
                  ),
                  isLandscape ? SizedBox() : addVerticalSpace(size / 3),
                  SettingItem(
                    icon: LineAwesomeIcons.question_circle,
                    text: 'Help',
                    padding: size,
                    size: size,
                  ),
                  isLandscape ? SizedBox() : addVerticalSpace(size / 3),
                  SettingItem(
                    icon: LineAwesomeIcons.star,
                    text: 'Rate us',
                    padding: size,
                    size: size,
                  ),
                  isLandscape ? SizedBox() : addVerticalSpace(size / 3),
                  SettingItem(
                    icon: LineAwesomeIcons.user_plus,
                    text: 'Share with Friend',
                    padding: size,
                    size: size,
                  ),
                  addVerticalSpace(size * 17),
                  Padding(
                    padding: EdgeInsets.only(
                        top: padding, left: padding, right: padding, bottom: padding),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: InkWell(
                        onTap: () {
                          if (isVisitor) {
                            _showVisitorAlert();
                          }
                          else {
                          return showDialog(context: context, builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            content: Text('Do you want to logout?', style: themeData.textTheme.headline6.copyWith(color: Colors.green[700], fontSize: size / 1.6),),
                            actions: [
                              TextButton(
                                child: Text('No', style: TextStyle(color: Colors.green[700]),),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Yes', style: TextStyle(color: Colors.red)),
                                onPressed: () {
                                  print('loggggggggouuuuuuuuuuuttttttt');
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                  Provider.of<Auth>(context, listen: false).logout();
                                  // Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),);
                          }
                        },
                        child: Container(
                          height: isLandscape ? screenSize.width * 0.8 * 0.07 : screenSize.height * 0.8 * 0.07,
                          padding: EdgeInsets.symmetric(horizontal: padding,),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                LineAwesomeIcons.alternate_sign_out,
                                size: size,
                                color: Colors.green[700],
                              ),
                              addHorizontalSpace(padding / 2),
                              Text(
                                'Logout',
                                style: TEXT_THEME_DEFAULT.headline3.copyWith(color: Colors.green[700], fontSize: isLandscape ? screenSize.width * 0.018 : screenSize.height * 0.018),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // addVerticalSpace(padding),
          ],
        ),
      ),
    );
  }


}

class SettingItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final double padding;
  final double size;
  final Color textColor;

  const SettingItem({
    this.icon,
    this.text,
    this.padding,
    this.size,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: size, left: size, right: size),
      child: Container(
        height: size * 2,
        padding: EdgeInsets.symmetric(
          horizontal: size,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.green[700],
        ),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              size: size,
              color: textColor ?? Colors.white,
            ),
            SizedBox(width: size / 2),
            Text(
              text,
              style: TextStyle(color: textColor ?? Colors.white),
            ),
            Spacer(),
            Icon(
              LineAwesomeIcons.angle_right,
              color: Colors.white,
              size: size,
            ),
          ],
        ),
      ),
    );
  }
}
