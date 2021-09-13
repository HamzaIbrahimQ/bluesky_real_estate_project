import 'package:bluesky_project/screens/homeScreen.dart';
import 'package:bluesky_project/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:bluesky_project/providers/auth.dart';
import 'package:bluesky_project/providers/location_provider.dart';
import 'package:bluesky_project/providers/housesProvider.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/loginScreen.dart';
import 'package:bluesky_project/screens/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';




bool isFirstRun = false;
bool isVisitor = false;


void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(0xffffffff),
    systemNavigationBarColor: Color(0xffffffff),
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((instance) {
    isFirstRun = instance.getBool('fRun') == null || instance.getBool('fRun') == true ? true : false;
    isVisitor = instance.getBool('visitor') == true ? true : instance.getBool('fRun') == null || instance.getBool('fRun') == false ? false : false;
    print('is fiiiiirsttt runnnnn???');
    print(isFirstRun);
    print('is visitooooorrrrrr ???');
    print(isVisitor);
    runApp(MyApp(),);
  });

}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> {


  // bool isVisitor = false



  // Future<void> visitor() async {
  //   final userProvider = Provider.of<Auth>(context, listen: false);
  //   userProvider.isVisitor = isVisitor;
  //   print('are youuuuu visitooooorrrrr??');
  //   print(userProvider.isVisitor);
  // }

  // Future<void> visitor() async {
  //   final prefs = await SharedPreferences.getInstance().then((value) => isVisitor = value.getBool('visitor'));
  //   if (isVisitor == null) {
  //     isVisitor = false;
  //   }
  //   return isVisitor;
  // }

  // Future<void> getFirstrun() async {
  //   await SharedPreferences.getInstance().then((value) => isFirstRun = value.getBool('fRun'));
  //   if (isFirstRun == null) {
  //     isFirstRun = false;
  //   }
  //   isFirstRun = true;
  //   print('kokokoko');
  //   print(isFirstRun);
  //   return isFirstRun;
  // }


  // @override
  // void initState() {
  // visitor();
  // super.initState();
  // }


  @override
  Widget build(BuildContext context) {
    // visitor();
    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(
    //       statusBarColor: Colors.white,
    //       systemNavigationBarColor: Color(0xFFB40284A),
    //     ),
    // );
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocationProvider(),
        ),
        ChangeNotifierProxyProvider<Auth, Houses>(
          create: (_) => Houses('', '', []),
          update: (context, auth, previousProducts) =>
              Houses(auth.token, auth.userId, previousProducts.houses),
        ),
      ],
      child: isVisitor ? MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Montserrat',
        ),
        home: HomeScreen()
      ) : Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Montserrat',
          ),
          home: auth.isAuth
              ? isFirstRun ? OnboardingScreen() : HomeScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : isFirstRun ? OnboardingScreen() : LoginScreen(),
                ),
        ),
      ),
    );
  }
}
