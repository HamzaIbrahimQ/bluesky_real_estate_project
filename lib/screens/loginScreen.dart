import 'package:bluesky_project/main.dart';
import 'package:bluesky_project/screens/homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:bluesky_project/providers/auth.dart';
import 'package:bluesky_project/screens/signupScreen.dart';
import 'package:bluesky_project/utils/constants.dart';
import 'package:bluesky_project/utils/widget_functions.dart';
import 'package:provider/provider.dart';
import 'package:bluesky_project/models/http_exception.dart';





class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final _secondFormKey = GlobalKey<FormState>();
  bool _isObsecure = true;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'name': '',
    'imageUrl': '',
  };


  var _isLoading = false;
  String email;

  Future<void> _submit() async {
    if (_isLoading == true) {
      return;
    }
    else {
      if (!_formKey.currentState.validate()) {
        // Invalid!
        return;
      }
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Auth>(context, listen: false).login(_authData['email'], _authData['password'], _authData['name'], _authData['imageUrl'], context);
        await Provider.of<Auth>(context, listen: false).visitor(false);
        isVisitor = false;
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MapScreen()));
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

  loginAsVisitor() async {
    final userProvider = Provider.of<Auth>(context, listen: false);
    await userProvider.visitor(true);
    isVisitor = true;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }


  Future<void> resetPassword() async {
    _secondFormKey.currentState.save();
    var errorMessage = 'This email not found!';
    await Provider.of<Auth>(context, listen: false).resetPassword(email).onError((er, error) {
      if (er.toString().contains('badly formatted')) {
        errorMessage = 'Please use a valid email';
      }
      else {
        errorMessage = errorMessage + '!';
        _showErrorDialog(errorMessage);
      }
      _showErrorDialog(errorMessage);
    });
    if (errorMessage == 'This email not found!') {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
              'The reset password link sent to your email',
              style: TextStyle(fontSize: MediaQuery.of(context).orientation == Orientation.landscape ? MediaQuery.of(context).size.height * 0.05 / 1.5 :
              MediaQuery.of(context).size.width * 0.05 / 1.5)
          ),
          backgroundColor: purpleColor,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Ok',
            textColor: greenColor,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
    else {
      return;
    }
  }


  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = (mediaQuery.orientation == Orientation.landscape);
    final size = isLandscape ? screenSize.height * 0.05 : screenSize.width * 0.05;
    final double padding = isLandscape ? screenSize.height * 0.04 : screenSize.width * 0.04;
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Hero(
                      tag: 'iconImage',
                      child: Container(
                        height: isLandscape ? screenSize.width * 0.2 : screenSize.height * 0.25,
                        margin: EdgeInsets.only(top: size),
                        child: Image.asset('images/loginImage.png'),
                      ),
                    ),
                  ),
                  addVerticalSpace(size * 4),
                  Container(
                      padding: EdgeInsets.all(padding),
                      child: Padding(
                        padding: sidePadding,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                    color: Colors.black,
                                    decorationColor: Colors.black,
                                    fontSize: isLandscape ? screenSize.width * 0.018 : screenSize.height * 0.018
                                ),
                                decoration: InputDecoration(
                                    hintText: 'Email',
                                    hintStyle: TextStyle(
                                      color: purpleColor.withOpacity(0.5),
                                      fontSize: size / 1.8,
                                    ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.green,
                                    ),
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
                                  // _authData['name'] = 'hamza';
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
                                        borderSide: BorderSide(
                                          color: Colors.green,
                                        ),
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
                                  suffix: _isObsecure ? InkWell(child:
                                  Text('Show' ,
                                  style:  TextStyle(
                                      fontSize: size / 2,
                                      color: purpleColor,
                                      fontWeight: FontWeight.w700),),
                                    onTap: () {
                                      setState(() {
                                        _isObsecure = !_isObsecure;
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
                                      _isObsecure = !_isObsecure;
                                    });
                                    },
                                  ),
                                ),
                                cursorColor: purpleColor,
                                obscureText: _isObsecure,
                                onSaved: (value) {
                                  _authData['password'] = value;
                                },
                                validator: (value) {
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

                              addVerticalSpace(size / 2),
                              Container(
                                alignment: Alignment.centerLeft,
                                // alignment: Alignment(1.0, 0.0),
                                padding: EdgeInsets.only(top: padding),
                                child: InkWell(
                                  onTap: () {
                                    return showDialog(context: context, builder: (context) => AlertDialog(
                                      title: Text('Please Enter Your Email', style: TEXT_THEME_DEFAULT.headline3.copyWith(color: Colors.green[700], fontSize: isLandscape ? screenSize.width * 0.018 : screenSize.height * 0.018),),
                                      actions: [
                                        TextButton(
                                          child: Text('Done', style: TextStyle(color: Colors.green[700])),
                                          onPressed: () {
                                            final isValid = _secondFormKey.currentState.validate(); {
                                              if (!isValid) {
                                               return;
                                              }
                                              else {
                                                resetPassword();
                                                // Navigator.of(context).pop();
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                      content: Form(
                                        key: _secondFormKey,
                                        child: TextFormField(
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.emailAddress,
                                          style: TextStyle(
                                              color: Colors.green[700],
                                              decorationColor: greenColor,
                                              fontSize: isLandscape ? screenSize.width * 0.018 : screenSize.height * 0.018
                                          ),
                                          decoration: InputDecoration(
                                            hintText: 'Email',
                                            hintStyle: TextStyle(
                                              color: Colors.green[700],
                                              fontSize: size / 1.8,
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.green[700],
                                              ),
                                            ),
                                            errorStyle: TextStyle(
                                              fontSize: size / 2.3,
                                              color: Colors.red,
                                            ),
                                            focusedErrorBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: greenColor,
                                              ),
                                            ),
                                            prefixIcon: Icon(
                                              Icons.email,
                                              size: size,
                                              color: Colors.green[700],
                                            ),
                                          ),
                                          cursorColor: Colors.green[700],
                                          onSaved: (value) {
                                            email = value;
                                            print('fffffffffffffff');
                                            print(email);
                                          },
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Please enter the email';
                                            }
                                            if (value.contains(' ')) {
                                              return 'can\t contain space';
                                            }
                                            if ((value.contains('ج') || value.contains('ح') || value.contains('خ') || value.contains('ه') || value.contains('ع') || value.contains('غ') || value.contains('ف')
                                                || value.contains('ق') || value.contains('ث') || value.contains('ص') || value.contains('ض') || value.contains('ت') || value.contains('ا') || value.contains('ل')
                                                || value.contains('ب') || value.contains('ي') || value.contains('س') || value.contains('ش') || value.contains('ن') || value.contains('م') || value.contains('ك')
                                                || value.contains('ط') || value.contains('د') || value.contains('ظ') || value.contains('ز') || value.contains('ى') || value.contains('ة') || value.contains('و')
                                                || value.contains('ئ') || value.contains('ر') || value.contains('ؤ') || value.contains('ء') || value.contains('ذ') || value.contains('٠') || value.contains('١')
                                                || value.contains('٢') || value.contains('٣') || value.contains('٤') || value.contains('٥') || value.contains('٦') || value.contains('٧') || value.contains('٨')
                                                || value.contains('٩'))) {
                                              return 'Please use english letters';
                                            }
                                            if (value.startsWith('0') || value.startsWith('1') || value.startsWith('2') || value.startsWith('3') || value.startsWith('4') || value.startsWith('5')
                                                || value.startsWith('6') || value.startsWith('7') || value.startsWith('8') || value.startsWith('9')) {
                                              return 'Email can\'t start with number!';
                                            }
                                            if (!value.contains('@') || !value.endsWith('.com')) {
                                              return 'Please enter a valid email';
                                            }
                                            else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                    ),);
                                  },
                                  child: Text(
                                    'Forget Your Password?',
                                    style: TEXT_THEME_DEFAULT.headline1.copyWith(color: Colors.green, fontSize: isLandscape ? screenSize.width * 0.012 : screenSize.height * 0.012, fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  ),
                                ),
                              addVerticalSpace(size * 4),
                              InkWell(
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
                                        'Login',
                                        style: TEXT_THEME_DEFAULT.headline1.copyWith(decoration: TextDecoration.none, color: greenColor, fontSize: isLandscape ? screenSize.width * 0.016 : screenSize.height * 0.016, fontWeight: FontWeight.w700,),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              addVerticalSpace(size),
                              Hero(
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
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Center(
                                          child: Text('Login With Google',
                                            style: TEXT_THEME_DEFAULT.headline1.copyWith(decoration: TextDecoration.none, color: purpleColor, fontSize: isLandscape ? screenSize.width * 0.010
                                                : screenSize.height * 0.010, fontWeight: FontWeight.w700,),
                                          ),
                                        ),
                                        SizedBox(width: size / 1.5),
                                        Center(
                                          child: Icon(LineAwesomeIcons.google_plus, size: size * 1.5, color: purpleColor,),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  addVerticalSpace(size),
                  Padding(
                    padding: EdgeInsets.only(bottom: padding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        addHorizontalSpace(size / 4),
                        InkWell(
                          onTap: loginAsVisitor,
                          child: Text(
                            'Login as a visitor',
                            style: TEXT_THEME_DEFAULT.headline1.copyWith(color: Colors.green, fontSize: isLandscape ? screenSize.width * 0.010 : screenSize.height * 0.012, fontWeight: FontWeight.w700,),
                          ),
                        ),
                        addHorizontalSpace(size / 2),
                        Text(
                          'or',
                          style: TEXT_THEME_DEFAULT.headline1.copyWith(color: purpleColor, fontSize: isLandscape ? screenSize.width * 0.013 : screenSize.height * 0.015, fontWeight: FontWeight.w700,),
                        ),
                        addHorizontalSpace(size / 2),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupScreen()));
                          },
                          child: Text(
                            'Create new account',
                            style: TEXT_THEME_DEFAULT.headline1.copyWith(color: Colors.green, fontSize: isLandscape ? screenSize.width * 0.010 : screenSize.height * 0.012, fontWeight: FontWeight.w700,),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
