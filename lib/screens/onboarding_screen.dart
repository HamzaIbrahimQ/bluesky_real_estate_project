import 'package:bluesky_project/main.dart';
import 'package:bluesky_project/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bluesky_project/providers/auth.dart';



class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.red : Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }


  // Future<void> setFirstRun() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('fRun', true);
  // }

  @override
  Widget build(BuildContext context) {


    final mediaQuery = MediaQuery.of(context);
    final isLandscape = (mediaQuery.orientation == Orientation.landscape);
    final Size screenSize = MediaQuery.of(context).size;
    final size = isLandscape ? screenSize.height * 0.05 : screenSize.width * 0.05;
    final double padding = isLandscape ? screenSize.height * 0.04 : screenSize.width * 0.04;
    // final sidePadding = EdgeInsets.symmetric(horizontal: padding);
    final userProvider = Provider.of<Auth>(context);


    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: padding / 3, right: padding),
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: ()  {
                    userProvider.setFirstRun();
                    setState(() {
                      isFirstRun = false;
                    });
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: size,
                    ),
                  ),
                ),
              ),
              Container(
                height: screenSize.height * 0.8,
                child: PageView(
                  physics: ClampingScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(padding * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Image(
                              image: AssetImage(
                                'images/onboarding0.png',
                              ),
                              height: screenSize.height * 0.4,
                              width: screenSize.width * 0.8,
                            ),
                          ),
                          addVerticalSpace(padding * 2),
                          Text(
                            'Live your life smarter\nwith us!',
                            style: TextStyle(
                              fontSize: size,
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                            ),
                          ),
                          addVerticalSpace(padding),
                          Text(
                            'Lorem ipsum dolor sit amet, consect adipiscing elit, sed do eiusmod tempor incididunt ut labore et.',
                            style: TextStyle(
                              fontSize: size * 0.7,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(padding * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Image(
                              image: AssetImage(
                                'images/onboarding1.png',
                              ),
                              height: screenSize.height * 0.4,
                              width: screenSize.width * 0.8,
                            ),
                          ),
                          addVerticalSpace(padding * 2),
                          Text(
                            'Live your life smarter\nwith us!',
                            style: TextStyle(
                              fontSize: size,
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                            ),
                          ),
                          addVerticalSpace(padding),
                          Text(
                            'Lorem ipsum dolor sit amet, consect adipiscing elit, sed do eiusmod tempor incididunt ut labore et.',
                            style: TextStyle(
                              fontSize: size * 0.7,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(padding * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Image(
                              image: AssetImage(
                                'images/onboarding2.png',
                              ),
                              height: screenSize.height * 0.4,
                              width: screenSize.width * 0.8,
                            ),
                          ),
                          addVerticalSpace(padding * 2),
                          Text(
                            'Get a new experience\nof imagination',
                            style: TextStyle(
                              fontSize: size,
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                            ),
                          ),
                          addVerticalSpace(padding),
                          Text(
                            'Lorem ipsum dolor sit amet, consect adipiscing elit, sed do eiusmod tempor incididunt ut labore et.',
                            style: TextStyle(
                              fontSize: size * 0.7,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(),
              ),
              _currentPage != _numPages - 1
                  ? Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: padding, right: padding / 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Next',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: size,
                            ),
                          ),
                          addHorizontalSpace(8.0),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                            size: size * 1.4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
                  : Text(''),
            ],
          ),
        ),
        bottomSheet: _currentPage == _numPages - 1
            ? Container(
          height: screenSize.height * 0.15,
          width: double.infinity,
          color: Colors.black,
          child: GestureDetector(
            onTap: ()  {
              userProvider.setFirstRun();
              setState(() {
                isFirstRun = false;
              });
            },
            child: Center(
              child: Text(
                'Get started',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )
            : Text(''),
      ),
    );
  }
}