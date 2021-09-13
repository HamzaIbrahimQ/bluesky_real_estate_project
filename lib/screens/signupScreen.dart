import 'dart:io';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:bluesky_project/utils/constants.dart';
import 'package:bluesky_project/utils/widget_functions.dart';
import 'package:provider/provider.dart';
import 'package:bluesky_project/providers/auth.dart';





class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final _formKey = GlobalKey<FormState>();
  bool _passwordisObsecure = true;
  bool _submitPasswordisObsecure = true;
  String password;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'name': '',
    'imageUrl': '',
  };

  bool isCharOnly(String value){
    for(int i = 0 ; i <= 9 ; i ++) {
      if(value.contains(i.toString())) {
        return false;
      }
    }
    return true;
  }
  var _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).visitor(false);
      await Provider.of<Auth>(context, listen: false).signup(_authData['email'], _authData['password'], _authData['name'], _authData['imageUrl'], context);
    }
    on HttpException catch (error) {
      var errorMessage = 'Sorry, we can\'t logged you in now, check your internet connection and try again';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email is exist, please try another one';
      }
      else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'Invalid email';
      }
      else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'Weak password, try another one';
      }
      else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'This email is not exist!';
      }
      else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Wrong password';
      }
      _showErrorDialog(errorMessage);
    }
    catch (error) {
      const errorMessage = 'Sorry, check your internet connection and try again';
      _showErrorDialog(errorMessage);
    }
    //  on HttpException catch.... this code catch only the specific class errors
    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog (String message) {
    showDialog(context: context, builder: (context) =>
        AlertDialog(
          title: Text('Error!'),
          content: Text(message),
          actions: [
            TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            ),
          ],
        )
    );
  }


  String email;








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
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            width: isLandscape ? screenSize.width : screenSize.height,
            height: isLandscape ? screenSize.width : screenSize.height,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Hero(
                            tag: 'iconImage',
                            child: Container(
                              height: isLandscape ? screenSize.width * 0.2 : screenSize.height * 0.25,
                              margin: EdgeInsets.only(top: size),
                              child: Image.asset('images/signupImage.png'),
                            ),
                          ),
                        ),
                        addVerticalSpace(size * 2),
                        Container(
                            height: isLandscape ? screenSize.width * 0.3 : screenSize.height * 0.4,
                            padding: EdgeInsets.all(padding),
                            child: RawScrollbar(
                              thumbColor: purpleColor,
                              thickness: 2.0,
                              radius: Radius.circular(15.0),
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Padding(
                                  padding: sidePadding,
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: <Widget>[
                                        TextFormField(
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              color: Colors.black,
                                              decorationColor: Colors.black,
                                              fontSize: isLandscape ? screenSize.width * 0.018 : screenSize.height * 0.018
                                          ),
                                          decoration: InputDecoration(
                                            hintText: 'Name',
                                            hintStyle: TextStyle(
                                              color: purpleColor.withOpacity(0.5),
                                              fontSize: size / 1.8,
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.green),
                                            ),
                                            errorStyle: TextStyle(
                                              fontSize: size / 2.3,
                                            ),
                                            focusedErrorBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: purpleColor,
                                              ),
                                            ),
                                            prefixIcon: Icon(
                                              LineAwesomeIcons.user,
                                              size: size,
                                              color: purpleColor,
                                            ),
                                          ),
                                          cursorColor: purpleColor,
                                          onSaved: (value) {
                                            _authData['name'] = value;
                                          },
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Please enter your name';
                                            }
                                            if (value.startsWith(' ')) {
                                              return 'can\t start with space';
                                            }
                                            if (value.contains('٠') || value.contains('١') || value.contains('٢') || value.contains('٣') || value.contains('٤') || value.contains('٥')
                                                || value.contains('٦') || value.contains('٧') || value.contains('٨') || value.contains('٩') || value.contains('0') || value.contains('1')
                                                || value.contains('2') || value.contains('3') || value.contains('4') || value.contains('5') || value.contains('6') || value.contains('7')
                                                || value.contains('8') || value.contains('9')) {
                                              return 'Letters only!';
                                            }
                                            if (value.length > 25) {
                                              return 'Name can\'t be more than 25 character';
                                            }
                                            else {
                                              return null;
                                            }
                                          },
                                        ),
                                    addVerticalSpace(size),
                                    TextFormField(
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                          color: Colors.black,
                                          decorationColor: Colors.black,
                                          fontSize: isLandscape ? screenSize.width * 0.018 : screenSize.height * 0.018
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        hintText: 'Email',
                                        hintStyle: TextStyle(
                                          color: purpleColor.withOpacity(0.5),
                                          fontSize: size / 1.8,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.green)
                                        ),
                                        errorStyle: TextStyle(
                                          fontSize: size / 2.3,
                                        ),
                                        focusedErrorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: purpleColor,
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.email,
                                          size: size,
                                          color: purpleColor,
                                        ),
                                      ),
                                      cursorColor: purpleColor,
                                      onSaved: (value) {
                                        _authData['email'] = value;
                                         email = _authData['email'];
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        if (value.contains(' ')) {
                                          return 'Email can\'t contain a space';
                                        }
                                        if (value.startsWith('0') || value.startsWith('1') || value.startsWith('2') || value.startsWith('3') || value.startsWith('4') || value.startsWith('5')
                                            || value.startsWith('6') || value.startsWith('7') || value.startsWith('8') || value.startsWith('9')) {
                                          return 'Email can\'t start with number';
                                        }
                                        if ((value.contains('ج') || value.contains('ح') || value.contains('خ') || value.contains('ه') || value.contains('ع') || value.contains('غ') || value.contains('ف')
                                            || value.contains('ق') || value.contains('ث') || value.contains('ص') || value.contains('ض') || value.contains('ت') || value.contains('ا') || value.contains('ل')
                                            || value.contains('ب') || value.contains('ي') || value.contains('س') || value.contains('ش') || value.contains('ن') || value.contains('م') || value.contains('ك')
                                            || value.contains('ط') || value.contains('د') || value.contains('ظ') || value.contains('ز') || value.contains('ى') || value.contains('ة') || value.contains('و')
                                            || value.contains('ئ') || value.contains('ر') || value.contains('ؤ') || value.contains('ء') || value.contains('ذ') || value.contains('٠') || value.contains('١')
                                            || value.contains('٢') || value.contains('٣') || value.contains('٤') || value.contains('٥') || value.contains('٦') || value.contains('٧') || value.contains('٨')
                                            || value.contains('٩'))) {
                                          return 'Please use english language';
                                        }
                                        if (!value.contains('@') || !value.endsWith('.com')) {
                                          return 'Please enter a valid email';
                                        }
                                        else {
                                          return null;
                                        }
                                      },
                                    ),
                                    addVerticalSpace(size),
                                    TextFormField(
                                      style: TextStyle(
                                          color: Colors.black,
                                          decorationColor: Colors.black,
                                          fontSize: isLandscape ? screenSize.width * 0.018 : screenSize.height * 0.018
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Password',
                                        hintStyle: TextStyle(
                                          color: purpleColor.withOpacity(0.5),
                                          fontSize: size / 1.8,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.green),
                                        ),
                                        errorStyle: TextStyle(
                                          fontSize: size / 2.3,
                                        ),
                                        focusedErrorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: purpleColor,
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          LineAwesomeIcons.user_lock,
                                          size: size,
                                          color: purpleColor,
                                        ),
                                        suffix: _passwordisObsecure ? InkWell(child:
                                        Text('Show' ,
                                          style:  TextStyle(
                                              fontSize: size / 2,
                                              color: purpleColor,
                                              fontWeight: FontWeight.w700),),
                                          onTap: () {
                                            setState(() {
                                              _passwordisObsecure = !_passwordisObsecure;
                                            });
                                          },
                                        ) :
                                        InkWell(child:
                                        Text('Hide',
                                          style: TextStyle(
                                            fontSize: size / 2,
                                            color: purpleColor,
                                            fontWeight: FontWeight.w700,),),
                                          onTap: () {
                                            setState(() {
                                              _passwordisObsecure = !_passwordisObsecure;
                                            });
                                          },
                                        ),
                                      ),
                                      cursorColor: purpleColor,
                                      obscureText: _passwordisObsecure,
                                      onSaved: (value) {
                                        _authData['password'] = value;
                                      },
                                      validator: (value) {
                                        setState(() {
                                          password = value;
                                        });
                                        if (value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        if (value.contains(' ')) {
                                          return 'can\t contain a space';
                                        }
                                        if ((value.contains('ج') || value.contains('ح') || value.contains('خ') || value.contains('ه') || value.contains('ع') || value.contains('غ') || value.contains('ف')
                                            || value.contains('ق') || value.contains('ث') || value.contains('ص') || value.contains('ض') || value.contains('ت') || value.contains('ا') || value.contains('ل')
                                            || value.contains('ب') || value.contains('ي') || value.contains('س') || value.contains('ش') || value.contains('ن') || value.contains('م') || value.contains('ك')
                                            || value.contains('ط') || value.contains('د') || value.contains('ظ') || value.contains('ز') || value.contains('ى') || value.contains('ة') || value.contains('و')
                                            || value.contains('ئ') || value.contains('ر') || value.contains('ؤ') || value.contains('ء') || value.contains('ذ') || value.contains('٠') || value.contains('١') || value.contains('٢') || value.contains('٣')
                                            || value.contains('٤') || value.contains('٥') || value.contains('٦') || value.contains('٧') || value.contains('٨') || value.contains('٩'))) {
                                          return 'Please use english language';
                                        }
                                        if (value.length < 6) {
                                          return 'Password can\'t be less than 6 characters';
                                        }
                                        if (value.length > 15) {
                                          return 'Password can\'t be more than 15 characters';
                                        }
                                        else {
                                          return null;
                                        }
                                      },
                                    ),
                                        addVerticalSpace(size),
                                        TextFormField(
                                          style: TextStyle(
                                              color: Colors.black,
                                              decorationColor: Colors.black,
                                              fontSize: isLandscape ? screenSize.width * 0.018 : screenSize.height * 0.018
                                          ),
                                          decoration: InputDecoration(
                                            hintText: 'Submit password',
                                            hintStyle: TextStyle(
                                              color: purpleColor.withOpacity(0.5),
                                              fontSize: size / 1.8,
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.green),
                                            ),
                                            errorStyle: TextStyle(
                                              fontSize: size / 2.3,
                                            ),
                                            focusedErrorBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: purpleColor,
                                              ),
                                            ),
                                            prefixIcon: Icon(
                                              LineAwesomeIcons.user_lock,
                                              size: size,
                                              color: purpleColor,
                                            ),
                                            suffix: _submitPasswordisObsecure ? InkWell(child:
                                            Text('Show' ,
                                              style:  TextStyle(
                                                  fontSize: size / 2,
                                                  color: purpleColor,
                                                  fontWeight: FontWeight.w700),),
                                              onTap: () {
                                                setState(() {
                                                  _submitPasswordisObsecure = !_submitPasswordisObsecure;
                                                });
                                              },
                                            ) :
                                            InkWell(child:
                                            Text('Hide',
                                              style: TextStyle(
                                                fontSize: size / 2,
                                                color: purpleColor,
                                                fontWeight: FontWeight.w700,),),
                                              onTap: () {
                                                setState(() {
                                                  _submitPasswordisObsecure = !_submitPasswordisObsecure;
                                                });
                                              },
                                            ),
                                          ),
                                          cursorColor: purpleColor,
                                          obscureText: _submitPasswordisObsecure,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Please enter your password again';
                                            }
                                            if (value.contains(' ')) {
                                              return 'can\t contain a space';
                                            }
                                            if ((value.contains('ج') || value.contains('ح') || value.contains('خ') || value.contains('ه') || value.contains('ع') || value.contains('غ') || value.contains('ف')
                                                || value.contains('ق') || value.contains('ث') || value.contains('ص') || value.contains('ض') || value.contains('ت') || value.contains('ا') || value.contains('ل')
                                                || value.contains('ب') || value.contains('ي') || value.contains('س') || value.contains('ش') || value.contains('ن') || value.contains('م') || value.contains('ك')
                                                || value.contains('ط') || value.contains('د') || value.contains('ظ') || value.contains('ز') || value.contains('ى') || value.contains('ة') || value.contains('و')
                                                || value.contains('ئ') || value.contains('ر') || value.contains('ؤ') || value.contains('ء') || value.contains('ذ') || value.contains('٠') || value.contains('١') || value.contains('٢') || value.contains('٣')
                                                || value.contains('٤') || value.contains('٥') || value.contains('٦') || value.contains('٧') || value.contains('٨') || value.contains('٩'))) {
                                              return 'Please use english language';
                                            }
                                            if (value.length < 6) {
                                              return 'Password can\'t be less than 6 characters';
                                            }
                                            if (value.length > 15) {
                                              return 'Password can\'t be more than 15 characters';
                                            }
                                            if (password != null && value != password) {
                                              return 'Password doesn\'t match';
                                            }
                                            else {
                                              return null;
                                            }
                                          },
                                        ),
                                        addVerticalSpace(size),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ]),
                  Padding(
                    padding: EdgeInsets.only(top: size),
                    child: InkWell(
                      onTap: _submit,
                      child: Hero(
                        tag: 'login',
                        child: Container(
                          width: isLandscape ? screenSize.height * 0.7 : screenSize.width * 0.7,
                          height: isLandscape ? screenSize.width * 0.05 : screenSize.height * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: purpleColor,
                          ),
                          child: Center(
                            child: _isLoading ? CircularProgressIndicator(
                              backgroundColor: greenColor,
                              valueColor: AlwaysStoppedAnimation<Color>(purpleColor),
                            ) : Text(
                              'Create Account',
                              style: TEXT_THEME_DEFAULT.headline1.copyWith(decoration: TextDecoration.none, color: greenColor, fontSize: isLandscape ? screenSize.width * 0.014 : screenSize.height * 0.018, fontWeight: FontWeight.w700,),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  addVerticalSpace(size),
                  Padding(
                    padding: EdgeInsets.only(bottom: padding),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Hero(
                        tag: 'loginWithGoogle',
                        child: Container(
                          width: isLandscape ? screenSize.height * 0.7 : screenSize.width * 0.7,
                          height: isLandscape ? screenSize.width * 0.05 : screenSize.height * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Colors.transparent,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    width: 1.0
                                ),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Center(
                              child: Text('Back to Login',
                                style: TEXT_THEME_DEFAULT.headline1.copyWith(decoration: TextDecoration.none, color: purpleColor, fontSize: isLandscape ? screenSize.width * 0.010 : screenSize.height * 0.012, fontWeight: FontWeight.w700,),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}